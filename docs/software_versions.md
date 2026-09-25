# Software versions and parameters (Table 1 of the paper)

| Analysis step | Software and parameters | Version |
|---|---|---|
| Hi-C read cleaning | fastp (quality threshold 20; reads < 75 bp discarded) | 0.20 |
| k-mer counting | DSK (k = 21; PacBio HiFi reads) | 2.3.3 |
| Genome size, heterozygosity, repetitiveness | GenomeScope2 (k = 21) | 2.0 |
| Contig assembly | hifiasm, Hi-C integrated mode (PacBio HiFi + Hi-C; `hic.hap1.p_ctg`, `hic.hap2.p_ctg`) | 0.19 |
| Hi-C read alignment | Chromap (index `-k 27`; `--preset hic -t 16`; per haplotype) | 0.2.5 |
| Hi-C scaffolding | YaHS (`--no-mem-check`; `-r` 10 kb–500 Mb in 15 steps; default error correction, 0 breaks; per haplotype) | 1.2 |
| Hi-C contact maps | sanger-tol/curationpretext (Nextflow, per haplotype) | 1.0.1 |
| Manual curation | PretextView (misassembly correction, sex-chromosome identification) | 0.2.5 |
| Sex chromosome identification | BUSCO merged-map plots (*Gallus gallus* BUSCO genes) | 5.2.2 |
| Microchromosome identification | MicroFinder | 0.1 |
| Synteny dot plots | MUMmer4 nucmer vs five avian genomes; dot.sandbox.bio | 4.0 |
| Curated FASTA generation | sanger-tol/rapid-curation (`pretext-to-asm.py`, `multi_join.py`) | commit 615e1b2 |
| Contiguity | QUAST (quast-lg) | 5.2.0 |
| QV and k-mer completeness | Merqury (k = 21) | 1.3 |
| Assembly completeness | BUSCO (`-m geno -l aves_odb10`, n = 8,338) | 5.2.2 |
| Contamination screening | sanger-tol/ascc; FCS-GX | 0.1.0; 0.5.0 |
| Telomeres | tidk (`explore`; `search` in 100 kb windows) | 0.2.63 |
| Genome feature plot | Circos | 0.69-8 |
| Mitogenome assembly | MitoHiFi (PacBio HiFi reads) | 3.2.1 |
| Mitogenome annotation | MitoFinder | 1.4.2 |
| Duplication verification | MAFFT | 7.515 |
| Short-read mitogenome | NOVOPlasty (Illumina, SAMN40942370) | 4.3.5 |
| NUMT screening | minimap2; SAMtools; seqtk | 2.28; 1.21; 1.4 |
| TE annotation | Earl Grey (search term aves; custom avian starting library; Dfam partitions 0 and 3; < 100 bp removed) | 4.4.0 |
| | RepeatModeler; RepeatMasker (RMBLAST 2.10.0); Dfam; Repbase (RepeatMasker edition) | 2.0.5; 4.1.6; 3.8; 20181026 |
| RNA-seq alignment | HISAT2 (five-tissue mRNA-seq) | 2.2.1 |
| Transcript assembly | StringTie2 | 2.2.1 |
| Gene prediction | BRAKER3 in ETP mode, Singularity (`--prot_seq`, `--bam`, `--busco_lineage=aves_odb10`, `--species=AptPata`, `--gff3`, `--threads 16`) | 3.0.8 |
| | GeneMark-ETP (GeneMarkS-T, GeneMark-EP+ / ProtHint 2.6.0) | bundled |
| | AUGUSTUS (`--species=AptPata`) | 3.5.0 |
| | DIAMOND (ProtHint; GeneMark-ETP filtering) | 0.9.24.125; 2.0.15.153 |
| | TSEBRA (`best_by_compleasm.py`); miniprot; compleasm (`-l aves_odb10`) | 1.1.2.5; 0.12; 0.2.6 |
| Protein evidence | OrthoDB Vertebrata; Ensembl avian proteomes (n = 51) | v11; release 113 |
| Structural filtering and statistics | AGAT | 1.4.1 / 0.7.0 |
| Functional annotation | InterProScan; eggNOG-mapper (eggNOG v5); AGAT `agat_sp_manage_attributes.pl` | 5.72-103; 2; 0.7.0 |
| Annotation completeness | BUSCO (`-l aves_odb10`); OMArk; OMAmer | 5.7.1; 0.3.0; 2.0.3 |
| Manual inspection | IGV | 2.16.1 |
| QuantSeq alignment and counting | STAR; HTSeq | 2.7.11b; 2.0.3 |
| Expression analysis | DESeq2 (VST; tissue-enhanced log2FC ≥ 5 / ≤ −5; FDR < 0.01) | 1.40.0 |
| ncRNA detection | Infernal cmscan vs Rfam (overlaps and E-value > 1e-5 discarded) | 1.1.2; Rfam 15 |
| rRNA confirmation | RNAmmer | 1.2 |
| tRNA prediction | tRNAscan-SE (Cove score > 50) | 2.0.9 |
| Novel lncRNAs | minimap2 `--splice`; StringTie; DIAMOND (vs annotated proteins and UniProtKB 2025_01); CPC2; CPAT; PLEK | 2.28; 2.2.1; 0.9.24; 0.1; 3.0.5; 1.2 |

Notes from the run records: Chromap `--preset hic` expands to `-e 4 -q 1 --low-mem --split-alignment --pairs`; the alignment used for scaffolding was run on the first Hi-C library with `--preset hic --remove-pcr-duplicates --SAM` and converted to a name-sorted BAM (see `04_hic_scaffolding/`); `-k 27` is not Chromap's default (17). YaHS: `-r` set explicitly to the full 15-step list (the automatic default for a 1.3 Gb genome would stop at 20 Mb, 11 rounds), error correction and mapping-quality filter (`-q 10`) at defaults. hifiasm: `--primary` in addition to `--h1/--h2`. HISAT2: `--dta`. MitoHiFi: `-o 2` (vertebrate mitochondrial code), all other options at defaults. StringTie (lncRNA step): `-G better_UTR.gtf -A -C`.
