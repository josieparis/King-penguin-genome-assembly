# [original] local: <path>/gene_expression_bins.R
# new general run
rm(list=ls()) #clears all variables
objects() # clear all objects
graphics.off() #close all figures

## load libs
lib<-c("DESeq2","ggplot2","RColorBrewer","tidyverse","dplyr", "viridis")
lapply(lib,library,character.only=T)


#### set your working directory
setwd("<path>/gene_expression_analysis/")

# read in targets
king_targets <- read.table("king_all_tissues",h=T)

#### load raw counts
counts <- read.table("final_counts.txt", 
                     stringsAsFactors=F,sep="\t",h=T)
head(counts)

#### make gene column as row header
counts <- counts %>% column_to_rownames("Gene")

keep <- rowSums((counts)) >= 1
counts2 <- counts[keep,]
dim(counts2) ## new dimensions

##### set the design 
design <- as.formula(~0 + Tissue)

countdata <- counts2

########  generate your deseq matrix based on the design
ddsObj <- DESeqDataSetFromMatrix(countData = round(countdata),
                                 colData = king_targets,
                                 design = design)

#### perform median ratio normalisation
ddsObj<-estimateSizeFactors(ddsObj)


## plotting PCA space:
vsd <- vst(ddsObj, blind=TRUE)
head(assay(vsd), 2)

vst_counts <- assay(vsd)
dim(vst_counts)

#(1) Define your tissue groups from the data frame (counts2)
tissues <- list(
  Brain  = grep("^KB", colnames(counts2), value = TRUE),
  Kidney = grep("^KK", colnames(counts2), value = TRUE),
  Liver  = grep("^KL", colnames(counts2), value = TRUE),
  Muscle = grep("^KM", colnames(counts2), value = TRUE),
  Skin   = grep("^KS", colnames(counts2), value = TRUE)
)

# (2) Create a function that maps an individual count to a bin label
assign_bin <- function(x) {
  if (x == 0) {
    return("0")
  } else if (x > 0 & x <= 50) {
    return("0-50")
  } else if (x > 50 & x <= 100) {
    return("50-100")
  } else if (x > 100 & x <= 150) {
    return("100-150")
  } else if (x > 150 & x <= 200) {
    return("150-200")
  } else {
    return(">200")
  }
}

# (2) Create a function that maps an individual count to a bin label
assign_bin <- function(x) {
  if (x == 0) {
    return("0")
  } else if (x > 0 & x <= 50) {
    return("0-50")
  } else if (x > 50 & x <= 100) {
    return("50-100")
  } else if (x > 100 & x <= 200) {
    return("100-200")
  } else if (x > 200 & x <= 500) {
    return("200-500")
  } else {
    return(">500")
  }
}


# (3) Create a function that, for a given gene's counts in one tissue, 
# returns a bin label if at least 5 out of 10 samples fall into that bin.
get_gene_bin <- function(gene_counts, min_samples = 5) {
  # Apply the bin assignment to each sample's count
  bins <- sapply(gene_counts, assign_bin)
  
  # Tabulate how many samples fall into each bin
  freq <- table(bins)
  
  # Check if any bin has at least min_samples (5) counts
  if (any(freq >= min_samples)) {
    # In case more than one bin qualifies, choose the bin with the highest frequency
    candidate_bins <- names(freq)[freq >= min_samples]
    chosen_bin <- candidate_bins[which.max(freq[candidate_bins])]
    return(chosen_bin)
  } else {
    return(NA)  # No bin meets the criterion for this gene in this tissue
  }
}

# (4) Loop through each tissue, apply the function gene-by-gene,
# and record the assigned bin for each gene.
results_list <- list()
for (tissue in names(tissues)) {
  tissue_cols <- tissues[[tissue]]
  tissue_data <- counts2[, tissue_cols, drop = FALSE]
  
  # Apply get_gene_bin to each gene (each row)
  gene_bins <- apply(tissue_data, 1, get_gene_bin, min_samples = 5)
  
  # Create a data frame with gene names, the assigned bin, and the tissue label
  df <- data.frame(
    gene = rownames(counts2),
    bin = gene_bins,
    Tissue = tissue,
    stringsAsFactors = FALSE
  )
  results_list[[tissue]] <- df
}
combined_results <- do.call(rbind, results_list)

# (5) Summarize the number of genes per Tissue and Bin,
# keeping only genes that met the ≥5 sample criteria.
summary_df <- combined_results %>%
  filter(!is.na(bin)) %>%
  group_by(Tissue, bin) %>%
  summarise(gene_count = n(), .groups = "drop")

summary_df <- summary_df %>%
  group_by(Tissue) %>%
  mutate(percent = 100 * gene_count / sum(gene_count)) %>%
  ungroup()

# (Optional) Set factor levels for the bins to preserve the desired order in the plot
#bin_levels <- c("0", "0-50", "50-100", "100-150", "150-200", ">200")
bin_levels <- c("0", "0-50", "50-100", "100-200", "200-500", ">500")
summary_df$bin <- factor(summary_df$bin, levels = bin_levels)

#write.table(summary_df,"gene_expression_bins.tsv",quote=F,sep="\t",row.names=F,col.names=T)

plot <- ggplot(summary_df, aes(x = Tissue, y = percent, fill = bin)) +
  geom_bar(stat = "identity") +
  scale_fill_viridis_d() +  # Discrete scale for your bin categories
  labs(x = "Tissue", 
       y = "Percentage of Genes", 
       fill = "Expression bin") +
  theme_classic()+
  theme(axis.text = element_text(family="Times",size=14),
        axis.title = element_text(family="Times",size=20),
        #legend.position="none")
       legend.text=element_text(size=14,family="Times"),legend.title=element_blank())

ggsave("../figs/expression_bins_legend.pdf", plot, width = 10, height =12, units="cm",device=cairo_pdf,limitsize=F)



