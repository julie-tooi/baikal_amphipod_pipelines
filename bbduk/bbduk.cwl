cwlVersion: v1.1
class: CommandLineTool
label: BBduk wrapper, generate one file

requirements:
  - class: DockerRequirement
    dockerPull: 'bbduk:test'

baseCommand: ['bbduk.sh']

inputs:
  memory_usage:
    type: string
    inputBinding:
      prefix: '-Xmx'
      separate: false

  forward_reads:
    type: File
    inputBinding:
      prefix: 'in1='
      separate: false

  reverse_reads:
    type: File
    inputBinding:
      prefix: 'in2='
      separate: false

  output_file_name:
    type: string
    inputBinding:
      prefix: 'out='
      separate: false

  contaminant_file:
    type: File
    inputBinding:
      prefix: 'ref='
      separate: false

  kmer_length:
    type: int
    inputBinding:
      prefix: 'k='
      separate: false

  humming_distance:
    type: int
    inputBinding:
      prefix: 'hdist='
      separate: false

  threads:
    type: int
    inputBinding:
      prefix: 'threads='
      separate: false

  stats_log_file_name:
    type: string
    inputBinding:
      prefix: 'stats='
      separate: false

outputs:
  filtered_reads:
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)

  stats_log_file:
    type: File
    outputBinding:
      glob: $(inputs.stats_log_file_name)
