# 07 — Mitogenome

Final mitogenome: 20,520 bp, circular, 37 genes plus a tandem duplication (tRNA-Thr, tRNA-Pro, a degenerate
ND6 copy, tRNA-Glu and a second control region) — GenBank **PZ518787.1**. The published mitogenome
NC_045377.1 (17,477 bp, Du et al. 2019) was the reference for every tool. During the contamination screen,
hap2 `scaffold_598` (34.8 kb, about twice the mitogenome) was flagged as mitochondrial, aligned to NC_045377.1
with MAFFT, and removed from the nuclear assembly.

| Step | Script | Tag | Notes |
|---|---|---|---|
| 1 | `01_numt_screen_align_hifi.sh` → `02_numt_screen_extract_reads.sh` | original / from notes | NUMT screen (Sozzoni, Ferrer Obiol et al. 2023): HiFi reads aligned with minimap2 to the primary haplotype, the alternate haplotype and NC_045377.1; reads shared between nuclear assembly and mitogenome (`data/putative_NUMT_read_ids.txt`) re-aligned to each haplotype → putative NUMTs on seven chromosomes, enriched on W and on hap2 `scaffold_598` (`data/pri_numt.bed`, `data/alt_numt.bed`, `*_filtered_numts.bed`; Supplementary Table 6) |
| 2 | `03_mitohifi_reads_mode.sh` | original | MitoHiFi in reads mode (Singularity image) on the HiFi reads after removal of 15 NUMT-derived reads (`data/NUMT_reads_removed_before_mitohifi.txt`): `-r reads -f NC_045377.1.fasta -g NC_045377.1.gb -o 2` (vertebrate mitochondrial code), all other options default. Result: contig `atg000001l`, 20,520 bp, circular, 40 features (`results/mitohifi_NUMTs_v2.contigs_stats.tsv`); annotation by MitoFinder within MitoHiFi, then manual curation |
| 3 | `04_novoplasty.sh` + `novoplasty_config_K04.txt` | original | independent short-read assembly, NOVOPlasty 4.3.5, Illumina WGS of bird K04 (SAMN40942370; 237 M reads ≈ 24× nuclear), seed NC_045377.1, k = 33, genome range 12–22 kb: 4 contigs (17,050 + 2,958 + 1,133 + 184 bp = 21,325 bp) from 5,058 reads, not circularised (`results/novoplasty_K04_log.txt`) |
| 4 | `05_mito_duplication_support.sh` → `06_plot_mito_duplication.R` | original | read support for the duplication: HiFi reads mapped to a *doubled* copy of PZ518787.1 (avoids soft-clipping at the origin), per-base depth, depth per region and reads spanning each junction with ≥ 1 kb on both sides (`results/region_depth_summary.tsv`, `results/junction_spanning_reads.tsv`) → Supplementary figure. Method and legend in `README_mito_duplication.md` |
| 5 | `calculate_percent_identity.py`, `extract_D_loop.py` | original | identity of the duplicated gene copies after MAFFT 7 alignment (tRNAs 100 %; ND6 copy 1 degenerate → annotated as pseudogene); motif search for the control region |
| 6 | `genbank/bAptPat1_feature_table_v2.txt` | original | feature table submitted to GenBank (BankIt): ND5 11836..13653, ND3 with the conserved avian +1 ribosomal frameshift (`join(9532..9704,9706..9883)`), COX3 with a polyA-completed stop (`transl_except`), light-strand genes on the minus strand, ND6 copy 1 as `/pseudogene="unprocessed"`, two control regions. Validated with `table2asn` before submission |
