# 04 — Hi-C scaffolding and contact maps

Run separately for each hifiasm haplotype.

1. `01_chromap_align.sh` (original) — Chromap 0.2.5. Index: `chromap -i -k 27` (k-mer length 27; minimizer
   window at the default 7). Alignment of the cleaned Hi-C pairs of library 1 with `--preset hic` (which sets
   `-e 4 -q 1 --low-mem --split-alignment --pairs`) plus `--remove-pcr-duplicates --SAM`, then converted to a
   name-sorted BAM for YaHS.
2. `02_yahs_scaffold.sh` (original) — YaHS 1.2 on the BAM: contig error correction on (log: one round, 0 breaks),
   mapping-quality filter at its default (`-q 10`), no enzyme, `-r` given explicitly as the full 15-step list
   (10 kb … 500 Mb; the automatic default for a 1.3 Gb genome would stop at 20 Mb, i.e. 11 rounds)
   → `yahs.out_scaffolds_final.fa` + `.agp`: hap1 685 scaffolds, hap2 733 (`06_assembly_qc/results/quast_*`).
3. `03_juicer_hic_contact_map.sh` (original) — `juicer pre -a` (YaHS binary) then `juicer_tools 1.9.9 pre`
   → `out_JBAT.hic` for inspection in Juicebox.
4. `curationpretext/` — Hi-C contact maps for manual curation with **sanger-tol/curationpretext** (Nextflow,
   Singularity), one run per haplotype: `run_curationpretext.sh` (from log) and the cluster config
   `cluster.config` (original). Inputs: the YaHS scaffolds (hap2 after ASCC removed the mitochondrial
   `scaffold_598`), the HiFi reads as gzipped FASTA and the merged unaligned Hi-C CRAM of both sequencing
   rounds, telomere motif `TTAGGG`. Outputs (`.pretext` maps, coverage, telomere and gap tracks) were loaded in
   PretextView. Sanger also generated TreeVal 1.1.0 maps from the same inputs.

Practical notes: the pipeline was launched from the login node (Singularity was not available on compute
nodes); `--longread` and `--cram` take a *directory* holding only the indexed file; `NXF_SINGULARITY_LIBRARYDIR`
and `NXF_OPTS` were set to keep the cache out of the home quota; `--max_cpus` had to be given on the command
line because the value in the config was ignored.
