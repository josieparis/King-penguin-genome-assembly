#!/bin/bash
# [original] cluster: <path>/quast.sh
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -q workq

quast_dir=<path>/quast-5.2.0

MASTER=<path>/genome
hap1_genome=$MASTER/genome_assembly_files/hap1_yahs.final.raw.fasta
hap2_genome=$MASTER/genome_assembly_files/hap2_yahs.final.raw.fasta


$quast_dir/quast-lg.py -o $MASTER/genome_stats/quast/quast_hap1_yahs -t 8 $hap1_genome

$quast_dir/quast-lg.py -o $MASTER/genome_stats/quast/quast_hap2_yahs -t 8 $hap2_genome


