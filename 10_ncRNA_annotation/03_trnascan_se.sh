#!/bin/bash
# [original] cluster: <path>/tRNAScan.sh (edited: the king penguin run, executed first with the same command, is restored above the S. humboldti run)
#SBATCH --job-name=tRNAScan
#SBATCH --error=logs/tRNAScan.err.txt  
#SBATCH --output=logs/tRNAScan.out.txt  
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=24G
#SBATCH --time=12:00:00

module load miscellaneous
module load miniconda

conda activate <path>/trnascan-se

genome=<path>/aptenodytespatagonicus.softmasked.fasta
output=<path>/ncrna_annotation

hum_genome=<path>/GCA_027474245.1_bSphHub1.pri_genomic.fna

## run: king penguin (executed first), then Spheniscus humboldti with the same command
tRNAscan-SE -o $output/trnascan_output.txt -m $output/trnascan_stats.txt $genome

tRNAscan-SE -o $output/S.hum.trnascan_output.txt -m $output/S.hum.trnascan_stats.txt $hum_genome


conda deactivate
