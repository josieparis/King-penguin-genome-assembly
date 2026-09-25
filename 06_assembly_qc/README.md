# 06 — Assembly quality

| Script | Tag | What |
|---|---|---|
| `quast_lg.sh` | original | QUAST 5.2.0 `quast-lg.py` on the YaHS scaffolds → `results/quast_hap*_yahs.report.txt` |
| `meryl_merqury.sh` | original | Merqury 1.3, k = 21: `meryl count` of the HiFi reads, then `merqury.sh reads_k21.meryl hap1.fa hap2.fa KP_genome_2` on the curated haplotypes → `results/merqury_KP_genome_2.qv` (QV 63.56 / 64.15 / both 63.84) and `results/merqury_KP_genome_2.completeness.stats` (95.73 / 87.66 / both 99.68 %) |
| `busco_genome_mode.sh` | original | BUSCO genome mode, `-m genome -l aves_odb10`, on each curated haplotype and on the previous assembly: hap1 C:97.2 % (Table 2), hap2 C:94.9 % (`results/busco_genome_hap2_curated.txt`) |
| `tidk_telomeres.sh` | RECONSTRUCTED | tidk: `explore` (AACCCT/AGGGTT the most frequent unit, `results/tidk_explore_KP.hap1.txt`) and `search --string TTAGGG --window 100000`; `plot_telomeric_repeats.R` (original) makes Figure S3 — telomeric repeat at ≥ 1 end of 16 of the 34 chromosomes |
| `chromosome_lengths.R` | original | chromosome length bar plot from the `.fai` |
| `ncbi_assembly_stats/` | original | download of the released assemblies (pri, alt, BGI_Apat.V1) and scaffold/contig/gap/GC statistics with `asm_stats.py` and `basecount.py` → `results/ncbi_*.txt` (Table 2) |

Table 2 definitions: contig = sequence between runs of N; microchromosome < 35 Mb, dot chromosome < 5 Mb.
