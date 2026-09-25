#!/bin/bash
# [original] cluster: <path>/hic-map.sh
#PBS -l select=1:ncpus=16:mpiprocs=16
#PBS -q workq

MASTER=<path>/genome
hap1_genome=$MASTER/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap1.p_ctg.fa
hap2_genome=$MASTER/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap2.p_ctg.fa
output=$MASTER/genome_stats/hic_map
hic_reads=$MASTER/rawReads/hic/cleaned

SD1=<path>/bwa-mem2-2.2.1
SD2=<path>/samtools-1.12

cd $output

## index
# $SD1/bwa-mem2 index $hap1_genome
# $SD1/bwa-mem2 index $hap2_genome

## map
$SD1/bwa-mem2 mem -t 16 $hap1_genome $hic_reads/HiC.R1.filt.fq.gz $hic_reads/HiC.R2.filt.fq.gz | $SD2/samtools view -bS | $SD2/samtools sort --threads 16 > hic_mapped_hap1.sorted.bam

$SD1/bwa-mem2 mem -t 16 $hap2_genome $hic_reads/HiC.R1.filt.fq.gz $hic_reads/HiC.R2.filt.fq.gz | $SD2/samtools view -bS | $SD2/samtools sort --threads 16 > hic_mapped_hap2.sorted.bam

$SD2/samtools index hic_mapped_hap1.sorted.bam

$SD2/samtools index hic_mapped_hap2.sorted.bam

