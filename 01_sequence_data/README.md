# 01 — Sequence data

**Sample.** One adult female king penguin ('Pen/Se-guin'), Baie du Marin colony, Possession Island, Crozet
(blood, 2022). Tissues for RNA-seq came from predated chicks of the same colony (Paris et al. 2025).

**PacBio HiFi** (BGI, Revio): two SMRT cells, 38.42 Gb + 20.12 Gb, concatenated to `allpacbio.fastq.gz`.
Statistics (`results/allpacbio.seqkit_stats.tsv`): 3,976,812 reads, 58.54 Gb, read N50 15,051 bp, mean
14,720 bp, 95.67 % of bases ≥ Q20.

**Hi-C** (Arima High-coverage kit, library APAT-I12 made at IBE CSIC-UPF; Azenta NovaSeq 6000, 2 × 150 bp):
two sequencing rounds of the same library. Library 1 was used for scaffolding; both rounds (126 Gb after
cleaning) were used for the contact maps of the manual curation.

| Script | Tag | What it does |
|---|---|---|
| `01_fastp_hic.sh` | original | fastp 0.20, `-q 20 -l 75`, per sequencing round; the two rounds are then concatenated for the contact maps |
| `02_hic_fastq_to_cram.sh` | original | `samtools import` of the cleaned pairs to an unaligned CRAM with read-group tags (`ID:HiC CN:arima PU:<flowcell.lane.index> SM:KP`), as required by curationpretext/TreeVal; the two rounds were merged with `samtools cat -o HiC_merged.cram` |
| `03_seqkit_stats_pacbio.sh`, `03_count_reads_pacbio.sh` | original | HiFi read statistics for the paper |
| `04_pacbio_fastq_to_fasta.sh` | original | `seqtk seq -a` — curationpretext takes the long reads as gzipped FASTA |

`ena/` holds the Webin-CLI manifests used to submit the two haplotypes to ENA (study PRJEB86486).
