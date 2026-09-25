#!/bin/bash
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -q workq
# [original] YaHS 1.2 scaffolding of each haplotype from the Chromap BAM (default error correction and MAPQ filter)

hap1=<path>/AptPat.HiFi.asm.hic.hap1.p_ctg.fa
hap2=<path>/AptPat.HiFi.asm.hic.hap2.p_ctg.fa
hap1_bam=<path>/AptPat.HiFi.run3.hap1.bam
hap2_bam=<path>/AptPat.HiFi.run3.hap2.bam
hap1_output=<path>/yahs/hap1
hap2_output=<path>/yahs/hap2
SD=<path>/yahs

cd $hap1_output
$SD/yahs --no-mem-check -r 10000,20000,50000,100000,200000,500000,1000000,2000000,5000000,10000000,20000000,50000000,100000000,200000000,500000000 $hap1 $hap1_bam

cd $hap2_output
$SD/yahs --no-mem-check -r 10000,20000,50000,100000,200000,500000,1000000,2000000,5000000,10000000,20000000,50000000,100000000,200000000,500000000 $hap2 $hap2_bam
