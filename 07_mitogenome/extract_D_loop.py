# [original] local: <path>/extract_D_loop.py
from Bio import SeqIO
import re

# Load the FASTA file
fasta_file = "final_mitogenome_mitohifi_v1.fasta"  # Change this to your filename

# Define common D-loop motifs (adjust based on species)
dloop_motifs = [r'TACATACATAC', r'CCCCCCC', r'GGGGGGG', r'GACATAGACAT']

# Read sequence
for record in SeqIO.parse(fasta_file, "fasta"):
    sequence = str(record.seq)

    # Search for D-loop motifs
    for motif in dloop_motifs:
        match = re.search(motif, sequence, re.IGNORECASE)
        if match:
            print(f"Possible D-loop region detected at position: {match.start()} - {match.end()}")
