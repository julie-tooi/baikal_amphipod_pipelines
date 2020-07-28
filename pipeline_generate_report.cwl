cwlVersion: v1.1
class: Workflow

inputs:
  mount:
    type: Directory

  ref_database:
    type: File
    secondaryFiles: ['.dbtype', '_delnodes.dmp', '_h', '_h.dbtype', '_h.index', '.lookup', '_mapping', '_merged.dmp', '_names.dmp', '_nodes.dmp', '.source', '.index']

  threads:
    type: int
    default: 2

outputs:
  report_kraken:
    type: File
    outputSource: generate_kraken_report/result_report

  report_krona:
    type: File
    outputSource: generate_krona_report/result_report

steps:
  generate_kraken_report:
    run: mmseqs/mmseqs_taxonomyreport.cwl
    in:
      mount_point: mount
      ref_database: ref_database
      result_DB:
        default: 'data_to_report/taxonomy_analysis_db'
      result_report_name:
        default: 'kraken'
      threads: threads
    out: [result_report]

  generate_krona_report:
    run: mmseqs/mmseqs_taxonomyreport.cwl
    in:
      mount_point: mount
      ref_database: ref_database
      result_DB:
        default: 'data_to_report/taxonomy_analysis_db'
      result_report_name:
        default: 'krona.html'
      change_report_mode:
        default: 1
      threads: threads
    out: [result_report]

