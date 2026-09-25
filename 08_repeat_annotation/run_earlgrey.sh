#!/bin/bash
# [original] cluster: <path>/run_earlygrey.sh
#SBATCH -D . 
#SBATCH -p debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=24G
#SBATCH --time=40:00:00
#SBATCH --job-name=earlgrey_repeat
#SBATCH --error=earlgrey_repeat.err.txt  
#SBATCH --output=earlgrey_repeat.out.txt  
#SBATCH --export=All

## Run earlgrey with RepeatMasker (v4.1.6), Dfam 3.8

source activate <path>/earlgrey_josie

genome=<path>/KP_hap1.final.primary.curated.fa
output=<path>/repeat_annotation_mask
vale_repeats=<path>/oenMel_oenPle_combined_library_fix_noProt_noTypo.fasta

earlGrey -g $genome \
	 -s aptenodytespatagonicus_v2 \
	 -l $vale_repeats \
	 -o $output -t 32 -m yes -d yes 


