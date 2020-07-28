cwlVersion: v1.1
class: CommandLineTool
label: MMSeqs report generator module wrapper

requirements:
  - class: DockerRequirement
    dockerPull: 'soedinglab/mmseqs2:version-11'
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.mount_directory)

baseCommand: ['mmseqs', 'taxonomyreport']

inputs:
  ref_database:
    type: File
    inputBinding:
      position: 1
    secondaryFiles: ['.dbtype', '_delnodes.dmp', '_h', '_h.dbtype', '_h.index', '.lookup', '_mapping', '_merged.dmp', '_names.dmp', '_nodes.dmp', '.source', '.index']

  tax_reads_database_name:
    type: string
    inputBinding:
      position: 2

  result_report_name:
    type: string
    inputBinding:
      position: 3

  change_report_mode:
    type: int?
    inputBinding:
      prefix: '--report-mode'

  threads:
    type: int
    inputBinding:
      prefix: '--threads'

  mount_directory:
    type: Directory

outputs:
  result_report:
    type: File
    outputBinding:
      glob: $(inputs.result_report_name)

