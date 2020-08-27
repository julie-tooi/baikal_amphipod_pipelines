from collections import defaultdict
from glob import glob
# import re

path_to_folders_with_reports = "/home/julie/study_IB/summer_baikal/DATA/*"
path_to_tsv_file = "/home/julie/study_IB/summer_baikal/total.tsv"

samples = glob(path_to_folders_with_reports)

data_per_sample = defaultdict(list)

for sample in samples:
    sample_name = sample.split("/")[-1]

    path_to_trim_report = f"{sample}/stats_log_after_contamination_clearing"
    path_to_kraken_report = f"{sample}/kraken"

    with open(path_to_trim_report, "r") as trim_file_handler:
        trim_file_handler.readline()  # skip header

        total_reads_processed = trim_file_handler.readline().strip().split("\t")
        matched_reads = trim_file_handler.readline().strip().split("\t")

        reads_count_after_filtration = int(total_reads_processed[1]) - int(matched_reads[1])

        reads_after_filtration = [f"{reads_count_after_filtration}", "all_reads", "-", sample_name]
        data_per_sample[sample_name].append(reads_after_filtration)

    with open(path_to_kraken_report, "r") as kraken_file_handler:
        # inside_clade = False
        for line in kraken_file_handler:
            line = line.strip().split("\t")
            # if line[3] == "clade":
            #     inside_clade = bool(re.search("Alveolata", line[5]))
            has_sufficient_coverage = int(line[1]) > 50

            if has_sufficient_coverage:
                useful_data = [line[1], line[3], line[5].lstrip(), sample_name]

                data_per_sample[sample_name].append(useful_data)


for sample in data_per_sample:
    for data in data_per_sample[sample]:
        print("\t".join(data) + "\r")

        with open(path_to_tsv_file, "a") as report_file_handler:
            report_file_handler.write("\t".join(data) + "\r")
