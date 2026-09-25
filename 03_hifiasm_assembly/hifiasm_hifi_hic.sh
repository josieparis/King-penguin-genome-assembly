#!/bin/bash
# [original] cluster: <path>/hifiasm.sh
#PBS -l select=1:ncpus=16:mpiprocs=16
#PBS -q workq

READS1=<path>/WHPBRVwrgd20230913-2080.fastq
READS2=<path>/WHB5EXONPEP00076141.fastq
R1=<path>/HiC.R1.filt.fq.gz
R2=<path>/HiC.R2.filt.fq.gz
ID=AptPat.HiFi
SD=<path>/hifiasm
WD=<path>/output

mkdir -p $WD
cd $WD

$SD/hifiasm -t 16 -f 0 -o $ID.asm --h1 $R1 --h2 $R2 --primary $READS1 $READS2

