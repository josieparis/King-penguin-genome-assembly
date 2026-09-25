# 11 — Transcript-level support: QuantSeq across five tissues

3′ QuantSeq FWD libraries of 50 king penguin samples (10 replicates × brain KB, kidney KK, liver KL,
muscle KM, skin KS; Paris et al. 2025; `data/KP_metadata.tsv`, `data/king_all_tissues.txt`).

| Step | Script | Tag | Notes |
|---|---|---|---|
| 1 | `01_trim_3end_bbduk.sh` | original | bbduk (polyA + TruSeq adapters, `ftl=13 ftr=75 k=13 ktrim=r qtrim=r trimq=10 minlength=20`), array over samples |
| 2 | `02_star_index.sh` | original | STAR 2.7.11b index of the curated hap1 with `better_UTR.gtf` (`--sjdbOverhang 99`) |
| 3 | `03_star_align_quantseq.sh` | original | STAR alignment, SLURM array over the 50 samples (ENCODE-style options, `--outFilterMultimapNmax 20`, sorted BAM) |
| 4 | `04_htseq_count.sh` | original | HTSeq 2.0.3 `htseq-count -m intersection-nonempty -s yes -f bam -r pos` on `better_UTR.gff3` |
| 5 | `05_merge_htseq_counts.sh` | from notes | joins the 50 count files → `final_counts.txt` |
| 6 | `06_deseq2_pca_tissue_enhanced.R` | original | DESeq2 1.40: `~ 0 + Tissue`, VST (blind) → PCA (Figure 2A); tissue-enhanced / inhibited genes = each tissue vs the mean of the other four (`listValues = c(1, -1/4)`), FDR < 0.01 and log2FC ≥ 5 or ≤ −5 → `*_sig_enhanced.tsv`, joined to gene coordinates for the Circos tracks (Figure 2C) |
| 7 | `07_expression_bins.R` | original | per tissue, a gene is assigned an expression bin (0, 0–50, 50–100, 100–200, 200–500, > 500 VST counts) when ≥ 5 of 10 replicates fall in it → `results/gene_expression_bins.tsv`, Figure 2B. 83 % of genes have ≥ 1 read; 67–77 % expressed in ≥ half the replicates |
| 8 | `08_regioneR_gene_clustering.R` | original | regioneR permutation test of the clustering of tissue-enhanced genes (exploratory) |
