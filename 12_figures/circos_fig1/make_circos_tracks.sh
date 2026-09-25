#!/bin/bash
# [from notes] Track preparation for Figure 1 (Circos 0.69). The GC / repeat / gene-density recipe is copied
# from the lab notebook (written for another genome first, file names adapted here); the methylation track
# follows the same window scheme. Inputs and outputs live in local: <path>/.
# Windows: 50 kb (GC, methylation, repeats, genes); a 200 kb gene track was also made and is the one used in KP.circos.conf.

genome=bAptPat1.pri.cur.softmasked.fasta        # curated primary haplotype
fai=$genome.fai
w=50000

## karyotype: one line per chromosome, "chr - ID LABEL START END COLOUR" (colours kpgrey/kpyellow defined in circos etc/colors.conf)
awk '$1 ~ /^SUPER_/ {print "chr - "$1" "$1" 0 "$2" kpgrey"}' $fai > karyotype.txt      # then alternate colours by hand

## windows
bedtools makewindows -g $fai -w $w > genome_50kb_windows.bed

## GC content per window
bedtools nuc -fi $genome -bed genome_50kb_windows.bed | awk 'OFS="\t" {print $1,$2,$3,$5}' | tail -n +2 \
  | LC_COLLATE=C sort -k1,1 -k2,2n > gc_content_50kb.sorted.bed

## repeat density (fraction of window covered by Earl Grey repeats)
sort -k1,1 -k2,2n bAptPat1.filteredRepeats.bed > sorted_repeats.bed
sort -k1,1 -k2,2n genome_50kb_windows.bed > sorted_50kb_windows.bed
bedtools coverage -sorted -a sorted_50kb_windows.bed -b sorted_repeats.bed | awk 'OFS="\t"{print $1,$2,$3,$NF}' > repeat_content_50kb.sorted.bed

## protein-coding gene density
awk '$3=="gene"' bAptPat1.gff3 | gff2bed > gene_annotation.bed
sort -k1,1 -k2,2n gene_annotation.bed > genes_only_annotation.bed
bedtools coverage -sorted -a sorted_50kb_windows.bed -b genes_only_annotation.bed | awk 'OFS="\t"{print $1,$2,$3,$NF}' > gene_content_50kb.sorted.bed

## mean CpG methylation per window (bsbolt calls averaged over 64 birds, Cristofari et al. 2026: methylation_averaged.bedGraph)
bedtools map -a sorted_50kb_windows.bed -b methylation_averaged.bedGraph -c 4 -o mean > methylation_50kb.sorted.bed

## circos input = chr start end value ; then
# circos -conf KP.circos.conf        (one track at a time was rendered and the panels assembled in Keynote)
