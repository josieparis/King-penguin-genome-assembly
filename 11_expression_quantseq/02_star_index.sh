#!/bin/bash
# [original] cluster: <path>/star_index.sh
#SBATCH --job-name=STAR_index
#SBATCH --error=logs/STAR_index.err.txt  
#SBATCH --output=logs/STAR_index.out.txt  
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=12:00:00



REFOL="<path>/genome"
INDEXFOL="<path>/STAR_indexed"
ANNOTFOL="<path>/annotation_files"

STAR --runMode genomeGenerate --genomeDir $INDEXFOL --genomeFastaFiles $REFOL/KP_hap1.final.primary.curated.fa --runThreadN 8 --sjdbOverhang 99 --sjdbGTFfile $ANNOTFOL/better_UTR.gtf
