# Mitochondrial duplication — supplementary figure and tables

All files regenerated together from `HiFi-vs-final_mitogenome.sorted.bam` and
`final_mitogenome.fasta` (`atg000001l_rc_rotated`, 20,520 bp = PZ518787.1). The figure is
drawn directly from `read_alignments.tsv` and `depth_per_base.tsv`, so figure and tables
cannot disagree.

## Files

| File | Role |
|---|---|
| `SuppFig_mito_duplication.pdf` / `.png` | Supplementary Figure |
| `region_depth_summary.tsv` | Supplementary Table — read depth by region |
| `junction_spanning_reads.tsv` | Supplementary Table — junction-spanning read counts |
| `read_alignments.tsv` | **underlying data for the read panel** — one row per read |
| `depth_per_base.tsv` | underlying data for the depth panel — 20,520 rows |
| `mito_doubled.fa` | doubled reference used for mapping (archive for reproducibility) |

## Method

The mitogenome is circular but stored linearly, and the duplicated block sits at the 3′ end
of that representation. Mapping to the linear sequence soft-clips reads crossing the origin
(29 of 46 reads here) and under-counts depth over the duplication, giving ratios of 0.70 and
0.54 — an artefact. Reads were therefore mapped to a doubled reference (the sequence
concatenated to itself, `mito_doubled.fa`) with minimap2 `map-hifi`, the single best primary
alignment retained per read, and coordinates folded back onto 1–20,520.

Coordinates in `read_alignments.tsv` are on that folded frame: for the 29 reads crossing the
origin, `Alignment end` is numerically smaller than `Alignment start`, and
`Aligned span (bp)` gives the true contiguous length. `Crosses sequence origin` flags them.

A read "spans" a junction if a single contiguous alignment covers it with at least 1 kb
aligned on both sides.

## Results

Read depth (`region_depth_summary.tsv`):

| Region | Coordinates | Length (bp) | Mean | Median | Range | Ratio to single-copy |
|---|---|---|---|---|---|---|
| Single-copy region (trnF–CYTB) | 1–14,804 | 14,804 | 28.4× | 29 | 21–37 | 1.00 |
| Duplicated block, copy 1 | 14,805–17,967 | 3,163 | 21.3× | 22 | 19–23 | 0.75 |
| — control region, copy 1 | 15,577–17,967 | 2,391 | 21.1× | 21 | 19–23 | 0.74 |
| Duplicated block, copy 2 | 17,968–20,520 | 2,553 | 29.3× | 30 | 23–32 | 1.03 |
| — control region, copy 2 | 18,740–20,520 | 1,781 | 30.5× | 30 | 29–32 | 1.07 |
| Whole mitogenome | 1–20,520 | 20,520 | 27.4× | 28 | 19–37 | 0.96 |

Junction-spanning reads (`junction_spanning_reads.tsv`):

| Junction | Position | ≥1 kb | ≥2 kb | ≥5 kb |
|---|---|---|---|---|
| CYTB / copy 1 | 14,804/14,805 | 20 | 16 | 6 |
| Copy 1 / copy 2 | 17,967/17,968 | 21 | 14 | 9 |

14 reads traverse the entire duplicated region in a single contiguous alignment.

## Draft figure legend

**HiFi read support for the tandem duplication in the king penguin mitogenome.**
(Top) Per-base HiFi read depth across the 20,520 bp mitogenome (GenBank PZ518787.1). The
dashed line marks the mean depth of the single-copy region (positions 1–14,804; 28.4×).
(Bottom) Individual HiFi read alignments (n = 46), ordered by start position. Reads spanning
the junction between the two copies of the duplicated block (positions 17,967/17,968) with at
least 1 kb of contiguous alignment on either side are shown in light red (n = 21); of these,
reads traversing the entire duplicated region in a single contiguous alignment, spanning both
junctions with at least 1 kb of flanking alignment, are shown in dark red (n = 14). Remaining
reads are grey. Shading marks copy 1 (14,805–17,967) and copy 2 (17,968–20,520) of the
duplicated block; vertical dashed lines mark the two junctions. Because the mitogenome is
circular, reads were mapped to a doubled reference and coordinates folded back onto the
20,520 bp sequence; 29 reads cross the sequence origin and are drawn as two segments on the
same row.

## Notes

The `MAPQ` column in `read_alignments.tsv` comes from the doubled-reference mapping, where
every position occurs twice and MAPQ is therefore 0 or near-0 by construction. It is not a
quality flag and should not be interpreted as one — in the original single-copy mapping all
but one read had MAPQ 60. Consider deleting that column before submission, or explaining it
in the table legend.

`Alignment NM` is the edit distance of the alignment, included for transparency.

For the Zenodo deposit: `read_alignments.tsv`, `depth_per_base.tsv` and `mito_doubled.fa`
are the three files needed to reproduce the figure.
