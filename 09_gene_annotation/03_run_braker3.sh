# [original] cluster: <path>/run_braker3.sh

## Needs to be run on the login node with singularity 

singularity exec -B <path>/ braker3.sif braker.pl \
--genome=<path>/KP_hap1.final.primary.curated.softmasked.fa \ ## softmasked genome!
--workingdir=<path>/KP_BRAKER3_annotation \
--threads 20 --gff3 \
--prot_seq=<path>/Vertebrata.fa \
--bam <path>/king_rnaseq_aligned.bam \
--species=KP.braker3
