import subprocess
from glob import glob
from collections import defaultdict
from os import path, getcwd
import shutil
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('samples', type=str, help='Path to directory with samples batch')
parser.add_argument('db', type=str, help='Path to ready-to-work mmseqs2 reference database')
parser.add_argument('contamination', type=str, help='Path to file with contamination data in fasta format')
parser.add_argument('input_type', type=int,
                    help='Specify input type: '
                         '1 - give only one file for analysis (assembly) '
                         '2 - give two files for analysis (forward and reverse reads)')
parser.add_argument('-t', '--threads', type=int)
args = parser.parse_args()

if args.threads:
    threads = args.threads
else:
    threads = 3

contaminant_file = args.contamination
ref_database = args.db
path_to_workdir = getcwd()


def run_pipeline(path_to_workdir, sample, cmd):
    if path.exists(f"{path_to_workdir}/{sample}"):
        print(f"{sample} is ready")
    else:
        print(f"Start {' '.join(cmd)}")
        try:
            process = subprocess.run(cmd, check=True)
            print(f"Finished {process.args}")
            if path.exists(f"{path_to_workdir}/{sample}"):
                print(f"Sample {sample} now ready! We should remove cache")
                shutil.rmtree(f"{path_to_workdir}/{sample}_cache")
        except subprocess.SubprocessError:
            print(f"Fail sample: {sample}")
            pass


if args.input_type == 2:
    samples = glob(args.samples)
    sample_list = defaultdict(list)

    for sample in samples:
        sample_name = sample.split('/')[-1].split('__')[0]
        if sample not in sample_list[sample_name]:
            sample_list[sample_name].append(sample)

    print(f"Found samples: {sample_list}")

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
        run_pipeline(path_to_workdir, sample, cmd)

if args.input_type == 1:
    samples = glob(args.samples)
    print(f"Found samples: {samples}")

    for sample in samples:
        sample_name = sample.split('_rnaspades')[0]
        sample_name = sample_name.split('/')[-1]
        cmd = (
            "cwltool",
            "--cachedir", f"{sample_name}_cache",
            "--outdir", sample_name,
            "pipeline_wo_assembly.cwl",
            "--forward_reads", f"{sample}",
            "--contaminant_file", f"{contaminant_file}",
            "--ref_database", f"{ref_database}",
            "--threads", f"{threads}"
        )
        run_pipeline(path_to_workdir, sample, cmd)
