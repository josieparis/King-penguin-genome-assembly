# [original] cluster: <path>/clean_headers.py
with open("all_transcripts.fa") as infile, open("cleaned_transcripts.fa", "w") as outfile:
    for line in infile:
        if line.startswith(">"):
            transcript_id = line.split()[0][1:].rsplit(".", 1)[0]  # Extract "STRG.X" keeping the number
            outfile.write(f">{transcript_id}\n")
        else:
            outfile.write(line)
