import subprocess
from glob import glob
from collections import defaultdict

path_to_samples = "/*"
ref_database = ".DB"
contaminant_file = "EveNEB_muscle.filtered.fasta"
threads = 2

samples = glob(path_to_samples)
sample_list = defaultdict(list)

for sample in samples:
    sample_name = sample.split('/')[-1].split('_L001_R')[0]
    if sample_name not in sample_list:
        sample_list[sample_name]
    if sample not in sample_list[sample_name]:
        sample_list[sample_name].append(sample)

print(f"Found samples: {sample_list}")

for sample, reads in sample_list.items():
    print(f"Sample: {sample, reads}")

for sample in sample_list:
    sample_list[sample].sort()
    forward_reads = sample_list[sample][0]
    reverse_reads = sample_list[sample][1]
    print(f"reads: {forward_reads, reverse_reads}")
    cmd = (
        "cwltool",
        "--cachedir", f"{sample}_cache",
        "--outdir", sample,
        "pipeline_wo_assembly.cwl",
        "--forward_reads", f"{forward_reads}",
        "--reverse_reads", f"{reverse_reads}",
        "--contaminant_file", f"{contaminant_file}",
        "--ref_database", f"{ref_database}",
        "--threads", f"{threads}"
    )
    print(f"Start {' '.join(cmd)}")
    process = subprocess.run(
        cmd, check=True
    )
    print(f"Finished {process.args}")
