# 08 — Transposable element annotation (Earl Grey)

`run_earlgrey.sh` (original) — Earl Grey 4.4.0 (RepeatModeler 2.0.5, RepeatMasker 4.1.6 / RMBLAST 2.10.0,
Dfam 3.8 partitions 0 + 3, Repbase 20181026; search term `aves`), 32 threads:
`earlGrey -g KP_hap1.final.primary.curated.fa -s aptenodytespatagonicus_v2 -l <library> -o … -t 32 -m yes -d yes`.
`-l` is the curated avian starting consensus library kindly provided by Valentina Peona (Repbase avian
sequences + curated sequences from Peona et al. 2021, Supplementary Table 2), used for the initial mask.
Annotations < 100 bp were removed.

Result: 238 consensus sequences; 16.3 % of the genome repetitive, LINEs 5.6 %
(`results/earlgrey_v2.highLevelCount.txt`, `results/earlgrey_v2.summary.txt`; Supplementary Table 7).
Outputs: `filteredRepeats.bed/.gff`, `families.fa.strained`, `familyLevelCount.txt`, landscapes, and the
**soft-masked genome** used for gene annotation (`bAptPat1.softmasked.fasta`); all in [`annotation/`](../annotation/).
