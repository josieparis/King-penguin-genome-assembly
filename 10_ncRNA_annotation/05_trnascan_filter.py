#!/usr/bin/env python3
# [added for this repository] tRNAscan-SE 2.0 tabular output -> tRNAs with Infernal score > 50 (the "Cove score" threshold of
# Ottenburghs et al. 2021 applied to the Inf score column) and isotype counts for the king penguin and Spheniscus humboldti.
# Usage (from 10_ncRNA_annotation/): python3 05_trnascan_filter.py results/trnascan
import sys, csv, collections, os
d = sys.argv[1]; MIN = 50
iso = {}
for sp, fn in [("KP", "KP.trnascan_output.txt"), ("S_humboldti", "S_humboldti.trnascan_output.txt")]:
    rows = [l.rstrip("\n").split("\t") for l in open(os.path.join(d, fn))][3:]
    rows = [[c.strip() for c in r] for r in rows if len(r) >= 9]
    kept = [r for r in rows if float(r[8]) > MIN]
    with open(os.path.join(d, f"{sp}.tRNAs_score_gt50.tsv"), "w") as out:
        w = csv.writer(out, delimiter="\t", lineterminator="\n")
        w.writerow(["sequence","tRNA_no","begin","end","type","anticodon","intron_begin","intron_end","score","note"])
        for r in kept: w.writerow(r[:10] if len(r) >= 10 else r + [""] * (10 - len(r)))
    iso[sp] = collections.Counter(r[4] for r in kept)
    print(f"{sp}: predicted {len(rows)}, score > {MIN}: {len(kept)}, pseudogenes among kept: {sum(1 for r in kept if 'pseudo' in ' '.join(r).lower())}")
keys = sorted(set(iso["KP"]) | set(iso["S_humboldti"]))
with open(os.path.join(d, "trna_isotype_counts_score_gt50.tsv"), "w") as out:
    out.write("isotype\tking_penguin\tS_humboldti\n")
    for k in keys: out.write(f"{k}\t{iso['KP'][k]}\t{iso['S_humboldti'][k]}\n")
    out.write(f"total\t{sum(iso['KP'].values())}\t{sum(iso['S_humboldti'].values())}\n")
