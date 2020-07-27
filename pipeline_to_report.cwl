cwlVersion: v1.1
class: Workflow

inputs:
  forward_reads: File
  reverse_reads: File
  contaminant_file: File
  ref_database:
    type: File
    secondaryFiles: ['.dbtype', '_delnodes.dmp', '_h', '_h.dbtype', '_h.index', '.lookup', '_mapping', '_merged.dmp', '_names.dmp', '_nodes.dmp', '.source', '.index']

  threads:
    type: int
    default: 2

outputs:
  result_DB:
    type: File[]
    outputSource: taxonomy_analysis/result_DB

  stats_log_file:
    type: File
    outputSource: clean_out_contamination/stats_log_file

steps:
  clean_out_contamination:
    run: bbduk/bbduk.cwl
    in:
      memory_usage:
        default: '2g'
      forward_reads: forward_reads
      reverse_reads: reverse_reads
      output_file_name:
        default: 'clean_cont_output.fq'
      contaminant_file: contaminant_file
      kmer_length:
        default: 50
      humming_distance:
        default: 0
      threads: threads
      stats_log_file_name:
        default: 'test_stats_after_cont'
    out: [filtered_reads, stats_log_file]

  create_analysis_db:
    run: mmseqs/mmseqs_createdb.cwl
    in:
      filtered_reads: clean_out_contamination/filtered_reads
      reads_db_name:
        default: 'analysed_reads_db'
    out: [filtered_reads_mmseqdb]

  taxonomy_analysis:
    run: mmseqs/mmseqs_taxonomy.cwl
    in:
      reads_db: create_analysis_db/filtered_reads_mmseqdb
      ref_db: ref_database
      result_filtered_db_file_name:
        default: 'taxonomy_analysis_db'
      tempotaty_directory_name:
        default: 'tmp'
      analysis_sensivity:
        default: 7.5
      threads: threads
    out: [result_DB]
