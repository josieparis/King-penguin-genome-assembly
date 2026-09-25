#!/bin/bash
#PBS -l select=1:ncpus=16:mpiprocs=16
#PBS -q workq
# [original] Chromap 0.2.5: index each hifiasm haplotype, align the cleaned Hi-C pairs (library 1), name-sorted BAM for YaHS

source activate <path>/chromap

hap1=<path>/AptPat.HiFi.asm.hic.hap1.p_ctg.fa
hap2=<path>/AptPat.HiFi.asm.hic.hap2.p_ctg.fa
read1=<path>/HiC.R1.filt.fq.gz
read2=<path>/HiC.R2.filt.fq.gz
ID_hap1=AptPat.HiFi.run3.hap1
ID_hap2=AptPat.HiFi.run3.hap2
output=<path>/chromap

## index (-k 27; window size default 7)
chromap -i -k 27 -r $hap1 -o $output/$ID_hap1
chromap -i -k 27 -r $hap2 -o $output/$ID_hap2

cd $output

## align (--preset hic = -e 4 -q 1 --low-mem --split-alignment --pairs; SAM output requested instead of pairs)
chromap --preset hic -x $ID_hap1 -r $hap1 -1 $read1 -2 $read2 --remove-pcr-duplicates --SAM -o $ID_hap1.sam -t 16
chromap --preset hic -x $ID_hap2 -r $hap2 -1 $read1 -2 $read2 --remove-pcr-duplicates --SAM -o $ID_hap2.sam -t 16

## name-sorted BAM (YaHS applies its mapping-quality filter only on name-sorted input)
samtools view -@8 -hb $ID_hap1.sam | samtools sort -@8 -n > $ID_hap1.bam
samtools view -@8 -hb $ID_hap2.sam | samtools sort -@8 -n > $ID_hap2.bam
