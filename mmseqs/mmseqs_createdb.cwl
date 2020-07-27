cwlVersion: v1.1
class: CommandLineTool
label: MMSeqs2 create DB module wrapper

requirements:
  - class: DockerRequirement
    dockerPull: 'soedinglab/mmseqs2:version-11'
  - class: InlineJavascriptRequirement

baseCommand: ['mmseqs', 'createdb']

inputs:
  filtered_reads:
    type: File
    inputBinding:
      position: 1

  reads_db_name:
    type: string
    inputBinding:
      position: 2

outputs:
  filtered_reads_mmseqdb:
    type: File
    outputBinding:
      glob: $(inputs.reads_db_name)
    secondaryFiles: ['.dbtype', '_h', '_h.dbtype', '_h.index', '.source', '.index', '.lookup']


  

