#!/bin/bash
# [original] cluster: <path>/genome2genome.sh
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -q workq

MASTER=<path>/genome
hap1_genome=$MASTER/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap1.p_ctg.fa
hap2_genome=$MASTER/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap2.p_ctg.fa
output=$MASTER/genome_stats/genome2genome

## run with minimap
minimap2 -ax asm5 $hap1_genome $hap1_genome -o $output/hap1_hap1_alignment.sam -t 8
minimap2 -ax asm5 $hap2_genome $hap2_genome -o $output/hap2_hap2_alignment.sam -t 8 

