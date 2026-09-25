# [original] local: <path>/chromosome_lengths.R
# new general run
rm(list=ls()) #clears all variables
objects() # clear all objects
graphics.off() #close all figures

## load libs
lib<-c("ggplot2", "grid", "gridExtra","stringr", "data.table", "plyr", "cowplot", "dplyr", "tidyverse")
lapply(lib,library,character.only=T)

setwd("<path>/Genome_files/")

dd <- read.csv("assemblies/bAptPat1.pri.cur.softmasked.fasta.fai",sep="\t",h=F)
head(dd)

dd <- dd %>%
  filter(grepl("^SUPER_", V1))

dd$V1 <- factor(dd$V1, levels = unique(dd$V1))


ggplot(dd)+
  geom_col(aes(x=V1,y=V2))+
  theme(axis.text.x=element_text(angle=45))
