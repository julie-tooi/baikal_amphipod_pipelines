cwlVersion: v1.1
class: CommandLineTool
label: MMSeqs2 taxonomy module wrapper

requirements:
  - class: DockerRequirement
    dockerPull: 'soedinglab/mmseqs2:version-11'
  - class: InlineJavascriptRequirement
#  - class: InitialWorkDirRequirement
#    listing:
#      - entry: "$({class: 'Directory', listing: []})"
#        entryname: $(inputs.result_filtered_db_file_name)
#        writable: true
#    listing:
#      - entry: "$({class: 'Directory', listing: []})"
#        entryname: $(inputs.result_filtered_db_file_name)
#        writable: true
#        entryname:
#      - class: Directory
#        basename: $(inputs.result_filtered_db_file_name.split("/")[0])

baseCommand: ['mmseqs', 'taxonomy']

inputs:
  reads_db:
    type: File
    inputBinding:
      position: 1
    secondaryFiles: ['.dbtype', '_h', '_h.dbtype', '_h.index', '.source', '.index', '.lookup']

  ref_db:
    type: File
    inputBinding:
      position: 2
    secondaryFiles: ['.dbtype', '_delnodes.dmp', '_h', '_h.dbtype', '_h.index', '.lookup', '_mapping', '_merged.dmp', '_names.dmp', '_nodes.dmp', '.source', '.index']

  result_filtered_db_file_name:
    type: string
    inputBinding:
      position: 3

  tempotaty_directory_name:
    type: string
    inputBinding:
      position: 4

  analysis_sensivity:
    type: float
    inputBinding:
      prefix: '-s'

  threads:
    type: int
    inputBinding:
      prefix: '--threads'

outputs:
  result_DB:
    type: File[]
    outputBinding:
      glob: $(inputs.result_filtered_db_file_name + '*')


