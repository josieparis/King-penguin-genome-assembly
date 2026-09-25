# 12 — Figures

| Figure | Made with |
|---|---|
| Figure 1 (Circos: ideograms, GC, methylation, gene density, repeat density in 50 kb windows) | `circos_fig1/make_circos_tracks.sh` (from notes) prepares the tracks; `circos_fig1/KP.circos.conf` + `ticks.conf` + `backgrounds.conf` + `karyotype.txt` (original) render them with Circos 0.69; tracks were rendered one at a time (the conf keeps the others commented) and assembled in Keynote with legends from `generate_circos_legends.R`. Methylation = mean CpG methylation of 64 birds (bsbolt; Cristofari et al. 2026). Chromosome colours `kpgrey` / `kpyellow` are defined in Circos' `etc/colors.conf` |
| Figure 2A–B (PCA, expression bins) | `11_expression_quantseq/06_*.R`, `07_*.R` |
| Figure 2C (tissue-enhanced genes) | `circos_fig2c_expression/gene_exp.circos.conf`: histogram track per tissue of log2FC (−20…20) for the significant genes |
| Figure S1 (GenomeScope2) | `02_genome_profiling/` |
| Figure S2 (Hi-C maps, sex chromosomes) | PretextView screenshots of the curationpretext maps, `04_hic_scaffolding/` |
| Figure S3 (telomeres) | `06_assembly_qc/plot_telomeric_repeats.R` |
| Supplementary mitogenome figure | `07_mitogenome/06_*.sh`, `07_plot_mito_duplication.R` |
