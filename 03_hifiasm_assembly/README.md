# 03 — Contig assembly with hifiasm (v0.19.5-r587)

* `hifiasm_hifi_hic.sh` (original) — hifiasm in Hi-C integrated mode on both SMRT cells of HiFi reads with the
  cleaned Hi-C pairs of library 1 (`--h1 R1 --h2 R2`), `--primary` (also writes a primary/alternate pair), 16
  threads. Version and full command line are recorded in the job log.
* Outputs used downstream: the phased contigs `AptPat.HiFi.asm.hic.hap1.p_ctg.fa` (775 contigs, 1.26 Gb,
  N50 12.5 Mb) and `AptPat.HiFi.asm.hic.hap2.p_ctg.fa` (785 contigs, 1.37 Gb, N50 12.9 Mb). The `hic.p_ctg`
  primary contigs were only used for the HiFi read-depth check in `05_manual_curation/`.
* `contig_lengths.R` (original) — histogram and quantiles of contig lengths from the `.fai`.
