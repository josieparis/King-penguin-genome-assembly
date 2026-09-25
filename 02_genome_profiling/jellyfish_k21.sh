#!/bin/bash
# [original] cluster: <path>/jellyfish.sh
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -q workq

READS=<path>/WHPBRVwrgd20230913-2080.fastq

ID=Apat.hifi.k21
SD=<path>
WD=<path>/jellyfish/

cd $WD

$SD/jellyfish-linux count -C -m 21 -s 10000000000 -t 8 $READS -o $ID.reads.jf

$SD/jellyfish-linux histo -t 8 $ID.reads.jf > $ID.histo
