#!/bin/bash
# [from log] sanger-tol/curationpretext (revision ec8c7088e5, released as v1.0.1), Nextflow 23.10 + Singularity,
# launched from the login node; commands copied from .nextflow.log.
# --longread and --cram take DIRECTORIES holding only the indexed HiFi fasta.gz / the merged Hi-C CRAM.
# The config file enables Singularity; --max_cpus had to be given on the command line.

export NXF_OPTS='-Xms1g -Xmx4g'
export NXF_SINGULARITY_LIBRARYDIR=<path>/cache
CONF=<path>/cluster.config
HIFI_DIR=<path>/pacbio/       # allpacbio.fasta.gz (+ .fai)
CRAM_DIR=<path>/hic-arima/    # HiC_merged.cram (+ .crai), both Hi-C libraries

## haplotype 1 (YaHS scaffolds)
nextflow run --max_cpus 8 sanger-tol/curationpretext \
  --input <path>/hap1.yahs.out_scaffolds_final.fa \
  --longread $HIFI_DIR --longread_type hifi \
  --cram $CRAM_DIR \
  --sample KP_hap1_pretext --teloseq TTAGGG \
  --outdir <path>/pretext-hap1 \
  -profile singularity -c $CONF

## haplotype 2 (YaHS scaffolds after removal of the mitochondrial scaffold_598 by ASCC)
nextflow run --max_cpus 8 sanger-tol/curationpretext \
  --input <path>/hap2.yahs.out_scaffolds_decont.final.fa \
  --longread $HIFI_DIR --longread_type hifi \
  --cram $CRAM_DIR \
  --sample KP_hap2_pretext --teloseq TTAGGG \
  --outdir <path>/pretext-hap2 \
  -profile singularity -c $CONF
