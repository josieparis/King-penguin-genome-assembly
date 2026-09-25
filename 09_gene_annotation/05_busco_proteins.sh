#!/bin/bash
#SBATCH --job-name=braker_busco
#SBATCH --error=logs/braker_busco.err.txt
#SBATCH --output=logs/braker_busco.out.txt
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12G
#SBATCH --time=04:00:00
# [original] BUSCO 5.7.1 in protein mode (aves_odb10) on the final longest-isoform protein set and on the previous annotation

module load miscellaneous
module load miniconda
conda activate <path>/busco

## final annotation, longest isoform per gene (file name kept from the run: it holds the proteins)
busco -i <path>/better_UTR_longest.cds.fa -m proteins -l aves_odb10 -c 8 -o KP_better_UTR_longest_busco

## previous NCBI annotation of BGI_Apat.V1
busco -i <path>/protein.faa -m proteins -l aves_odb10 -c 8 -o prev_genome_busco

conda deactivate
