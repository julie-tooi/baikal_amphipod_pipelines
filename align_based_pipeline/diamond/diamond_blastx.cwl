cwlVersion: v1.1
class: CommandLineTool
label: DIAMOND wrapper

requirements:
  - class: DockerRequirement
    dockerPull: 'buchfink/diamond:version2.0.9'
  - class: ShellCommandRequirement

baseCommand: ['diamond', 'blastx']

inputs:
  assembly:
    type: File
    inputBinding:
      prefix: '-q'

  ref_database:
    type: File
    inputBinding:
      prefix: '-d'

  annotated_assembly_file_name:
    type: string
    inputBinding:
      prefix: '-o'

  sensitive_analysis_mode:
    type: boolean
    inputBinding:
      prefix: '--sensitive'

  threads:
    type: int
    inputBinding:
      prefix: '--threads'

  output_format:
    type: string
    inputBinding:
      prefix: '-f'
      shellQuote: false

  max_target_seqs:
    type: int
    inputBinding:
      prefix: '--max-target-seqs'

outputs:
  annotated_assembly:
    type: File
    outputBinding:
      glob: $(inputs.annotated_assembly_file_name)


