# [original] cluster: <path>/basecount.py
import gzip,sys
for path,label in [(sys.argv[i],sys.argv[i+1]) for i in range(1,len(sys.argv),2)]:
    A=C=G=T=N=tot=0
    with gzip.open(path,"rb") as fh:
        for line in fh:
            if line[:1]==b">": continue
            s=line.strip().upper()
            A+=s.count(b"A"); C+=s.count(b"C"); G+=s.count(b"G"); T+=s.count(b"T"); N+=s.count(b"N")
            tot+=len(s)
    acgt=A+C+G+T
    print(f"--- {label}")
    print(f"    A={A:,} C={C:,} G={G:,} T={T:,} N={N:,} other={tot-acgt-N:,}")
    print(f"    total={tot:,}  ACGT={acgt:,}")
    print(f"    GC%% of ACGT  = {100*(G+C)/acgt:.3f}")
    print(f"    GC%% of total = {100*(G+C)/tot:.3f}")
    sys.stdout.flush()
