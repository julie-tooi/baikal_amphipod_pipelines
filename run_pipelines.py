import subprocess
from glob import glob
from collections import defaultdict
from os import path, chdir, getcwd
import shutil

path_to_samples = "/home/julie/study_IB/summer_baikal/real_data_to_test/*.fasta"
ref_database = "/home/julie/study_IB/summer_baikal/DB/swisspwot-coi.fasta.DB"
contaminant_file = "/home/julie/study_IB/summer_baikal/Gamm_rRNA_DB_with_lacustris/EveNEB_muscle.filtered.fasta"
path_to_workdir = getcwd()

threads = 3

samples = glob(path_to_samples)
sample_list = defaultdict(list)

for sample in samples:
    sample_name = sample.split('/')[-1].split('__')[0]
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
print(' '.join(cmd))

    # if path.exists(f"{path_to_workdir}/{sample}"):
    #     print(f"{sample} is ready")
    #
    # else:
    #     print(f"Start {' '.join(cmd)}")
    #     try:
    #         process = subprocess.run(cmd, check=True)
    #         print(f"Finished {process.args}")
    #         if path.exists(f"{path_to_workdir}/{sample}"):
    #             print(f"Sample {sample} now ready! We should remove cache")
    #             shutil.rmtree(f"{path_to_workdir}/{sample}_cache")
    #     except subprocess.SubprocessError:
    #         print(f"Fail sample: {sample}")
    #         pass
