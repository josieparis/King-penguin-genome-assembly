#!/bin/bash
#PBS -l select=1:ncpus=1:mpiprocs=1
#PBS -q workq
#PBS -J 0-49
# [original] QuantSeq 3' read trimming with bbduk (polyA + TruSeq adapters), one array task per sample

metadata=<path>/3end_metadata.tsv        # column 1: input fastq, column 2: output fastq
input_reads=<path>/3end_rawReads
output_reads=<path>/trimmed3end_bbduk

in=( `cat $metadata | cut -f 1` )
in_array=$input_reads/${in[(($PBS_ARRAY_INDEX))]}
out=( `cat $metadata | cut -f 2` )
out_array=$output_reads/${out[(($PBS_ARRAY_INDEX))]}

RESOURCE_DIR=<path>/rnaseq                # polyA.fa, truseq-rna.fa
source activate <path>/bbmap

bbduk.sh in=$in_array out=$out_array ref=$RESOURCE_DIR/polyA.fa,$RESOURCE_DIR/truseq-rna.fa \
  threads=1 ftl=13 ftr=75 k=13 ktrim=r useshortkmers=t mink=5 qtrim=r trimq=10 minlength=20
