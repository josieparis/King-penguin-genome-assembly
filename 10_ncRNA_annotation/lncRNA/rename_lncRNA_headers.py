# [original] local: <path>/rename_lncRNA_headers.py
from Bio import SeqIO

input_fasta = "final_noncoding_extracted_sequences.fasta"
output_fasta = "bAptPat1-lncRNA-annotation.fasta"

with open(output_fasta, "w") as out_f:
    for i, record in enumerate(SeqIO.parse(input_fasta, "fasta"), start=1):
        new_header = f"lncRNA_{i:02d}_length_{len(record.seq)}"
        record.id = new_header
        record.description = ""
        SeqIO.write(record, out_f, "fasta")

print("FASTA headers updated successfully!")
