#!/usr/bin/env python3
# [added for this repository] Reproduces the final lncRNA set from the three coding-potential tables:
#   CPC2  : label == "noncoding"
#   PLEK  : category == "Non-coding"
#   CPAT  : every ORF of a transcript is scored (CPAT_output.ORF_prob.tsv, species-specific logit model); an ORF with
#           coding probability < 0.4 counts as non-coding and the transcript is non-coding when the majority of its ORFs are
#           (the rule of lncRNA/scoring_CPAT.py). Transcripts without any ORF have no CPAT call and are not retained.
#   final : > 200 nt and non-coding by all three.
# Usage (from 10_ncRNA_annotation/): python3 06_lncrna_classify.py results/lncRNA
import sys, csv, collections, os
d = sys.argv[1]
cpc = {r["#ID"]: r for r in csv.DictReader(open(os.path.join(d, "CPC2_results.tsv")), delimiter="\t")}
plek = {}
for l in open(os.path.join(d, "PLEK_Results.tsv")).read().splitlines()[1:]:
    f = l.split("\t"); plek[f[0].lstrip(">")] = f
orfs = collections.defaultdict(list)
import re
for r in csv.DictReader(open(os.path.join(d, "CPAT_output.ORF_prob.tsv")), delimiter="\t"):
    tid = r.get("seq_ID") or re.sub(r"_ORF_\d+$", "", r["ID"])     # ORF_prob.tsv names ORFs <transcript>_ORF_<n>
    orfs[tid].append(float(r["Coding_prob"]))
final = []
with open(os.path.join(d, "lncRNA_classification.tsv"), "w") as out:
    out.write("transcript\tlength_nt\tCPC2\tPLEK\tCPAT_n_ORFs\tCPAT_n_noncoding_ORFs\tCPAT_call\tfinal_lncRNA\n")
    for tid in cpc:
        n = len(orfs.get(tid, [])); nnc = sum(1 for p in orfs.get(tid, []) if p < 0.4)
        cpat = "no ORF" if n == 0 else ("non-coding" if not (n - nnc > nnc) else "coding")
        c_nc = cpc[tid]["label"] == "noncoding"; p_nc = plek.get(tid, ["", "", "", "", ""])[4] == "Non-coding"
        keep = c_nc and p_nc and cpat == "non-coding" and int(cpc[tid]["length"]) > 200
        if keep: final.append(tid)
        out.write(f"{tid}\t{cpc[tid]['length']}\t{cpc[tid]['label']}\t{plek.get(tid, ['','','','',''])[4]}\t{n}\t{nnc}\t{cpat}\t{'yes' if keep else 'no'}\n")
with open(os.path.join(d, "final_lncRNA_gene_list.reproduced.tsv"), "w") as out:
    out.write("\n".join(sorted(final, key=lambda x: int(x.split(".")[1]))) + "\n")
ref = {l.strip() for l in open(os.path.join(d, "final_lncRNA_gene_list.tsv")) if l.strip()}
print(f"transcripts scored: {len(cpc)} | CPC2 non-coding: {sum(1 for r in cpc.values() if r['label']=='noncoding')} | PLEK non-coding: {sum(1 for f in plek.values() if f[4]=='Non-coding')} | final: {len(final)} | identical to the published list: {set(final)==ref}")
