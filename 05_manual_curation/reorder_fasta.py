# [original] local: <path>/reorder_fasta.py
def reorder_and_modify_fasta(input_fasta, order_file, output_fasta, prefix_to_remove):
    # Read the desired order from the order file
    with open(order_file, 'r') as file:
        desired_order = [line.strip() for line in file]

    # Create a dictionary to store the FASTA records
    fasta_dict = {}
    
    with open(input_fasta, 'r') as infile:
        current_header = None
        current_sequence = []
        
        for line in infile:
            if line.startswith(">"):
                if current_header is not None:
                    fasta_dict[current_header] = ''.join(current_sequence)
                current_header = line.strip()
                current_sequence = []
            else:
                current_sequence.append(line.strip())
        
        # Add the last record
        if current_header is not None:
            fasta_dict[current_header] = ''.join(current_sequence)
    
    # Write the records to the output FASTA file in the desired order
    with open(output_fasta, 'w') as outfile:
        for header in desired_order:
            # Construct the full header (assuming the headers in the order file don't include the '>' prefix)
            full_header = f">{header}"
            if full_header in fasta_dict:
                # Remove the prefix and write the modified header
                modified_header = full_header.replace(f">{prefix_to_remove}", ">")
                outfile.write(f"{modified_header}\n")
                outfile.write(f"{fasta_dict[full_header]}\n")
            else:
                print(f"Warning: {header} not found in the input FASTA file.")

# File paths
input_fasta = "KP_HAP1_final.MT.fa"
order_file = "KP.hap1_scaffold_sorted.order.txt"
output_fasta = "KP_HAP1.temp.fasta"
prefix_to_remove = "HAP1_"

# Run the function
reorder_and_modify_fasta(input_fasta, order_file, output_fasta, prefix_to_remove)
