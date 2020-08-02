cwlVersion: v1.1
class: Workflow
doc: Pipeline to metatranscriptomic analysis (without assembly)

requirements:
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  forward_reads:
    type: File
  reverse_reads:
    type: File
  contaminant_file:
    type: File
  ref_database:
    type: File
    secondaryFiles: ['.dbtype', '_delnodes.dmp', '_h', '_h.dbtype', '_h.index', '.lookup', '_mapping', '_merged.dmp', '_names.dmp', '_nodes.dmp', '.source', '.index']
  threads:
    type: int
    default: 2

outputs:
  stats_log_after_contamination_clearing:
    type: File
    outputSource: pipeline_wo_assembly/stats_log_after_contamination_clearing

  kraken_report:
    type: File
    outputSource: generate_report/report_kraken

  krona_report:
    type: File
    outputSource: generate_report/report_krona

steps:
  pipeline_wo_assembly:
    run: pipeline_wo_assembly.cwl
    in:
      forward_reads: forward_reads
      reverse_reads: reverse_reads
      contaminant_file: contaminant_file
      ref_database: ref_database
      threads: threads
    out: [reads_database_after_tax_analysis, stats_log_after_contamination_clearing]

  generate_report:
    run: pipeline_generate_report.cwl
    in:
      db_files: pipeline_wo_assembly/reads_database_after_tax_analysis
      ref_database: ref_database
      tax_reads_database_name:
        source: pipeline_wo_assembly/reads_database_after_tax_analysis
        valueFrom: $(self[0].nameroot)
    out: [report_kraken, report_krona]
