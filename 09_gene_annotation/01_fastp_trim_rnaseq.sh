#!/bin/bash
# [original] cluster: <path>/trimPEreads.sh
#PBS -l select=1:ncpus=16:mpiprocs=16
#PBS -q workq

RAW_READS="<path>/rnaseq"
TRIM_READS="<path>/trimmed_PEreads"

source activate <path>/fastp

fastp -i $RAW_READS/emperor_R1.fastq -I $RAW_READS/emperor_R2.fastq -o $TRIM_READS/emperor_R1_fastp.fastq.gz -O $TRIM_READS/emperor_R2_fastp.fastq.gz -V -f 13 -t 2 -g -l 71 --detect_adapter_for_pe -5 -3 -p -h $TRIM_READS/fastp_report_emp.html -R $TRIM_READS/"fastp_report_emp" -w 16

fastp -i $RAW_READS/king_R1.fastq -I $RAW_READS/king_R2.fastq -o $TRIM_READS/king_R1_fastp.fastq.gz -O $TRIM_READS/king_R2_fastp.fastq.gz -V -f 13 -t 2 -g -l 71 --detect_adapter_for_pe -5 -3 -p -h $TRIM_READS/fastp_report_king.html -R $TRIM_READS/"fastp_report_king" -w 16
