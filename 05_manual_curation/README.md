# 05 — Manual curation (with the Sanger Tree of Life team)

The YaHS scaffolds were curated in **PretextView** on a merged hap1 + hap2 map (Camilla Santos, then jointly;
save states May–July 2024) to correct mis-joins, identify the Z and W (BUSCO merged-map plots with
*Gallus gallus* genes; the PAR is visible) and order the microchromosomes. Sanger tools:
ASCC / FCS-GX (contamination: assemblies clean; the mitochondrial `scaffold_598` was removed from hap2 →
`hap2.bam.yahs.out_scaffolds_decont.final.fa`), **MicroFinder 0.1** (`data/KP.micros_hap*.MicroFinder.order.tsv`:
scaffold, number of conserved genes), and **rapid-curation** (`pretext-to-asm.py`, `multi_join.py`, commit
615e1b2) to build the curated FASTAs from the PretextView AGP.

Evidence generated here for the curation (all **original** unless stated):

| Script | What |
|---|---|
| `generate_N_ranges.py` | BED of N runs (trailing/internal Ns) — none found in either haplotype |
| `blastn_contamination_screen.sh` | blastn 2.11 of every scaffold vs NCBI nt (`-evalue 1e-25 -max_target_seqs 1 -max_hsps 1`), BlobTools-style check |
| `map_hifi_reads_minimap2.sh` | minimap2 2.28 `-ax map-hifi -H` HiFi reads → sorted BAM; mean depth of the primary assembly 42.6× |
| `map_hic_reads_bwamem2.sh` | bwa-mem2 2.2.1 of the cleaned Hi-C pairs to each haplotype (coverage track) |
| `self_alignment_minimap2.sh` | minimap2 `-ax asm5` of each haplotype against itself (duplications) |
| `nucmer_synteny_five_birds.sh` | MUMmer4 nucmer + show-coords of the merged haplotypes vs *Aquila chrysaetos* (GCF_900496995.4), *Ciconia maguari* (GCA_017639555.1), *Gallus gallus* GGswu1 (GCA_024206055.2, T2T), *Spheniscus humboldti* (GCA_027474245.1) and *Theristicus caerulescens* (GCA_020745775.1); dot plots viewed at https://dot.sandbox.bio to place microchromosome scaffolds (Supplementary Table 1) |
| `nucmer_chicken_per_haplotype.sh` | the same per haplotype against the chicken assembly |
| `split_hap1_hap2_merged.py` | splits the merged `hap1_hap2_merged.yahs.scaffolds.final.fa` (headers `HAP1_…`/`HAP2_…`) back into the two haplotypes |
| `reorder_fasta.py` | orders the curated FASTA by `data/KP.hap*_scaffold_sorted.order.txt` (SUPER_1 … SUPER_32, Z, W, then unplaced) and strips the `HAP1_` prefix → the sequences submitted to ENA |
| `count_N_gaps.py` | BED of gaps (≥ 1 N; ENA counts gaps ≥ 100 N) for the chromosome list |
| `FastCheck.py` | Sanger gEVAL helper: size difference between two FASTAs / TPF component check |

File history (numbers of sequences): hap1 YaHS raw 685 → curated 659 (`KP_hap1.final.primary.curated.fa`)
→ reordered/renamed 619 in the ENA/NCBI release (618 nuclear + MT). hap2 YaHS raw 733 → curated
`KP_hap2.final.alternate.curated.fa` → 696 in the release.
