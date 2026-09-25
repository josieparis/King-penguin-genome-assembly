#!/bin/bash
# [original] cluster: <path>/count_reads_pacbio.sh
#SBATCH --job-name=count_reads_pacbio
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=12:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

set -euo pipefail

source /etc/profile.d/lmod.sh
module load miscellaneous
module load miniconda

export PATH=<path>/pigz-2.4:$PATH

DIR=<path>/pacbio
cd "$DIR"

echo "Host: $(hostname)"
echo "Start: $(date)"

LINES=$(unpigz -p 8 -c allpacbio.fastq.gz | wc -l)
READS=$((LINES / 4))

echo "lines: $LINES"
echo "reads: $READS"
printf "file\tlines\treads\n" > allpacbio.readcount.tsv
printf "allpacbio.fastq.gz\t%s\t%s\n" "$LINES" "$READS" >> allpacbio.readcount.tsv

if [ $((LINES % 4)) -ne 0 ]; then
  echo "WARNING: line count is not a multiple of 4 -- file may be truncated or not 4-line FASTQ"
fi

echo "End: $(date)"
