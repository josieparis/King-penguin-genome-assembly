# [original] local: <path>/calculate_percent_identity.py
from Bio import AlignIO

# Load alignment
alignment = AlignIO.read("Leu_genes_aligned.fasta", "fasta")
num_sequences = len(alignment)
alignment_length = alignment.get_alignment_length()

# Calculate similarity
identical_sites = 0
for i in range(alignment_length):
    column = [seq[i] for seq in alignment]
    most_common = max(set(column), key=column.count)
    if column.count(most_common) == num_sequences:
        identical_sites += 1

# Compute percentage similarity
percent_similarity = (identical_sites / alignment_length) * 100
print(f"Alignment Similarity: {percent_similarity:.2f}%")
