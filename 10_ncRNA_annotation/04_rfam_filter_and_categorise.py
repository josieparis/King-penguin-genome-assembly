#!/usr/bin/env python3
# [added for this repository] Reproducible processing of the Infernal/Rfam scan and categorisation of the hits.
#   1. de-overlap the cmscan --fmt 2 table with Infernal's own overlap annotation (keep olp '*' and '^', drop '=')
#   2. (optionally) apply an E-value threshold
#   3. assign each hit to an ncRNA category from the Rfam family "type" (data/rfam15_family_types.tsv, Rfam 15.0)
#   4. count hits per category for (a) the published table (Supplementary Table 8) and (b) the strict E-value set
# Usage (from 10_ncRNA_annotation/):
#   python3 04_rfam_filter_and_categorise.py results/rfam/KP-genome-rfam.tblout.gz ../annotation/bAptPat1-ncRNA-annotation.tsv.gz results/rfam
import sys, gzip, csv, collections, os
tblout, published, outdir = sys.argv[1], sys.argv[2], sys.argv[3]
EMAX = 1e-5
types = {r["rfam_acc"]: r["type"] for r in csv.DictReader(open(os.path.join(os.path.dirname(__file__), "data/rfam15_family_types.tsv")), delimiter="\t")}

def category(acc):
    t = types.get(acc, "")
    if "miRNA" in t: return "miRNA"
    if "snoRNA" in t: return "snoRNA"
    if "snRNA" in t: return "snRNA"
    if "rRNA" in t: return "rRNA"
    if "lncRNA" in t: return "lncRNA"
    if t.startswith("Cis-reg"): return "cis-regulatory element"
    if "ribozyme" in t: return "ribozyme"
    if "tRNA" in t: return "tRNA"
    return "other ncRNA gene"

cols = ["target_name","accession","query_name","clan_name","start","end","strand","truncated","pass","GC","bias","score","e-value","incl","olp","description_of_target"]
hits = []
with gzip.open(tblout, "rt") as fh:
    for line in fh:
        if line.startswith("#"): continue
        f = line.split()
        hits.append(dict(zip(cols, [f[1], f[2], f[3], f[5], f[9], f[10], f[11], f[12], f[13], f[14], f[15], f[16], f[17], f[18], f[19], " ".join(f[26:])])))
deov = [h for h in hits if h["olp"] != "="]
strict = [h for h in deov if float(h["e-value"]) <= EMAX]
def write(rows, fn):
    with open(fn, "w") as out:
        w = csv.writer(out, delimiter="\t", lineterminator="\n"); w.writerow(cols + ["rfam_type", "category"])
        for h in rows: w.writerow([h[c] for c in cols] + [types.get(h["accession"], ""), category(h["accession"])])
write(deov, f"{outdir}/KP-genome-rfam.deoverlapped.categorised.tsv")
write(strict, f"{outdir}/KP-genome-rfam.deoverlapped.evalue1e-5.categorised.tsv")
# published table (Supplementary Table 8 / annotation/bAptPat1-ncRNA-annotation.tsv.gz)
pub = list(csv.DictReader(gzip.open(published, "rt"), delimiter="\t"))
with open(f"{outdir}/SuppTable8_published.categorised.tsv", "w") as out:
    w = csv.writer(out, delimiter="\t", lineterminator="\n"); w.writerow(list(pub[0].keys()) + ["rfam_type", "category"])
    for r in pub: w.writerow(list(r.values()) + [types.get(r["accession"], ""), category(r["accession"])])
def counts(rows, key="accession"):
    c = collections.Counter(category(r[key]) for r in rows)
    c["rRNA (eukaryotic families only)"] = sum(1 for r in rows if category(r[key]) == "rRNA" and "eukarya" in r["target_name"] or r["target_name"] in ("5S_rRNA", "5_8S_rRNA"))
    return c
cp, cs, cd = counts(pub), counts(strict), counts(deov)
order = ["miRNA","snoRNA","snRNA","rRNA","rRNA (eukaryotic families only)","lncRNA","cis-regulatory element","ribozyme","tRNA","other ncRNA gene"]
with open(f"{outdir}/rfam_category_counts.tsv", "w") as out:
    out.write("category\tpublished_table_SuppTable8\tdeoverlapped_all\tdeoverlapped_Evalue_le_1e-5\n")
    for k in order: out.write(f"{k}\t{cp[k]}\t{cd[k]}\t{cs[k]}\n")
    out.write(f"total hits\t{len(pub)}\t{len(deov)}\t{len(strict)}\n")
print(open(f"{outdir}/rfam_category_counts.tsv").read())
