# [original] cluster: <path>/split_hap1_hap2.py
def split_fasta(input_fasta, hap1_output, hap2_output):
    with open(input_fasta, 'r') as infile, \
         open(hap1_output, 'w') as hap1_out, \
         open(hap2_output, 'w') as hap2_out:
        
        current_output = None
        
        for line in infile:
            if line.startswith(">"):
                # Determine the output file based on the header prefix
                if line.startswith(">HAP1_"):
                    current_output = hap1_out
                elif line.startswith(">HAP2_"):
                    current_output = hap2_out
                else:
                    current_output = None  # In case there's a header without the specified prefixes
            
            # Write the current line to the determined output file
            if current_output is not None:
                current_output.write(line)

# File paths
input_fasta = "hap1_hap2_merged.yahs.scaffolds.final.fa"
hap1_output = "hap1_yahs.final.raw.fasta"
hap2_output = "hap2_yahs.final.raw.fasta"

# Run the function
split_fasta(input_fasta, hap1_output, hap2_output)
