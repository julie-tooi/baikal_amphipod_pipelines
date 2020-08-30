cwlVersion: v1.1
class: CommandLineTool
label: MMSeqs2 taxonomy module wrapper

requirements:
  - class: DockerRequirement
    dockerPull: 'soedinglab/mmseqs2:version-11'
  - class: InlineJavascriptRequirement

baseCommand: ['mmseqs', 'taxonomy']

inputs:
  filtered_reads_mmseqsdb:
    type: File
    inputBinding:
      position: 1
    secondaryFiles: ['.dbtype', '_h', '_h.dbtype', '_h.index', '.source', '.index', '.lookup']

  ref_database:
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
    type: float?
    inputBinding:
      prefix: '-s'

  kmer_matching:
    type: int?
    inpupBinding:
      prefix: '--exact-kmer-matching'

  ungapped_score:
    type: int?
    inputBinding:
      prefix: '--min-ungapped-score'

  threads:
    type: int
    inputBinding:
      prefix: '--threads'

outputs:
  tax_reads_database:
    type: File[]
    outputBinding:
      glob: $(inputs.result_filtered_db_file_name + '*')


