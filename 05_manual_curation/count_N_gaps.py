# [original] local: <path>/count_N_gaps.py
from Bio import SeqIO
import re

fasta_file = "KP.pri.temp.fasta"      # Replace with your FASTA file
bed_file = "KP.pri.temp.gaps.bed"             # Output BED file
min_gap_length = 1                    # Set to 100 for ENA-style gaps

total_gaps = 0

with open(bed_file, "w") as bed_out:
    for record in SeqIO.parse(fasta_file, "fasta"):
        chrom = record.id
        sequence = str(record.seq).upper()

        for match in re.finditer(r'N+', sequence):
            start = match.start()
            end = match.end()
            length = end - start

            if length >= min_gap_length:
                bed_out.write(f"{chrom}\t{start}\t{end}\t{length}\n")
                total_gaps += 1

print(f"Found {total_gaps} N-gap(s) across all sequences.")
print(f"BED file written to: {bed_file}")
