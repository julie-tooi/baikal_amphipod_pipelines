cwlVersion: v1.1
class: Workflow
doc: |
  Part of pipelines, using MMSeqs2.
  This pipeline generate two reports: in Kraken and Krona style.

inputs:
  db_files:
    type: File[]

  ref_database:
    type: File
    secondaryFiles: ['.dbtype', '_delnodes.dmp', '_h', '_h.dbtype', '_h.index', '.lookup', '_mapping', '_merged.dmp', '_names.dmp', '_nodes.dmp', '.source', '.index']
    doc: predprocessing MMseqs2 taxonomy database

  threads:
    type: int
    default: 2

  tax_reads_database_name:
    type: string

outputs:
  report_kraken:
    type: File
    outputSource: generate_kraken_report/result_report
    doc: kraken-style report, contain data with count reads, mapping on different taxons

  report_krona:
    type: File
    outputSource: generate_krona_report/result_report
    doc: krona-style report, html file with visualisation taxonomy assigment

steps:
  generate_kraken_report:
    run: mmseqs/mmseqs_taxonomyreport.cwl
    in:
      files: db_files
      ref_database: ref_database
      tax_reads_database_name: tax_reads_database_name
      result_report_name:
        default: 'kraken'
      threads: threads
    out: [result_report]

  generate_krona_report:
    run: mmseqs/mmseqs_taxonomyreport.cwl
    in:
      files: db_files
      ref_database: ref_database
      tax_reads_database_name: tax_reads_database_name
      result_report_name:
        default: 'krona.html'
      change_report_mode:
        default: 1
      threads: threads
    out: [result_report]

