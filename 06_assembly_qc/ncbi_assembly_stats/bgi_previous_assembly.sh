#!/bin/bash
# [original] cluster: <path>/bgi.sh
cd <path>/ncbi_assemblies
U=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/010/087/175/GCA_010087175.1_BGI_Apat.V1/GCA_010087175.1_BGI_Apat.V1_genomic.fna.gz
echo "[$(date +%T)] downloading BGI"; wget -q -c -O bgi.fna.gz "$U" || echo "BGI DOWNLOAD FAILED"
ls -l bgi.fna.gz
echo "[$(date +%T)] stats"; python3 asm_stats.py bgi.fna.gz "BGI_Apat.V1  GCA_010087175.1" > bgi_stats.txt 2>&1
echo "[$(date +%T)] BGIDONE"
