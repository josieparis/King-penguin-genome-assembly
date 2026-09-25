#!/bin/bash
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -q workq
# [original] Merqury 1.3 (k = 21): k-mer database from the HiFi reads, then QV / completeness of both curated haplotypes

source activate merqury

reads=<path>/allpacbio.fastq.gz
hap1=<path>/KP_hap1.final.primary.curated.fa
hap2=<path>/KP_hap2.final.alternate.curated.fa
output=<path>/meryl_db

cd $output
KMER=21

## k-mer counts of the read set
meryl k=$KMER count output reads_k$KMER.meryl $reads

## Usage: merqury.sh <read-db.meryl> <asm1.fasta> [asm2.fasta] <out>
merqury.sh reads_k$KMER.meryl $hap1 $hap2 KP_genome_2
