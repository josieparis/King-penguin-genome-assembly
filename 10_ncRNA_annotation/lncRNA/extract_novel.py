# [original] cluster: <path>/extract_novel.py
novel_ids = set()
with open("novel_transcripts.txt") as f:
    for line in f:
        novel_ids.add(line.strip())  # Store STRG.X in a set

with open("all_transcripts.fa") as infile, open("novel_transcripts.fa", "w") as outfile:
    write = False
    for line in infile:
        if line.startswith(">"):
            transcript_id = line.split()[0][1:].split(".")[0]  # Extract STRG.X from header
            write = transcript_id in novel_ids  # Check if it's a novel transcript
        if write:
            outfile.write(line)
