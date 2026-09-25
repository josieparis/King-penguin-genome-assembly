# [original] local: <path>/penguin_genome_contig_lengths.R
# new general run
rm(list=ls()) #clears all variables
objects() # clear all objects
graphics.off() #close all figures

## load libs
lib<-c("ggplot2","tidyverse")
lapply(lib,library,character.only=T)

setwd("<path>/genome_analysis/")

dd <- read.table("./run_3/AptPat.HiFi.asm.hic.hap2_contig_lengths.txt",h=F)

ggplot(dd)+
  geom_histogram(aes(x=V1))


min(dd$V1)
quantile(dd$V1,c(0.25,0.75))
