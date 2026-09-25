#!/bin/bash
# [original] cluster: <path>/star_align.sh
#SBATCH -D . 
#SBATCH -p debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=08:00:00
#SBATCH --job-name=STAR_map
#SBATCH --error=logs/STAR_map_%A_%a.err.txt  
#SBATCH --output=logs/STAR_map_%A_%a.out.txt  
#SBATCH --export=All
#SBATCH --array=3-50%12

MASTER=<path>/reAnalysis_Federica
INDEXFOL=<path>/STAR_indexed
metadata=<path>/KP_metadata.tsv 
LISTSAMPLES=$MASTER/list3endReads.txt


## Fill in directories if different from the workspace setup
clean_reads=$MASTER/trimmed3end_bbduk
outputs=<path>/bams

read_array=( `cat $metadata | cut -f 1` )
read=$clean_reads/${read_array[(($SLURM_ARRAY_TASK_ID))]}

out_array=( `cat $metadata | cut -f 2` )
bam_out=${out_array[(($SLURM_ARRAY_TASK_ID))]}

cd $outputs

STAR --runThreadN 4 --genomeDir $INDEXFOL \
--readFilesIn $read \
--outFilterType BySJout \
--outFilterMultimapNmax 20 \
--alignSJoverhangMin 8 \
--alignSJDBoverhangMin 1 \
--outFilterMismatchNmax 999 \
--outFilterMismatchNoverLmax 0.6 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--outSAMattributes NH HI NM MD \
--readFilesCommand zcat \
--outSAMtype BAM SortedByCoordinate \
--outFileNamePrefix $bam_out \
--outReadsUnmapped Fastx 

