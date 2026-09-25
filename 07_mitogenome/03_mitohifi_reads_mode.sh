#!/bin/bash
# [original] MitoHiFi in reads mode (Singularity image), run on the login node with all inputs in the working directory.
# Input reads = HiFi reads after removal of the 15 NUMT-derived reads (data/NUMT_reads_removed_before_mitohifi.txt).
# -o 2 = vertebrate mitochondrial genetic code; all other options at their defaults (reads longer than the
# reference mitogenome are dropped, MitoFinder annotation).

singularity exec -B ${PWD}:${PWD} mitohifi.sif mitohifi.py -r no_NUMTs.fastq.gz -f NC_045377.1.fasta -g NC_045377.1.gb -o 2 -t 12
