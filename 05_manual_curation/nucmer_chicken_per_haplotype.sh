#!/bin/bash
# [original] cluster: <path>/hap1_align_chicken.sh
#PBS -l select=1:ncpus=4:mpiprocs=4
#PBS -q workq


MASTER=<path>/genome
hap1_genome=$MASTER/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap1.p_ctg.fa
hap2_genome=$MASTER/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap2.p_ctg.fa
chicken=$MASTER/other_genomes/Gallus_gallus_GGswu1/data/GCA_024206055.2/GCA_024206055.2_GGswu_genomic.fna
output=$MASTER/genome_stats/genome2genome

cd $output

## run with nucmer
## usage: ./nucmer  -p <prefix>  ref.fa  qry.fa
nucmer -p hap1_2_chicken $hap1_genome $chicken

nucmer -p hap2_2_chicken $hap2_genome $chicken

