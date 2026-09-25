#!/bin/bash
#PBS -l select=1:ncpus=16:mpiprocs=16
#PBS -q workq
# [original] HiFi read depth over the assemblies (minimap2 2.28, -x map-hifi with homopolymer-compressed seeds)

SD=<path>/minimap2-2.28_x64-linux
hap1_genome=<path>/AptPat.HiFi.asm.hic.hap1.p_ctg.fa
hap2_genome=<path>/AptPat.HiFi.asm.hic.hap2.p_ctg.fa
pri_genome=<path>/AptPat.HiFi.asm.hic.p_ctg.fa
reads=<path>/allpacbio.fastq.gz
output=<path>/genome_coverage

cd $output
for asm in hap1 hap2 primary; do
  case $asm in hap1) g=$hap1_genome;; hap2) g=$hap2_genome;; primary) g=$pri_genome;; esac
  $SD/minimap2 -ax map-hifi -H $g $reads -o ${asm}_hifi_reads.sam -t 16
  samtools view -@16 -bS ${asm}_hifi_reads.sam | samtools sort -@16 - -o ${asm}_hifi.sort.bam
  samtools depth ${asm}_hifi.sort.bam > ${asm}_depth.txt
done

## mean depth
awk '{ sum += $3; n++ } END { if (n > 0) print sum / n }' primary_depth.txt
