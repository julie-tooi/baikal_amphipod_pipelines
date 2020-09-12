from collections import defaultdict
from glob import glob
import os
import shutil
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-f', '--folders', type=str, help='Path to folders with reports', required=True)
parser.add_argument('-o', '--output', type=str, help='Path to reports output', required=True)
args = parser.parse_args()

path_to_folders_with_reports = args.folders
path_to_batch = args.output

# path_to_folders_with_reports = "/home/julie/study_IB/summer_baikal/RESULTS/uniprot_pipeline_reports/reports_uniprot_coi_assembly_1_1_15/*"
# path_to_batch = "/home/julie/study_IB/summer_baikal/DATA/kraken"

folders_wit_results = glob(os.path.join(path_to_folders_with_reports, '*'))

for folder in folders_wit_results:
    sample_name = folder.split("/")[-1]
    old_sample_name = os.path.join(folder, 'kraken')
    new_sample_name = os.path.join(folder, sample_name)
    if os.path.exists(os.path.join(path_to_batch, sample_name)):
        print(f'{sample_name} exists')
        continue
    else:
        os.rename(old_sample_name, new_sample_name)
        shutil.copy2(new_sample_name, path_to_batch)

# reports = glob(os.path.join(path_to_batch, '*.tsv'))
#
#
#
# for report in reports:
#     colnames_check = []
#     header = None
#     with open(report, 'r') as in_f:
#         col_names = in_f.readline().strip().split('\t')
#         for name in col_names:
#             colname = name.strip('."').split('.clade')[0]
#             colnames_check.append(colname)
#             header = "\t".join(colnames_check)
#         with open(f"{report.split('.')[0]}__processed.tsv", "w") as out_f:
#             out_f.write(f"{header}\n")
#             shutil.copyfileobj(in_f, out_f)


