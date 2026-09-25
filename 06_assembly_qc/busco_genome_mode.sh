#!/bin/bash
#SBATCH --job-name=genome_busco
#SBATCH --error=logs/genome_busco.err.txt
#SBATCH --output=logs/genome_busco.out.txt
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=124G
#SBATCH --time=08:00:00
# [original] BUSCO genome mode, aves_odb10 (n = 8,338), on each curated haplotype and on the previous assembly

module load miscellaneous
module load miniconda
conda activate <path>/busco

busco -i <path>/KP_hap1.final.primary.curated.fa   -m genome -l aves_odb10 -c 2 -o genome_hap1_curated
busco -i <path>/KP_hap2.final.alternate.curated.fa -m genome -l aves_odb10 -c 2 -o genome_hap2_curated
busco -i <path>/Apat.V1_genomic.fna                -m genome -l aves_odb10 -c 2 -o genome_previous_BGI_Apat.V1

conda deactivate
