# [original] local: <path>/regioneR_gene_clustering.R
rm(list=ls()) #clears all variables
objects() # clear all objects
graphics.off() #close all figures

#if (!require("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")

#BiocManager::install("regioneR")


## load libs

lib<-c("regioneR","ggplot2","RColorBrewer","tidyverse","ggrepel")
lapply(lib,library,character.only=T)

setwd("<path>/regioneR/")

all_genes <- toGRanges("all_genes.bed")
brain_genes <- toGRanges("brain_sig0.05.fc5.bed")

random.RS <- resampleRegions(brain_genes, universe=all_genes)
numOverlaps(random.RS, brain_genes)


pt <- permTest(A=brain_genes, ntimes=50, randomize.function=resampleRegions, universe=all_genes,
               evaluate.function=numOverlaps, B=all_genes,verbose=FALSE)


library(regioneR)

# Define the randomization function
randomize_within_chromosomes <- function(x) {
  randomizeRegions(x, genome = NULL, per.chromosome = TRUE)
}

evaluate_function <- function(A) {
  # Count the number of overlaps between the genes in A and the genes in the universe (already managed by permTest)
  overlap_count <- sum(countOverlaps(A, all_genes) > 0)  # count the number of overlapping genes
  return(overlap_count)
}

result <- permTest(A = brain_genes, 
                   universe = all_genes, 
                   ntimes = 1000, 
                   randomize.function = randomize_within_chromosomes, 
                   evaluate.function = evaluate_function)

# Perform the permutation test
result <- permTest(A = brain_genes, universe = all_genes, ntimes = 1000, randomize.function = randomize_within_chromosomes)

# View the results
print(result)






