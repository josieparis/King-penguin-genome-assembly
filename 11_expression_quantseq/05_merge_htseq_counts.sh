#!/bin/bash
# [original] cluster: <path>/README_merge_organise (commands run interactively)
FILES=$(ls -t -v *.txt | tr '\n' ' ');

echo $FILES
awk 'NF > 1{ a[$1] = a[$1]"\t"$2} END {for( i in a ) print i a[i]}' $FILES > all_quant_htseq.txt


sort -k1.2n all_quant_htseq.txt > sorted_counts.txt


cat sorted_counts.txt | grep -v "^_" | grep -v "MSTRG" > all_quant_htseq.sorted.txt 

echo $FILES | sed 's/.htseq.txt//g'

echo -e "Gene\tKB01\tKB02\tKB03\tKB04\tKB05\tKB06\tKB07\tKB08\tKB09\tKB10\tKK01\tKK02\tKK03\tKK04\tKK05\tKK06\tKK07\tKK08\tKK09\tKK10\tKL01\tKL02\tKL03\tKL04\tKL05\tKL06\tKL07\tKL08\tKL09\tKL10\tKM01\tKM02\tKM03\tKM04\tKM05\tKM06\tKM07\tKM08\tKM09\tKM10\tKS01\tKS02\tKS03\tKS04\tKS05\tKS06\tKS07\tKS08\tKS09\tKS10" | cat - all_quant_htseq.sorted.txt > final_counts.txt



