#!/bin/bash
# [original] cluster: <path>/hisat2_alignment.sh
#PBS -l select=1:ncpus=1:mpiprocs=1
#PBS -q workq

source activate hisat2

MASTER=<path>/annotation

softmask=<path>/KP_hap1.final.primary.curated.softmasked.fa
rnaseq_data=<path>/rnaseq
read1=$rnaseq_data/king_R1.fastq
read2=$rnaseq_data/king_R2.fastq
index_genome=<path>/indexed_genome
output=<path>/alignments

# cd $index_genome

## build index
#hisat2-build $softmask AtaPata_hap1

## align to genome

# Usage: 
# hisat2 [options]* -x <ht2-idx> {-1 <m1> -2 <m2> | -U <r>} [-S <sam>]
# --dta option must be included to ensure that the aligned reads (BAM files) contain the XS (strand) tag for spliced reads

cd $output

hisat2 -p 16 --dta -x $index_genome/AtaPata_hap1 -1 $read1 -2 $read2 -S king_rnaseq_aligned.sam

samtools view -@ 16 -bS king_rnaseq_aligned.sam | samtools sort -o king_rnaseq_aligned.bam

samtools index king_rnaseq_aligned.bam
