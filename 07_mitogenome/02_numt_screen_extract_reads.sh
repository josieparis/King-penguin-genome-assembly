#!/bin/bash
# [from notes] commands run interactively after 03_numt_screen_align_hifi.sh, copied from the lab notebook.
# Approach of Sozzoni, Ferrer Obiol et al. 2023 (kittiwake genome): HiFi reads that align both to the
# nuclear assembly and to the published mitogenome (NC_045377.1) are putative NUMT-derived reads.
# Working directory: cluster: <path>/alignments/

## 1. read names aligned to each reference
samtools view -@ 8 assembly_pri_hifi.mapped.sorted.bam | cut -f 1 | sort -u | bgzip -@ 8 > assembly_pri_reads.tsv.gz
samtools view -@ 8 assembly_alt_hifi.mapped.sorted.bam | cut -f 1 | sort -u | bgzip -@ 8 > assembly_alt_reads.tsv.gz
samtools view -@ 8 mitogenome_hifi.mapped.sorted.bam   | cut -f 1 | sort -u | bgzip -@ 8 > mitogenome_reads.tsv.gz

## 2. reads shared between the nuclear assembly and the mitogenome = putative NUMTs
zgrep -F -x -f <(zcat assembly_pri_reads.tsv.gz) <(zcat mitogenome_reads.tsv.gz) | bgzip -@ 8 > pri_mito_common_reads.tsv.gz
zgrep -F -x -f <(zcat assembly_alt_reads.tsv.gz) <(zcat mitogenome_reads.tsv.gz) | bgzip -@ 8 > alt_mito_common_reads.tsv.gz
zcat pri_mito_common_reads.tsv.gz > pri_mito_common_reads.txt
zcat alt_mito_common_reads.tsv.gz > alt_mito_common_reads.txt

## 3. pull those reads out of the HiFi fastq
seqtk subseq allpacbio.fastq.gz pri_mito_common_reads.txt > pri_mito_common_reads.fq
seqtk subseq allpacbio.fastq.gz alt_mito_common_reads.txt > alt_mito_common_reads.fq

## 4. re-align the shared reads to each haplotype to locate the NUMTs (-> pri_numt.bed / alt_numt.bed, data/)
minimap2 --secondary=no -ax map-hifi KP_hap1.final.primary.curated.fa   pri_mito_common_reads.fq > pri_numt_reads.sam
minimap2 --secondary=no -ax map-hifi KP_hap2.final.alternate.curated.fa alt_mito_common_reads.fq > alt_numt_reads.sam
samtools sort -o pri_numt.sorted.bam pri_numt_reads.sam && samtools index pri_numt.sorted.bam
samtools sort -o alt_numt.sorted.bam alt_numt_reads.sam && samtools index alt_numt.sorted.bam
bedtools bamtobed -i pri_numt.sorted.bam > pri_numt.bed
bedtools bamtobed -i alt_numt.sorted.bam > alt_numt.bed

## 5. reads judged to be NUMT-derived (data/NUMT_reads_removed_before_mitohifi.txt, n = 15) were removed
##    from the HiFi read set before the final MitoHiFi run:
##    seqkit grep -v -f NUMTs_to_remove.txt allpacbio.fastq.gz -o no_NUMTs.fastq.gz     # (exact tool not recorded)
