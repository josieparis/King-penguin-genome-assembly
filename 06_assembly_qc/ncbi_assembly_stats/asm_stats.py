# [original] cluster: <path>/asm_stats.py
import gzip, sys, re
def stats(path,label):
    names=[];lens=[];contigs=[];gap_n=0;gap_bases=0
    seq=[]
    def flush():
        nonlocal gap_n,gap_bases
        if not seq: return
        s="".join(seq); lens.append(len(s))
        parts=re.split(r"[Nn]+",s)
        runs=re.findall(r"[Nn]+",s)
        gap_n+=len(runs); gap_bases+=sum(len(r) for r in runs)
        contigs.extend(len(p) for p in parts if p)
    with gzip.open(path,"rt") as fh:
        for line in fh:
            if line[0]==">":
                flush(); seq.clear(); names.append(line[1:].split()[0])
            else: seq.append(line.strip())
        flush()
    def n50(v):
        v=sorted(v,reverse=True); t=sum(v); c=0
        for i,x in enumerate(v,1):
            c+=x
            if c>=t/2: return x,i
        return 0,0
    sN,sL=n50(lens); cN,cL=n50(contigs)
    print("="*64); print(label); print("="*64)
    print(f"scaffolds            : {len(lens)}")
    print(f"total bases          : {sum(lens):,}")
    print(f"ungapped bases       : {sum(contigs):,}")
    print(f"longest scaffold     : {max(lens):,}")
    print(f"scaffold N50         : {sN:,}  (L50 {sL})")
    print(f"contigs              : {len(contigs)}")
    print(f"LONGEST CONTIG       : {max(contigs):,}")
    print(f"contig N50           : {cN:,}  (L50 {cL})")
    print(f"number of gaps       : {gap_n}")
    print(f"gap bases (N)        : {gap_bases:,}")
    gc=None
    print()
for p,l in [(sys.argv[i],sys.argv[i+1]) for i in range(1,len(sys.argv),2)]:
    stats(p,l)
