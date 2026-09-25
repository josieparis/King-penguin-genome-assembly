#!/bin/bash
# [original] cluster: <path>/seqkit_stats_pacbio.sh
#SBATCH --job-name=seqkit_stats_pacbio
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

set -euo pipefail

source /etc/profile.d/lmod.sh
module load miscellaneous
module load miniconda
eval "$(conda shell.bash hook)"
conda activate <path>/seqkit

DIR=<path>/pacbio
cd "$DIR"

echo "Host: $(hostname)"
echo "Start: $(date)"
seqkit version

seqkit stats -a -T -j 8 allpacbio.fastq.gz > allpacbio.seqkit_stats.tsv

echo "End: $(date)"
cat allpacbio.seqkit_stats.tsv
