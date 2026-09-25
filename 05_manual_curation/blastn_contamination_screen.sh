#!/bin/bash
# [original] cluster: <path>/blastn_assemblies.sh
#PBS -l select=1:ncpus=16:mpiprocs=16
#PBS -q workq


## run blastn for blobtools contamination check:
MASTER=<path>/genome
db=<path>/nt
output=$MASTER/blobtools
blastn=<path>/blastn
hap1=$MASTER/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap1.p_ctg.fa
hap2=$MASTER/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap2.p_ctg.fa

cd $output 

## run for hap1 
$blastn -db $db/nt -query $hap1 -outfmt "6 qseqid staxids bitscore std" -num_threads 16 -evalue 1e-25 -max_target_seqs 1 -max_hsps 1 -out hap1_blastn_results.txt

## run for hap2
$blastn -db $db/nt -query $hap2 -outfmt "6 qseqid staxids bitscore std" -num_threads 16 -evalue 1e-25 -max_target_seqs 1 -max_hsps 1 -out hap2_blastn_results.txt
