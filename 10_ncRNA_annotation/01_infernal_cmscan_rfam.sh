#!/bin/bash
# [original] cluster: <path>/run_rfam.sh
#SBATCH --job-name=rfam
#SBATCH --error=logs/rfam.err.txt  
#SBATCH --output=logs/rfam.out.txt  
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=60G
#SBATCH --time=72:00:00


genome=<path>/KP_hap1.final.primary.curated.fa
RFAM_libs=<path>/RFAM_libs
output=<path>/ncrna_annotation

### output of esl-seqstat $genome

# Format:       FASTA
# Alphabet type:    DNA
# Number of sequences: 659
# Total # residues:  1452707732
# Smallest:      1000
# Largest:       227153109
# Average length:   2204412.2

# Z = (Total residues * 2) / 100000 (Because we want millions of nucleotides on both strands)
# Therefore, Z = 29054.15464

### run cmscan
cmscan -Z 29054.15464 --cut_ga --rfam --nohmmonly --cpu 16 --tblout $output/KP-genome-rfam.tblout --fmt 2 \
       --clanin $RFAM_libs/Rfam.clanin $RFAM_libs/Rfam.cm $genome > $output/KP-genome-rfam.cmscan


