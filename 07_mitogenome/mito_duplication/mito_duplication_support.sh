#!/usr/bin/env bash
# [original] local: <path>/mito_duplication_support.sh
# Quantitative support for the mitochondrial tandem duplication in the king penguin
# mitogenome (PZ518787.1, 20,520 bp).
#
# Produces:
#   depth_per_base.tsv          per-base HiFi depth across the mitogenome
#   region_depth_summary.tsv    mean/median depth per region  -> Supplementary Table
#   junction_spanning_reads.tsv counts of reads spanning each junction
#   junction_read_names.txt     read IDs (for the archive, if wanted)
#   mito_coverage.pdf           coverage plot -> Supplementary Figure
#
# Requires: minimap2, samtools (>=1.10), python3 with pysam + matplotlib
set -euo pipefail

# ------------------------------------------------------------------ inputs
HIFI=allpacbio.fastq.gz          # combined HiFi reads (58.54 Gb)
MITO=PZ518787.fasta              # deposited mitogenome, single record
HAP1=bAptPat1.hap1.fa            # nuclear haplotype 1
HAP2=bAptPat1.hap2.fa            # nuclear haplotype 2
MITO_NAME=PZ518787.1             # sequence name inside $MITO — must match the FASTA header
THREADS=32
MAPQ=20                          # discard ambiguous/NUMT-derived alignments

# ------------------------------------------------- 1. combined reference
# Mapping to mito alone would pull in NUMT-derived reads and inflate depth.
# Including both nuclear haplotypes lets those reads map where they belong.
cat "$MITO" "$HAP1" "$HAP2" > combined_ref.fa
samtools faidx combined_ref.fa

# ------------------------------------------------- 2. map HiFi reads
minimap2 -ax map-hifi -t "$THREADS" --secondary=no combined_ref.fa "$HIFI" \
  | samtools sort -@ 8 -o all_vs_combined.bam -
samtools index -@ 8 all_vs_combined.bam

# primary, non-supplementary alignments to the mitogenome only
samtools view -b -F 0x904 -q "$MAPQ" all_vs_combined.bam "$MITO_NAME" > mito.bam
samtools index mito.bam

# ------------------------------------------------- 3. per-base depth
samtools depth -a -Q "$MAPQ" -r "$MITO_NAME" mito.bam > depth_per_base.tsv

# ------------------------------------------------- 4. summarise
python3 - "$MITO_NAME" << 'PY'
import sys, statistics as st, pysam

mito = sys.argv[1]

# Region boundaries (1-based, inclusive) from the PZ518787.1 annotation.
# The duplicated block is [trnT - trnP - ND6 - trnE - control region] x 2.
REGIONS = [
    ("Single-copy region (trnF - CYTB)",        1,     14804),
    ("Duplicated block, copy 1 (trnT - CR1)",   14805, 17967),
    ("  ...  control region, copy 1",           15577, 17967),
    ("Duplicated block, copy 2 (trnT - CR2)",   17968, 20520),
    ("  ...  control region, copy 2",           18740, 20520),
    ("Whole mitogenome",                        1,     20520),
]

depth = {}
for line in open("depth_per_base.tsv"):
    _, pos, d = line.split()
    depth[int(pos)] = int(d)

with open("region_depth_summary.tsv", "w") as out:
    out.write("Region\tStart\tEnd\tLength (bp)\tMean depth\tMedian depth\tMin\tMax\t"
              "Mean depth relative to single-copy region\n")
    ref_mean = st.mean(depth.get(p, 0) for p in range(1, 14805))
    for name, s, e in REGIONS:
        vals = [depth.get(p, 0) for p in range(s, e + 1)]
        out.write(f"{name}\t{s:,}\t{e:,}\t{e-s+1:,}\t{st.mean(vals):.1f}\t"
                  f"{st.median(vals):.1f}\t{min(vals)}\t{max(vals)}\t"
                  f"{st.mean(vals)/ref_mean:.2f}\n")

# --------------------------------------------------------- junctions
# A read "spans" a junction if it aligns continuously across it with at least
# FLANK bp anchored on both sides. FLANK=1000 makes chance/spurious spanning
# implausible; HiFi N50 here is 15,051 bp so this is not limiting.
FLANK = 1000
JUNCTIONS = [
    ("CYTB / copy 1 (start of duplicated block)", 14804, 14805),
    ("copy 1 / copy 2 (junction between the two copies)", 17967, 17968),
]

bam = pysam.AlignmentFile("mito.bam", "rb")
with open("junction_spanning_reads.tsv", "w") as out, \
     open("junction_read_names.txt", "w") as names:
    out.write("Junction\tLeft position\tRight position\tFlank required (bp)\t"
              "Spanning reads\tMean flank left (bp)\tMean flank right (bp)\n")
    for label, left, right in JUNCTIONS:
        spanning, fl, fr = [], [], []
        for aln in bam.fetch(mito, max(0, left - 20000), right + 20000):
            if aln.is_secondary or aln.is_supplementary:
                continue
            s, e = aln.reference_start + 1, aln.reference_end   # 1-based inclusive
            if s <= left - FLANK + 1 and e >= right + FLANK - 1:
                spanning.append(aln.query_name)
                fl.append(left - s + 1)
                fr.append(e - right + 1)
        out.write(f"{label}\t{left:,}\t{right:,}\t{FLANK}\t{len(spanning)}\t"
                  f"{st.mean(fl) if fl else 0:.0f}\t{st.mean(fr) if fr else 0:.0f}\n")
        for n in spanning:
            names.write(f"{label}\t{n}\n")

# --------------------------------------------------------- plot
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

xs = sorted(depth)
ys = [depth[p] for p in xs]
fig, ax = plt.subplots(figsize=(10, 3.2))
ax.fill_between(xs, ys, step="mid", linewidth=0, color="#4C72B0", alpha=.85)
for s, e, lab, col in [(14805, 17967, "copy 1", "#DD8452"),
                       (17968, 20520, "copy 2", "#55A868")]:
    ax.axvspan(s, e, color=col, alpha=.18)
    ax.text((s + e) / 2, max(ys) * .93, lab, ha="center", fontsize=8)
ax.axhline(ref_mean, ls="--", lw=.8, color="k")
ax.text(200, ref_mean * 1.05, "mean depth, single-copy region", fontsize=7)
ax.set_xlabel("Position on mitogenome (bp)")
ax.set_ylabel("HiFi read depth")
ax.set_xlim(1, 20520)
ax.set_ylim(0, max(ys) * 1.05)
ax.spines[["top", "right"]].set_visible(False)
fig.tight_layout()
fig.savefig("mito_coverage.pdf")
print("done")
PY

echo
echo "=== region depth ==="; column -ts$'\t' region_depth_summary.tsv
echo
echo "=== junctions ==="; column -ts$'\t' junction_spanning_reads.tsv
