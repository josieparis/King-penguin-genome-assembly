#!/bin/bash
# [original] cluster: <path>/run_rnammer.sh
#SBATCH --job-name=rnammer
#SBATCH --error=logs/rnammer.err.txt  
#SBATCH --output=logs/rnammer.out.txt  
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=24G
#SBATCH --time=24:00:00


genome=<path>/KP_hap1.final.primary.curated.fa
output=<path>/ncrna_annotation

SD=<path>/rnammer-v1.2

module load miscellaneous
module load miniconda

source activate <path>/mutation_rate

$SD/rnammer -S euk -m lsu,ssu,tsu -multi -gff rnammer.gff -xml rnammer.xml -h rnammer.hmm -f rnammer.fasta -g $genome


