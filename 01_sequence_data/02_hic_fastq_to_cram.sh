#!/bin/bash
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -q workq
# [original] cleaned Hi-C pairs -> unaligned CRAM with read groups (input format for curationpretext / TreeVal)

hic_data=<path>/cleaned
output=<path>/cram_files
cd $output

## usage: samtools import -@8 -r ID:{prefix} -r CN:{hic-kit} -r PU:{flowcell.lane.index} -r SM:{sample} -1 R1.fq.gz -2 R2.fq.gz -o {prefix}.cram
samtools import -@8 -r ID:HiC -r CN:arima -r PU:HJGHGDSX5.3.CTTGTAAT -r SM:KP -1 $hic_data/HiC.R1.filt.fq.gz   -2 $hic_data/HiC.R2.filt.fq.gz   -o HiC_unaligned.cram
samtools import -@8 -r ID:HiC -r CN:arima -r PU:22HM7CLT3.7.CTTGTAAT -r SM:KP -1 $hic_data/HiC_B.R1.filt.fq.gz -2 $hic_data/HiC_B.R2.filt.fq.gz -o HiC_B_unaligned.cram
samtools index HiC_unaligned.cram
samtools index HiC_B_unaligned.cram

## both sequencing rounds in one CRAM for the contact maps
samtools cat -o HiC_merged.cram HiC_unaligned.cram HiC_B_unaligned.cram
samtools index HiC_merged.cram
