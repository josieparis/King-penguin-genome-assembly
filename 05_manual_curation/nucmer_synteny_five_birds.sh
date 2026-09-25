#!/bin/bash
# [original] cluster: <path>/run_nucmer.sh
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -q workq

## set all the directories for the genomes to perform alignments against

MASTER=<path>/genome

## other genomes
Aquila_chrysaetos=$MASTER/other_genomes/Aquila_chrysaetos/data/GCF_900496995.4/achr_genome.fna
Ciconia_magauri=$MASTER/other_genomes/Ciconia_magauri/data/GCA_017639555.1/cmag_genomic.fna
Gallus_gallus_GGswu1=$MASTER/other_genomes/Gallus_gallus_GGswu1/data/GCA_024206055.2/ggal_genomic.fna
#KP_genome=$MASTER/other_genomes
S_humboldti=$MASTER/other_genomes/S_humboldti/data/GCA_027474245.1/shum_genomic.fna
Theristicus_caerulescens=$MASTER/other_genomes/Theristicus_caerulescens/data/GCA_020745775.1/tcae_genomic.fna


## haplotype files (they have to be the scaffolded ones, not the contig ones from hifiasm!)
hap1=<path>/genome
hap2=<path>/genome

merged_haps=<path>/hap1_hap2_merged.yahs.scaffolds.final.fa

## output directories
WD1=$MASTER/synteny/KP_vs_Aquila_chrysaetos
WD2=$MASTER/synteny/KP_vs_Ciconia_magauri
WD3=$MASTER/synteny/KP_vs_Gallus_gallus_GGswu1
WD4=$MASTER/synteny/KP_vs_S_humboldti
WD5=$MASTER/synteny/KP_vs_Theristicus_caerulescens

cd $WD1
nucmer -p achr_haps $Aquila_chrysaetos $merged_haps
#nucmer -p achr_hap2 $Aquila_chrysaetos $hap2
show-coords achr_haps.delta > achr_haps.coords
#show-coords achr_hap2.delta > achr_hap2.coords


cd $WD2
nucmer -p cmag_haps $Ciconia_magauri $merged_haps
#nucmer -p cmag_hap2 $Ciconia_magauri $hap2
show-coords cmag_haps.delta > cmag_haps.coords
#show-coords cmag_hap2.delta > cmag_hap2.coords

cd $WD3
nucmer -p ggal_haps $Gallus_gallus_GGswu1 $merged_haps
#nucmer -p ggal_hap2 $Gallus_gallus_GGswu1 $hap2
show-coords ggal_hap1.delta > ggal_haps.coords
#show-coords ggal_hap2.delta > ggal_hap2.coords

cd $WD4
nucmer -p shum_haps $S_humboldti $merged_haps
#nucmer -p shum_hap2 $S_humboldti $hap2
show-coords shum_haps.delta > shum_haps.coords
#show-coords shum_hap2.delta > shum_hap2.coords

cd $WD5
nucmer -p tcae_haps $Theristicus_caerulescens $merged_haps
#nucmer -p tcae_hap2 $Theristicus_caerulescens $hap2
show-coords tcae_haps.delta > tcae_haps.coords
#show-coords tcae_hap2.delta > tcae_hap2.coords

