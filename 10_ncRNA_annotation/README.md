# 10 — Non-coding RNA annotation

## Scripts

| Script | Tag | What |
|---|---|---|
| `01_infernal_cmscan_rfam.sh` | original | Infernal 1.1.2 `cmscan --cut_ga --rfam --nohmmonly --clanin` against **Rfam 15** on the curated hap1; `-Z` = 2 × genome length / 10⁶ (29054.15 from `esl-seqstat`); `--fmt 2` table |
| `04_rfam_filter_and_categorise.py` | added | de-overlaps the cmscan table with Infernal's own overlap annotation (keeps `olp` `*` and `^`, drops `=`: 1,904 → 1,470 hits), applies the E ≤ 1e-5 threshold (→ 1,358), and assigns every hit to an ncRNA category from the Rfam family type (`data/rfam15_family_types.tsv`, extracted from Rfam 15.0 `family.txt`); also categorises the published table and writes the count comparison |
| `02_rnammer.sh` | original | RNAmmer 1.2 `-S euk -m lsu,ssu,tsu` to confirm the rRNA subunits |
| `03_trnascan_se.sh` | original | tRNAscan-SE 2.0.9 (eukaryotic models, Infernal first pass) on the soft-masked genome and, with the same command, on *S. humboldti* GCA_027474245.1 |
| `05_trnascan_filter.py` | added | keeps tRNAs with score > 50 (the threshold of Ottenburghs et al. 2021) and writes isotype counts for both species |
| `lncRNA/04_lncrna_pipeline.sh` | RECONSTRUCTED (minimap2 and StringTie lines exact) | novel lncRNAs: king penguin de novo transcriptome (Paris et al. 2025) aligned with `minimap2 -ax splice`; StringTie 2.2.1 guided by the annotation (`-G better_UTR.gtf -A -C`); transcripts without a reference gene kept (`extract_novel.py`, `clean_headers.py`); DIAMOND blastx against the annotated proteins and UniProtKB 2025_01 removes transcripts with protein homology; CPC2, CPAT 3.0.5 (species-specific hexamer table and logit model: `CPAT_make_logitModel.R`, `CPAT_output.R`, `CPAT_10fold_crossvalidation.R`) and PLEK |
| `lncRNA/scoring_CPAT.py` | original | CPAT call per transcript: an ORF with coding probability < 0.4 is non-coding; a transcript is non-coding when the majority of its ORFs are |
| `06_lncrna_classify.py` | added | reproduces the final lncRNA set from the CPC2, PLEK and CPAT tables (> 200 nt and non-coding by all three) and writes a per-transcript classification table |
| `lncRNA/rename_lncRNA_headers.py` | original | names the released FASTA (`annotation/bAptPat1-lncRNA-annotation.*`) |

## Results (`results/`) and how they compare with the paper

| Result | File(s) | Count from the files | Reported in the paper |
|---|---|---|---|
| Rfam hits, raw cmscan table | `rfam/KP-genome-rfam.tblout.gz` | 1,904 | — |
| de-overlapped (`04_…py`) | `rfam/KP-genome-rfam.deoverlapped.categorised.tsv` | 1,470 | — |
| de-overlapped, E ≤ 1e-5 (`04_…py`) | `rfam/KP-genome-rfam.deoverlapped.evalue1e-5.categorised.tsv` | 1,358 | — |
| **published table = Supplementary Table 8** | `annotation/bAptPat1-ncRNA-annotation.tsv.gz`; categorised copy `rfam/SuppTable8_published.categorised.tsv` | 1,434 | — |
| category counts of the published table | `rfam/rfam_category_counts.tsv` | miRNA 269 · snoRNA 256 · snRNA 60 · rRNA 341 eukaryotic (+3 bacterial/archaeal cross-hits) · lncRNA 16 · cis-regulatory 72 · ribozyme 6 · tRNA 397 (tRNAs are reported from tRNAscan-SE instead) · other genes 14 (7SK, SRP, Y RNA, telomerase RNA, bZIP) | miRNA 281 · snoRNA 253 · snRNA 60 · rRNA 341 · lncRNA 16 · CREs 81 · ribozymes 6 |
| rRNA subunits, RNAmmer = Supplementary Table 9 | `rnammer/KP.genome.rnammer.gff`, `rnammer_counts.tsv` | 240 features: 80 18S, 81 28S, 79 5.8S | 341 rRNAs (Rfam count) with subunits confirmed by RNAmmer |
| tRNAs, king penguin = Supplementary Table 10 | `trnascan/KP.trnascan_output.txt`, `KP.trnascan_stats.txt`, `KP.tRNAs_score_gt50.tsv` | 393 predicted, **358** with score > 50 | 358 |
| tRNAs, *S. humboldti* | `trnascan/S_humboldti.*`, `S_humboldti.tRNAs_score_gt50.tsv`; `trna_isotype_counts_score_gt50.tsv` | 460 predicted, **389** with score > 50 | 389 |
| novel transcripts | `lncRNA/novel_transcript_gene_ids.txt`, `stringtie_transcript_abundance.tsv.gz` | 9,363 StringTie genes without a reference gene (10,048 transcripts) | — |
| protein-homology filter | `lncRNA/diamond/` (DIAMOND tables, ids with hits) | 2,213 transcripts after the annotated-protein screen, 1,452 after UniProtKB | — |
| coding potential | `lncRNA/CPC2_results.tsv`, `PLEK_Results.tsv`, `CPAT_output.ORF_prob*.tsv`, `cpat_model/` | CPC2 non-coding 1,326 · PLEK non-coding 1,195 · CPAT (majority rule) → `lncRNA_classification.tsv` | — |
| **final lncRNAs** | `lncRNA/final_lncRNA_gene_list.tsv` (= `final_lncRNA_gene_list.reproduced.tsv`), `final_lncRNA_transcript_lengths.tsv`; sequences in `annotation/` | **164 genes** (169 transcripts, 5 genes with two isoforms), mean length 672.6 bp | 164, mean 673 bp |

Notes on the Rfam table. Supplementary Table 8 is the de-overlapped set minus 36 hits that were removed during manual
curation (scaRNAs, GABA3, several HOX-cluster and other lncRNA conserved regions, one hammerhead ribozyme, one IRES); it
still contains 110 hits with E > 1e-5. The strict E ≤ 1e-5 table is given next to it so either set can be used. The
category assignment in `04_rfam_filter_and_categorise.py` follows the Rfam family type field, which is reproducible;
the miRNA, snoRNA and cis-regulatory counts quoted in the text were obtained by a manual assignment and differ slightly
(see the table above).
