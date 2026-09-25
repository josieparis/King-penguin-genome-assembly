#!/bin/bash
#SBATCH -D .
#SBATCH -p debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12G
#SBATCH --time=12:00:00
#SBATCH --job-name=htseq_count
#SBATCH --error=logs/htseq_count_%A_%a.err.txt
#SBATCH --output=logs/htseq_count_%A_%a.out.txt
#SBATCH --export=All
#SBATCH --array=1-50%10
# [original] HTSeq 2.0.3 gene counts per QuantSeq sample (stranded, intersection-nonempty) on the annotation with UTRs

module load miscellaneous
module load miniconda
source activate <path>/htseq

MASTER=<path>/mapped_quantseq
metadata=$MASTER/KP_metadata.tsv
annotation=<path>/better_UTR.gff3
inputs=$MASTER/bams
outputs=$MASTER/htseqcount

bam_array=( `cat $metadata | cut -f 2` )
bam=$inputs/${bam_array[(($SLURM_ARRAY_TASK_ID))]}
out=$outputs/${bam_array[(($SLURM_ARRAY_TASK_ID))]}

htseq-count -m intersection-nonempty -s yes -f bam -r pos ${bam}.Aligned.sortedByCoord.out.bam ${annotation} > ${out}.htseq.txt
