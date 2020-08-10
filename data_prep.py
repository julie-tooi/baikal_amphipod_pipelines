# Sample preparation: provide adapter and quality trimming, rRNA clearing
import shutil
import subprocess
from collections import defaultdict
from glob import glob
from os import  remove

path_to_dirs_with_samples = "/home/julie/study_IB/summer_baikal/automt_test/example_files/*"
path_to_trimmomatic = "/home/julie/tools/Trimmomatic-0.39/trimmomatic-0.39.jar"
path_to_adapters = "/home/julie/study_IB/summer_baikal/automt_test/adapter.fasta"
path_to_workdir = "/prepare_test/"
path_to_rrna_db = "/home/julie/study_IB/summer_baikal/Gamm_rRNA_DB_with_lacustris/Gamm_rRNA_with_GL_DB"
threads = 2

dirs_with_samples = glob(path_to_dirs_with_samples)

sample_list = defaultdict(list)

for dir in dirs_with_samples:
    path_to_samples = f"{dir}/*"
    samples = glob(path_to_samples)
    dir_name = dir.split('/')[-1]

    if dir_name not in sample_list:
        sample_list[dir_name]
        for sample in samples:
            sample_list[dir_name].append(sample)

# Quality and adapter trim
for sample in sample_list:
    sample_list[sample].sort()
    forward_reads = sample_list[sample][0]
    reverse_reads = sample_list[sample][1]
    cmd = (
        "java", "-jar", path_to_trimmomatic, "PE",
        "-threads", f"{threads}", "-phred33",
        "-trimlog", f"{sample}_trimlog",
        forward_reads, reverse_reads,
        f"{sample}__1_forward_paired____trimmed.fq.gz", f"{sample}_forward_unpaired.fq.gz",
        f"{sample}__2_reverse_paired____trimmed.fq.gz", f"{sample}_reverse_unpaired.fq.gz",
        f"ILLUMINACLIP:{path_to_adapters}:2:30:10",
        "LEADING:20", "TRAILING:20", "SLIDINGWINDOW:10:20", "MINLEN:20"
    )
    print(f"Start {' '.join(cmd)}")
    process = subprocess.run(
        cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    print(list(filter(lambda it: it.startswith('Input Read'), process.stderr.decode().split('\n'))))
    print(f"Finished {process.args}")

files_for_delete = glob(f"{path_to_workdir}*unpaired.fq.gz")
for file in files_for_delete:
    remove(file)

# rRNA clearing
# Mapping reads
trimmed_samples = glob(f"{path_to_workdir}*____trimmed.fq.gz")

sample_list = defaultdict(list)

for sample in trimmed_samples:
    sample_name = sample.split('/')[-1].split("__")[0]
    if sample_name not in sample_list:
        sample_list[sample_name]
    if sample not in sample_list[sample_name]:
        sample_list[sample_name].append(sample)

for sample in sample_list:
    sample_list[sample].sort()
    forward_reads = sample_list[sample][0]
    reverse_reads = sample_list[sample][1]
    cmd = (
        "bowtie2",
        "-x", path_to_rrna_db,
        "-1", forward_reads,
        "-2", reverse_reads,
        "-S", f"{sample}_mapped_and_unmapped.sam"
    )
    print(f"Start {' '.join(cmd)}")
    process = subprocess.run(
        cmd, check=True
    )
    print(f"Finished {process.args}")

# Convert .sam to .bam
map_unmap_samples_sam = glob(f"{path_to_workdir}*_mapped_and_unmapped.sam")

for sample in map_unmap_samples_sam:
    cmd = (
        "samtools", "view", "-bS",
        sample, ">", f"{sample.split('.sam')[0]}.bam"
    )
    print(f"Start {' '.join(cmd)}")
    process = subprocess.run(
        cmd, check=True, shell=True
    )

# Take only unmapped ones
map_unmap_samples_bam = glob(f"{path_to_workdir}*_mapped_and_unmapped.bam")

for sample in map_unmap_samples_bam:
    cmd = (
        "samtools", "view",
        "-b", "-f", "12", "-F" "256",
        sample, ">", f"{sample.split('_mapped_')[0]}_both_unmapped.bam"
    )
    print(f"Start {' '.join(cmd)}")
    process = subprocess.run(
        cmd, check=True, shell=True
    )

# Sort unmapped samples
unmap_samples_bam = glob(f"{path_to_workdir}*_both_unmapped.bam")

for sample in unmap_samples_bam:
    cmd = (
        "samtools", "sort",
        "-n", sample, f"{sample.split('_both_unmapped')[0]}_sorted"
    )
    print(f"Start {' '.join(cmd)}")
    process = subprocess.run(
        cmd, check=True, shell=True
    )

# Take R1 and R2 reads again
sorted_samples = glob(f"{path_to_workdir}_sorted")

for sample in sorted_samples:
    cmd = (
        "bedtools", "bamtofastq",
        "-i", sample,
        "-fq", f"{sample.split('_sorted')[0]}_wo_rrna_R1.fastq", f"{sample.split('_sorted')[0]}_wo_rrna_R2.fastq"
    )
    print(f"Start {' '.join(cmd)}")
    process = subprocess.run(
        cmd, check=True, shell=True
    )

files_for_delete = glob(f"{path_to_workdir}*am")
for file in files_for_delete:
    remove(file)
