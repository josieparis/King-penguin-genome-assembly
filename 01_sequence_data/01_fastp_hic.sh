#!/bin/bash
#PBS -l select=1:ncpus=10:mpiprocs=10
#PBS -q workq
# [original] Hi-C read cleaning, fastp 0.20 (quality >= 20, reads < 75 bp discarded); one call per library

source activate <path>/fastp

WD=<path>/cleaned
cd $WD

## library 1 (used for scaffolding and for the contact maps)
fastp -q 20 -l 75 -i <path>/APAT-I12_R1_001.fastq.gz -I <path>/APAT-I12_R2_001.fastq.gz -o HiC.R1.filt.fq.gz -O HiC.R2.filt.fq.gz

## library 2 (sequenced later; added to the contact maps used for manual curation)
fastp -q 20 -l 75 -i <path>/APAT-I12_B_R1_001.fastq.gz -I <path>/APAT-I12_B_R2_001.fastq.gz -o HiC_B.R1.filt.fq.gz -O HiC_B.R2.filt.fq.gz

## both libraries together, for the contact maps
cat HiC.R1.filt.fq.gz HiC_B.R1.filt.fq.gz > HiC_concat.R1.filt.fq.gz
cat HiC.R2.filt.fq.gz HiC_B.R2.filt.fq.gz > HiC_concat.R2.filt.fq.gz
