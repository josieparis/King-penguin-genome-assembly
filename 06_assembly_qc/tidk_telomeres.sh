#!/bin/bash
# [RECONSTRUCTED] no script survives for the tidk run; commands rewritten from the paper's Methods
# (tidk 0.2.63: "tidk explore" to find candidate telomeric repeats, "tidk search" in 100 kb windows)
# and from the output files that do survive in cluster: <path>/KP_haplotype/
#   KP.hap1.txt                                   (tidk explore table: AACCCT/AGGGTT most frequent)
#   KP.hap1_telomeric_locations.tsv               (tidk explore --log style locations)
#   KP_search_telomeric_repeat_windows.csv        (tidk search, default 10 kb window)
#   KP_search_100kb_telomeric_repeat_windows.csv  (tidk search, --window 100000; used for Figure S3)
# Exact flags may differ from the original invocation.

source activate <path>/tidk

genome=KP_hap1.final.primary.curated.fa      # curated primary haplotype

## 1. find the telomeric repeat unit (vertebrate TTAGGG is expected; AACCCT is its reverse complement)
tidk explore --minimum 5 --maximum 12 --log $genome > KP.hap1.txt

## 2. count the repeat along the chromosomes in 100 kb windows
tidk search --string TTAGGG --window 100000 --output KP_search_100kb --dir . $genome
tidk search --string TTAGGG --output KP_search --dir . $genome        # default 10 kb window

## 3. plot: plot_telomeric_repeats.R (Figure S3)
