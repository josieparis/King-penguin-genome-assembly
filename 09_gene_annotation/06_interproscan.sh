#!/bin/bash
# [original] cluster: <path>/run_interpro.sh
#SBATCH --job-name=interpro_scan
#SBATCH --error=logs/interpro_scan.err.txt  
#SBATCH --output=logs/interpro_scan.out.txt  
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=24G
#SBATCH --time=24:00:00


protein=<path>/final_longest.protein.fa
output=<path>/functional_annotation

SD=<path>/interproscan-5.72-103.0

$SD/interproscan.sh -i $protein -t p -b $output/interpro_better_UTR_longest -f tsv,gff3 -cpu 16


