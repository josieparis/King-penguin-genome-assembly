#!/bin/bash
# [original] cluster: <path>/run.sh
set -u
cd <path>/ncbi_assemblies
B=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA
H1=$B/965/638/725/GCA_965638725.1_bAptPat1.pri.cur/GCA_965638725.1_bAptPat1.pri.cur_genomic.fna.gz
H2=$B/965/638/715/GCA_965638715.1_bAptPat1.alt.cur/GCA_965638715.1_bAptPat1.alt.cur_genomic.fna.gz
echo "[$(date +%T)] downloading hap1"; wget -q -c -O hap1.fna.gz "$H1" || echo "HAP1 DOWNLOAD FAILED"
echo "[$(date +%T)] downloading hap2"; wget -q -c -O hap2.fna.gz "$H2" || echo "HAP2 DOWNLOAD FAILED"
ls -l *.fna.gz
echo "[$(date +%T)] computing stats"
python3 asm_stats.py hap1.fna.gz "hap1  GCA_965638725.1  bAptPat1.pri.cur" hap2.fna.gz "hap2  GCA_965638715.1  bAptPat1.alt.cur" > stats.txt 2>&1
echo "[$(date +%T)] DONE"
