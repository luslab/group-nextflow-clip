#!/bin/sh

## Script to run luslab/group-nextflow-clip on CAMP
## Copy this script to a working folder

## LOAD REQUIRED MODULES
ml purge
ml Nextflow/20.01.0
ml Singularity/3.4.2
ml Graphviz

## UPDATE PIPLINE
nextflow pull luslab/group-nextflow-clip

## RUN PIPELINE
nextflow run luslab/group-nextflow-clip \
  -r dev \
  -profile crick \
  --input 'metadata-example.csv' \
  --bowtie_index '/camp/lab/luscomben/home/users/capitac/tRNA_rRNA_for_iMaps/Homo_sapiens/small_rna_bowtie' \
  --star_index '/camp/lab/luscomben/home/users/capitac/miCLIP_UN1710_CS2_delta2/summarising_trna_mapping_style/tRNA_paper/results/genome_star_index' \
  --genome_fai '/camp/lab/luscomben/home/users/capitac/spliceosome_iCLIP/permanent_files/GRCh38.primary_assembly.genome.fa.fai'
