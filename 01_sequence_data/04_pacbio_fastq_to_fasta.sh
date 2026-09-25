#!/bin/bash
# [original] cluster: <path>/convert_fastq2fasta.sh
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -q workq

MASTER=<path>/genome
pacbio_data=$MASTER/rawReads/pacbio

cd $pacbio_data

seqtk seq -a allpacbio.fastq.gz | gzip - > allpacbio.fasta.gz

echo "complete"
