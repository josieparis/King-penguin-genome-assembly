#!/bin/bash
# [original] cluster: <path>/align_pacbio_genome.sh
#SBATCH -D . 
#SBATCH -p debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=48:00:00
#SBATCH --job-name=align_reads
#SBATCH --error=logs/align_reads.err.txt  
#SBATCH --output=logs/align_reads.out.txt  
#SBATCH --export=All

SD=<path>/minimap2-2.28_x64-linux

assembly_pri=<path>/KP_hap1.final.primary.curated.fa
assembly_alt=<path>/KP_hap2.final.alternate.curated.fa

mitogenome=<path>/NC_045377.1.fasta

reads=<path>/allpacbio.fastq.gz
output=<path>/alignments

cd $output

### primary genome
## align reads to primary and bam
minimap2 --secondary=no -ax map-hifi -H $assembly_pri $reads -o assembly_pri_hifi_reads.sam -t 16
# convert to bam, sort
samtools view -@16 -bS assembly_pri_hifi_reads.sam | samtools sort -@16 - -o assembly_pri_hifi.sorted.bam
## filtering if sorted, only mapped reads needed
samtools view --threads 16 -F 0x4 -bS assembly_pri_hifi.sorted.bam | samtools sort -@16 - -o assembly_pri_hifi.mapped.sorted.bam


### alternative genome
## align reads to alternate and bam
minimap2 --secondary=no -ax map-hifi -H $assembly_alt $reads -o assembly_alt_hifi_reads.sam -t 16
# convert to bam, sort
samtools view -@16 -bS assembly_alt_hifi_reads.sam | samtools sort -@16 - -o assembly_alt_hifi.sorted.bam
## filtering if sorted, only mapped reads needed
samtools view --threads 16 -F 0x4 -bS assembly_alt_hifi.sorted.bam | samtools sort -@16 - -o assembly_alt_hifi.mapped.sorted.bam


### map to mitogenome
minimap2 --secondary=no -ax map-hifi -H $mitogenome $reads -o mitogenome_hifi_reads.sam -t 16
# convert to bam, sort
samtools view -@16 -bS mitogenome_hifi_reads.sam | samtools sort -@16 - -o mitogenome_hifi.sorted.bam
## filtering if sorted, only mapped reads needed
samtools view --threads 16 -F 0x4 -bS mitogenome_hifi.sorted.bam | samtools sort -@16 - -o mitogenome_hifi.mapped.sorted.bam

