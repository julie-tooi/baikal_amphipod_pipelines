# Pipelines for metatranscriptome analysis of an endemic Lake Baikal amphipod microbiome

## Project description

Metazoans are the habitat for ecological communities of symbiotic, parasitic and commensal epibiont microorganisms. The composition of these communities can be determined by many factors. 

It was shown that Baikal amphipods form a habitat for a variety of microorganisms, for example, ciliates, that we researched in a [previous spring project](https://github.com/julie-tooi/baikal_amphipod).

Metatranscriptome sequencing of two amphipod species (*Eulimnogammarus verrucosus* and *E. cyaneus*) from different sampling points in Lake Baikal (Port Baikal and Bolshie Koty) was carried out.

We tried to answer the question of what is the most important for microbiome composition: the place or species of the amphipod host?

## Goal and tasks

The main goal of the project is to answer the question below. This is really interesting, is't it? c:

The tasks:

- Make plan and design of the pipeline, choose way of the realization
- Write a pipeline
- Try the pipeline on test data
- Try the pipeline on real data
- Take a first look on the data

I try to make the pipeline sort of flexible to use this instrument for other tasks too in future.

## Methods

Pipeline written on CWL and starts with CWLtool. Every tool used in docker container.

Scheme of steps:

![Repository%20description%20b514820d530f4404ae1b3d3fd78da5ae/Untitled.png](Repository%20description%20b514820d530f4404ae1b3d3fd78da5ae/Untitled.png)

## Requirements

python ≥ 3.6

docker ≥ 19.0

cwltool ≥ 3.0

## Instruction to run pipeline

### Before start

It is needed to build a docker container to BBDuk tool.

For example, after clone this repository and open directory:

```bash
git clone https://github.com/julie-tooi/baikal_amphipod_pipelines.git 
cd baikal_amphipod_pipelines
```

Need to move to `bbduk` directory with tool and initiate container

```bash
cd bbduk
docker build -t bbduk:test . 
```

### Start pipeline

The pipeline starts with a batch of files realize with script, that use python `subprocess`.

To start analysis you need to specify this parameters:

```bash
usage: run_pipelines.py [-h] -i SAMPLES -db DATABASE -c CONTAMINATION -type {1,2} -p PATTERN [-t THREADS]

optional arguments:
  -h, --help            show this help message and exit
  -i SAMPLES, --samples SAMPLES
                        Path to samples batch
  -db DATABASE, --database DATABASE
                        Path to ready-to-work mmseqs2 reference database
  -c CONTAMINATION, --contamination CONTAMINATION
                        Path to file with contamination data in fasta format
  -type {1,2}, --input_type {1,2}
                        Specify input type: 
			1 - give only one file for analysis (assembly) 
			2 - give two files for analysis (forward and reverse reads)
  -p PATTERN, --pattern PATTERN
                        Pattern that used to split sample name
			For example, file name is: 
			"/path/to/file/sample_1_rnasades_assembly.fasta"
			To get file name, we need split it by pattern "_rnaspades_"
  -t THREADS, --threads THREADS
```

The example command, where we use the assemblies for analysis:

```bash
python3 run_pipelines.py -i '/path/to/batch/data/*' -db /path/to/mmseqs_database/exapmle/swisssprot -c /path/to/filtering/file/contaminant.fasta -type 1 -t 6
```

### Processing reports

After the script ends their work, we have a some number of directories with folders, named as samples with three files inside: kraken and krona reports, filtering statistics.

To create a batch of files to analyze in some other tool, run script `collect_stats.py` with specifying path to folders.

```bash
usage: stats_collector.py [-h] -f FOLDERS -o OUTPUT

optional arguments:
  -h, --help            show this help message and exit
  -f FOLDERS, --folders FOLDERS
                        Path to folders with reports
  -o OUTPUT, --output OUTPUT
                        Path to reports output
```

This batch also can analysis with `pavian` R package.

## Results

The first results were obtained on a Swissprot database with sensitivity parameter of `mmseqs2` `taxonomy` equal 7.5 and analysis against the whole database. Results it’s kind of unexpected c:

For further analysis it was created as a part of the database (Swissprot) with marker protein COI. This type of analysis is more specific, next we try to change some parameters in `mmseqs2 taxonomy` analysis to get the best results (sensitivity is 7.5, with exact-kmer-matching is true and min-ungapped-score is 30).

The PCA analysis of pipeline output data showed that the place of amphipod living is more important for amphipod microbiome composition than the species of amphipod.

![Repository%20description%20b514820d530f4404ae1b3d3fd78da5ae/Untitled%201.png](Repository%20description%20b514820d530f4404ae1b3d3fd78da5ae/Untitled%201.png)