#!/bin/bash
# [original] cluster: <path>/run3.juicer.10k.corr.sh
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -q workq


MASTER=<path>/genome
run3_hap1=$MASTER/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap1.p_ctg.fa
run3_hap2=$MASTER/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap2.p_ctg.fa

hap1_bam=$MASTER/hi-C-map/output/run3/chromap/AptPat.HiFi.run3.hap1.bam
hap2_bam=$MASTER/hi-C-map/output/run3/chromap/AptPat.HiFi.run3.hap2.bam


hap1_AGP=$MASTER/hi-C-map/output/run3/yahs/error_cor/hap1/yahs.out_scaffolds_final.agp
hap2_AGP=$MASTER/hi-C-map/output/run3/yahs/error_cor/hap2/yahs.out_scaffolds_final.agp

output_hap1=$MASTER/hi-C-map/output/run3/juicer/hap1
output_hap2=$MASTER/hi-C-map/output/run3/juicer/hap2

SD1=<path>/yahs
SD2=<path>/juicertools

## hap1 
cd $output_hap1

## Part 1
# you need to run this code first (from the yahs binary of juicer) to generate the files for part 2
#e.g.: $SD1/juicer pre -a -o out_JBAT $BAM $AGP $REF.fai > out_JBAT.log 2>&1

$SD1/juicer pre -a -o out_JBAT $hap1_bam $hap1_AGP $run3_hap1.fai > out_JBAT.log 2>&1

## part 2

(java -jar -Xmx70G $SD2/juicer_tools.1.9.9_jcuda.0.8.jar pre out_JBAT.txt out_JBAT.hic.part <(cat out_JBAT.log | grep PRE_C_SIZE | awk '{print $2" "$3}')) && (mv out_JBAT.hic.part out_JBAT.hic)

### hap2
cd $output_hap2

## Part 1
# you need to run this code first (from the yahs binary of juicer) to generate the files for part 2
#e.g.: $SD1/juicer pre -a -o out_JBAT $BAM $AGP $REF.fai > out_JBAT.log 2>&1

$SD1/juicer pre -a -o out_JBAT $hap2_bam $hap2_AGP $run3_hap2.fai > out_JBAT.log 2>&1

## part 2

(java -jar -Xmx70G $SD2/juicer_tools.1.9.9_jcuda.0.8.jar pre out_JBAT.txt out_JBAT.hic.part <(cat out_JBAT.log | grep PRE_C_SIZE | awk '{print $2" "$3}')) && (mv out_JBAT.hic.part out_JBAT.hic)


