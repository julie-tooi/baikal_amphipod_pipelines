import subprocess
from glob import glob
from collections import defaultdict
from os import path, getcwd
from enum import IntEnum
import shutil
import argparse
import logging

logging.basicConfig(level=logging.INFO)

class InputType(IntEnum):
    ASSEMBLY = 1
    PAIRED_READS = 2


def run_pipeline(path_to_workdir, sample, cmd):
    if path.exists(f"{path_to_workdir}/{sample}"):
        logging.info(f"{sample} is ready")
        return

    logging.info(f"Start {' '.join(cmd)}")
    try:
        process = subprocess.run(cmd, check=True)
        logging.info(f"Finished {process.args}")
        if path.exists(f"{path_to_workdir}/{sample}"):
            logging.info(f"Sample {sample} is ready! We should remove cache")
            shutil.rmtree(f"{path_to_workdir}/{sample}_cache")
    except subprocess.SubprocessError:
        logging.info(f"Fail sample: {sample}")


def analyze_assembly(path_to_workdir, contaminant_file, ref_database, threads, pattern):
    samples = glob(args.samples)
    logging.info(f"Found samples: {samples}")
    for sample in samples:
        sample_name = path.basename(sample).split(pattern)[0]
        cmd = (
            "cwltool",
            "--cachedir", f"{sample_name}_cache",
            "--outdir", sample_name,
            "k-mer_based_pipelines/kmer_pipeline_with_prefilter.cwl",
            "--forward_reads", f"{sample}",
            "--contaminant_file", f"{contaminant_file}",
            "--ref_database", f"{ref_database}",
            "--threads", f"{threads}"
        )
        run_pipeline(path_to_workdir, sample_name, cmd)


def analyze_paired_reads(path_to_workdir, contaminant_file, ref_database, threads, pattern):
    fastq_files_paths = glob(args.samples)
    samples = defaultdict(list)
    for fastq_file_path in fastq_files_paths:
        sample_name = path.basename(fastq_file_path).split(pattern)[0]
        if fastq_file_path not in samples[sample_name]:
            samples[sample_name].append(fastq_file_path)
    logging.info(f"Found {len(samples)} samples: {tuple(samples.keys())}")
    for sample in samples:
        forward_reads, reverse_reads = sorted(samples[sample])

        cmd = (
            "cwltool",
            "--cachedir", f"{sample}_cache",
            "--outdir", sample,
            "k-mer_based_pipelines/kmer_pipeline_with_prefilter.cwl",
            "--forward_reads", f"{forward_reads}",
            "--reverse_reads", f"{reverse_reads}",
            "--contaminant_file", f"{contaminant_file}",
            "--ref_database", f"{ref_database}",
            "--threads", f"{threads}"
        )
        run_pipeline(path_to_workdir, sample, cmd)


def main(input_type, ref_database, threads, contaminant_file, path_to_workdir, pattern):
    analyzers = {
        InputType.PAIRED_READS: analyze_paired_reads,
        InputType.ASSEMBLY: analyze_assembly,
    }
    analyzers[input_type](path_to_workdir, contaminant_file, ref_database, threads, pattern)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--samples', type=str, help='Path to samples batch', required=True)
    parser.add_argument('-db', '--database', type=str, help='Path to ready-to-work mmseqs2 reference database', required=True)
    parser.add_argument('-c','--contamination', type=str, help='Path to file with contamination data in fasta format', required=True)
    parser.add_argument(
        '-type','--input_type',
        type=int,
        help='Specify input type: '
             '1 - give only one file for analysis (assembly) '
             '2 - give two files for analysis (forward and reverse reads)',
        choices=[1, 2],
        required=True
    )
    parser.add_argument('-p', '--pattern', type=str,
        help='Pattern that used to split sample name: '
             'For example, file name is: "/path/to/file/sample_1_rnasades_assembly.fasta" '
             'To get file name, we need split it by pattern "_rnaspades_"', required=True)
    parser.add_argument('-t', '--threads', type=int, default=3)
    args = parser.parse_args()
    print(args)

    main(
        input_type=args.input_type,
        ref_database=args.database,
        threads=args.threads,
        contaminant_file=args.contamination,
        pattern=args.pattern,
        path_to_workdir=getcwd()
    )
