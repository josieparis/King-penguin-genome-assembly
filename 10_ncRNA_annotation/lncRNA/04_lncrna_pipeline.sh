#!/bin/bash
# [RECONSTRUCTED] Novel lncRNA identification. Only the helper scripts (extract_novel.py, clean_headers.py,
# CPAT R files) and the outputs survive in cluster: <path>/lncRNA/
# and local: Genome_files/ncRNA_annotation_files/. The minimap2 command (from the log) and the
# StringTie command (recorded in the header of transcripts.gtf) are exact; the other steps are rewritten from the
# Methods and from the surviving file names. Versions: minimap2 2.28,
# StringTie 2.2.1, DIAMOND 0.9.24, CPC2 0.1 (CPC2_standalone-1.0.1), CPAT 3.0.5, PLEK 1.2.

genome=<path>/bAptPat1.hap1.1.fasta
transcriptome=<path>/Transcriptome_King.fa      # Paris et al. 2025
annotation=<path>/better_UTR.gtf   # protein-coding annotation with UTRs
proteins=agat_longest_better.aa             # longest-isoform proteins
uniprot=<path>/uniprot.dmnd   # Swiss-Prot + TrEMBL 2025_01

## 1. align the de novo transcriptome to the genome                                   [from log]
minimap2 -ax splice $genome $transcriptome > trans2genome_aligned.sam
samtools sort -o trans2genome_aligned.bam trans2genome_aligned.sam && samtools index trans2genome_aligned.bam

## 2. StringTie: transcripts relative to the known protein-coding genes; unannotated = potential novel
stringtie trans2genome_aligned.bam -o transcripts.gtf -G $annotation -A transcript_abundance.tsv -C merged_known_transcripts.gtf   # [exact, from the GTF header]
# novel = StringTie transcripts without a reference gene (STRG.* ids) -> novel_transcripts.txt
gffread -w all_transcripts.fa -g $genome transcripts.gtf
python clean_headers.py                  # all_transcripts.fa -> cleaned_transcripts.fa (STRG.X headers)
python extract_novel.py                  # novel_transcripts.txt + all_transcripts.fa -> novel_transcripts.fa (novel_only.fa)

## 3. remove anything with protein homology (DIAMOND blastx)
diamond makedb --in $proteins -d proteins_db
diamond blastx -q novel_only.fa -d proteins_db -o novel_vs_proteins.blastx --evalue 1e-5 --outfmt 6
#   transcripts with a hit removed -> novel_proteome_filtered.fa
diamond blastx -q novel_proteome_filtered.fa -d $uniprot -o novel_vs_uniprot.blastx --evalue 1e-5 --outfmt 6
#   transcripts with a hit removed -> novel_proteome_uniprot_filtered.fa

## 4. coding potential: CPC2, CPAT (species-specific model), PLEK
python CPC2.py -i novel_proteome_uniprot_filtered.fa -o CPC2_results.tsv
make_hexamer_tab.py -c bAptPat1_longest_iso.codingseq.fasta -n <noncoding_training.fa> > KP_hexamer.tsv
make_logitModel.py -x KP_hexamer.tsv -c bAptPat1_longest_iso.codingseq.fasta -n <noncoding_training.fa> -o KP_CPAT
cpat.py -x KP_hexamer.tsv -d KP_CPAT.logit.RData -g novel_proteome_uniprot_filtered.fa -o CPAT_output
python PLEK.py -fasta novel_proteome_uniprot_filtered.fa -out PLEK_Results.tsv -thread 4

## 5. keep transcripts > 200 nt called non-coding by all three tools -> final_non-coding_gene_list.tsv (n = 164)
##    (intersection done in a spreadsheet: intersected_CPC2_PLEK_CPAT.xlsx; length filter: filter_sequence_minlength.fasta)
seqkit grep -f <(cut -f1 final_non-coding_gene_list.tsv) novel_proteome_uniprot_filtered.fa > final_noncoding_extracted_sequences.fasta
python rename_lncRNA_headers.py           # -> bAptPat1-lncRNA-annotation.fasta ; coordinates from transcripts.gtf -> .bed/.gff
