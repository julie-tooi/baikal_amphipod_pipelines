cwlVersion: v1.1
class: Workflow
doc: |
  Part of pipeline without assembly.
  Consist of the following steps
  - contamination clearing,
  - creating mmseqs database,
  - taxonomy analysis.

inputs:
  forward_reads:
    type: File
    doc: fastq.gz or fastq format

  reverse_reads:
    type: File
    doc: fastq.gz or fastq format

  contaminant_file:
    type: File
    doc: fasta format

  ref_database:
    type: File
    secondaryFiles: ['.dbtype', '_delnodes.dmp', '_h', '_h.dbtype', '_h.index', '.lookup', '_mapping', '_merged.dmp', '_names.dmp', '_nodes.dmp', '.source', '.index']
    doc: predprocessing MMseqs2 taxonomy database

  threads:
    type: int
    default: 2

outputs:
  reads_database_after_tax_analysis:
    type: File[]
    outputSource: taxonomy_analysis/tax_reads_database
    doc: taxonomy assigned reads, ready to report generation

  stats_log_after_contamination_clearing:
    type: File
    outputSource: clean_out_contamination/stats_bbduk_log_file
    doc: file with statistics after contamination clearing

steps:
  clean_out_contamination:
    run: bbduk/bbduk.cwl
    in:
      memory_usage:
        default: '2g'
      forward_reads: forward_reads
      reverse_reads: reverse_reads
      output_file_name:
        default: 'reads_without_contamination.fq'
      contaminant_file: contaminant_file
      kmer_length:
        default: 50
      humming_distance:
        default: 0
      threads: threads
      stats_log_file_name:
        default: 'stats_log_after_contamination_clearing'
    out: [filtered_reads, stats_bbduk_log_file]

  create_query_database:
    run: mmseqs/mmseqs_createdb.cwl
    in:
      filtered_reads: clean_out_contamination/filtered_reads
      reads_database_name:
        default: 'analysed_reads_mmseqsdb'
    out: [filtered_reads_mmseqsdb]

  taxonomy_analysis:
    run: mmseqs/mmseqs_taxonomy.cwl
    in:
      filtered_reads_mmseqsdb: create_query_database/filtered_reads_mmseqsdb
      ref_database: ref_database
      result_filtered_db_file_name:
        default: 'taxonomy_analysis_db'
      tempotaty_directory_name:
        default: 'tmp'
      analysis_sensivity:
        default: 7.5
      kmer_matching:
        default: 1
      ungapped_score:
        default: 30
      threads: threads
    out: [tax_reads_database]
