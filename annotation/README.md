# Annotation files for bAptPat1 (Pen/Se-guin)

The annotation of the primary haplotype described in the paper (BRAKER3 protein-coding gene set with
species-specific RNA-seq evidence, plus repeat and non-coding RNA annotations). These files were first released
in the repository `josieparis/King-penguin-genome-annotation` and archived on Zenodo
([10.5281/zenodo.15021483](https://doi.org/10.5281/zenodo.15021483)); they are kept here alongside the code
that produced them. Coordinates refer to bAptPat1.pri (NCBI GCA_965638725.1). An independent NCBI RefSeq
annotation (GCF_965638725.1, Annotation Release RS_2025_08) also exists; all statistics in the paper refer to
the files below.

## Protein-coding genes (`09_gene_annotation/`)

| File | Content |
|---|---|
| `bAptPat1.gff3.gz`, `bAptPat1.gtf.gz` | full gene set with UTRs (18,081 genes, 27,306 transcripts) |
| `bAptPat1.codingseq.fasta.gz`, `bAptPat1.proteins.fasta.gz` | CDS and protein sequences of all transcripts |
| `bAptPat1_longest_iso.gff3.gz`, `bAptPat1_longest_iso.gtf.gz` | longest isoform per gene |
| `bAptPat1_longest_iso.codingseq.fasta.gz`, `bAptPat1_longest_iso.proteins.fasta.gz` | CDS and proteins, longest isoform per gene (the set used for BUSCO, OMArk, InterProScan and eggNOG) |
| `bAptPat1.with.geneIDs.gff.gz` | same as `bAptPat1.gff3.gz` with eggNOG gene names and descriptions added as attributes |
| `bAptPat1_functional.eggnog2.annotations.tsv` | eggNOG-mapper v2 annotations (eggNOG v5) of the longest-isoform proteins |

## Non-coding RNAs (`10_ncRNA_annotation/`)

| File | Content |
|---|---|
| `bAptPat1-ncRNA-annotation.tsv.gz` | Infernal/Rfam 15 hits after de-overlapping and E-value filtering (miRNA, snoRNA, snRNA, rRNA, known lncRNA, cis-regulatory elements, ribozymes) |
| `bAptPat1-lncRNA-annotation.bed`, `.gff`, `.fasta` | 164 novel lncRNAs identified from the king penguin transcriptome |

## Repeats and transposable elements (`08_repeat_annotation/`)

| File | Content |
|---|---|
| `bAptPat1.filteredRepeats.bed`, `bAptPat1.filteredRepeats.gff.gz` | Earl Grey repeat annotation (annotations < 100 bp removed) |
| `bAptPat1-families.fa.strained.gz` | curated consensus library (238 sequences) |
| `bAptPat1.familyLevelCount.txt.gz` | coverage per repeat family |
