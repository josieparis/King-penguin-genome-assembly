# 09 — Protein-coding gene annotation

Evidence: pooled five-tissue paired-end mRNA-seq of the king penguin (brain, kidney, liver, muscle, skin;
Paris et al. 2025; Supplementary Table 3) and proteins = OrthoDB v11 Vertebrata + 51 avian proteomes from
Ensembl 113 concatenated into `Vertebrata.fa` (Supplementary Table 4). Genome = soft-masked curated hap1.

| Step | Script | Tag | Notes |
|---|---|---|---|
| 1 | `01_fastp_trim_rnaseq.sh` | original | fastp `-f 13 -t 2 -g -l 71 --detect_adapter_for_pe -5 -3` |
| 2 | `02_hisat2_align_rnaseq.sh` | original | HISAT2 2.2.1 `--dta` (XS tag needed by StringTie2 / GeneMark-ETP), otherwise default → `king_rnaseq_aligned.bam` |
| 3 | `03_run_braker3.sh` | original | BRAKER3 3.0.8 in a Singularity image, ETP mode: `--genome` soft-masked, `--prot_seq Vertebrata.fa`, `--bam`, `--gff3`; GeneMark-ETP + AUGUSTUS trained on the reliable gene subset, TSEBRA merge with `best_by_compleasm.py` (miniprot, compleasm, aves_odb10). Output taken forward: `better.gtf` (compleasm-selected set; 27,305 transcripts) |
| 4 | `04_braker_postprocessing_agat.sh` | from notes / RECONSTRUCTED | UTRs added with BRAKER's `stringtie2utr.py` from the GeneMark-ETP StringTie2 assembly → `better_UTR.gtf`; AGAT statistics (`results/agat_statistics_better_UTR.txt`), longest isoform per gene (18,081 genes), protein extraction and removal of `*` |
| 5 | `05_busco_proteins.sh` | original | BUSCO 5.7.1 `-m proteins -l aves_odb10`: final longest-isoform set **C:98.4 % [S 96.7, D 1.7]** (`results/busco_final_annotation_longest_isoform.txt`); previous NCBI annotation of BGI_Apat.V1 C:78.5 % (`results/busco_previous_annotation_BGI_Apat.V1.txt`) |
| 6 | (OMArk) | — | OMArk 0.3.0 + OMAmer 2.0.3, clade Neognathae (10,994 HOGs): 97.28 % complete [S 93.85, D 3.43], 84.6 % consistent lineage placement, 0 contamination; previous annotation 91.3 % (command in step 4 comments) |
| 7 | `06_interproscan.sh` | original | InterProScan 5.72-103 `-t p -f tsv,gff3 -cpu 16` on the longest-isoform proteins |
| 8 | (eggNOG-mapper) | — | eggNOG-mapper v2 web server, eggNOG v5 → `bAptPat1_functional.eggnog2.annotations.tsv`; gene names and descriptions added to the GFF with `agat_sp_manage_attributes.pl` → `bAptPat1.with.geneIDs.gff` |
| 9 | `format_diagnosis.pl` | original | gFACs helper used to check the GTF/GFF feature content |

Results (Table 2): 18,081 genes / 27,306 transcripts; 17,081 genes with a functional annotation (94.5 %),
15,142 with a description, 14,433 with a gene name, 12,916 with GO terms; mono:multi-exon ratio 0.162.
Gene models were also inspected in IGV 2.16. Released files: [`annotation/`](../annotation/).
