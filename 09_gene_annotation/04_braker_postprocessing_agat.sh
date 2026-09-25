#!/bin/bash
# [from notes / RECONSTRUCTED] Post-processing of the BRAKER3 gene set. The stringtie2utr, sed and AGAT
# statistics commands are copied from the lab notebook; the remaining AGAT calls are reconstructed from the
# file names in cluster: <path>/annotation_files/ and
# annotation/functional_annotation/ (exact options not recorded). AGAT 0.7.0 / 1.4.1.

BRAKER=<path>/braker3_penguins        # BRAKER3 working directory
genome=<path>/KP_hap1.final.primary.curated.softmasked.fa

## 0. BRAKER3 produces braker.gtf (TSEBRA) and, via best_by_compleasm.py, bbc/better.gtf when the
##    compleasm-guided selection is more complete. better.gtf was taken forward (27,305 transcripts).

## 1. add UTRs from the StringTie2 assembly made inside GeneMark-ETP (BRAKER3's stringtie2utr.py)
python3 $BRAKER/scripts/stringtie2utr.py -g $BRAKER/better.gtf \
   -s $BRAKER/GeneMark-ETP/rnaseq/stringtie/transcripts_merged.gff -o better_UTR.gtf

## 2. gtf -> gff3, statistics
agat_convert_sp_gxf2gxf.pl -g better_UTR.gtf -o better_UTR.gff3
agat_sp_statistics.pl --gff better_UTR.gff3 -o better_UTR_statistics.txt
agat_sp_manage_UTRs.pl --gff better_UTR.gff3 -p 3,5 -o better_UTR_3_5          # UTR reports
agat_sp_manage_UTRs.pl --gff better_UTR.gff3 -p both -o better_UTR_both

## 3. longest isoform per gene (18,081 genes) and sequences
agat_sp_keep_longest_isoform.pl -gff better_UTR.gff3 -o better_UTR_longest.gff3
agat_convert_sp_gff2gtf.pl --gff better_UTR_longest.gff3 -o better_UTR_longest.gtf
agat_sp_extract_sequences.pl -g better_UTR_longest.gff3 -f $genome -p -o better_UTR_longest.cds.fa   # proteins (kept this name)
agat_sp_extract_sequences.pl -g better_UTR_longest.gff3 -f $genome -t cds -o agat_longest_better.cds

## 4. remove the terminal '*' before InterProScan (github.com/Gaius-Augustus/BRAKER/issues/56)
cat better_UTR_longest.cds.fa | sed "s/\*//g" > final_longest.protein.fa

## 5. functional annotation: 06_interproscan.sh; eggNOG-mapper v2 run on the web server
##    (http://eggnog-mapper.embl.de, job MM_kjt76b5d, eggNOG v5) on final_longest.protein.fa
##    -> eggnogg.emapper.annotations.tsv, eggnogg.emapper.decorated.gff

## 6. add eggNOG gene names / descriptions to the GFF (agat_sp_manage_attributes.pl; table: gene, name, description)
##    -> gene_names_UTR.gff -> KP_final_annotation_gene_names.gff.gz = bAptPat1.with.geneIDs.gff.gz
agat_sp_manage_attributes.pl --gff better_UTR.gff3 --att Name,description -o gene_names_UTR.gff
agat_sp_functional_statistics.pl --gff gene_names_UTR.gff -o gene_names_stats

## 7. quality: 05_busco_proteins.sh; OMArk 0.3.0 with OMAmer 2.0.3 (LUCA database, Neognathae clade)
##    omamer search --db LUCA.h5 --query final_longest.protein.fa --out KP.omamer
##    omark -f KP.omamer -d LUCA.h5 -o omark_output
