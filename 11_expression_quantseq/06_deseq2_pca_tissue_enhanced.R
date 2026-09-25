# [original] local: <path>/genome_gene_exp_analysis.R
#BiocManager::install("DESeq2")
#BiocManager::install("ggfortify")
#BiocManager::install("data.frame")
#BiocManager::install("XML")
#BiocManager::install("rnaseqGene")
#BiocManager::install("gplots")
#BiocManager::install("RColorBrewer")
#BiocManager::install("limma")
#BiocManager::install("biomaRt")
#BiocManager::install("umap", update = FALSE)

# new general run
rm(list=ls()) #clears all variables
objects() # clear all objects
graphics.off() #close all figures

## load libs
lib<-c("DESeq2","ggplot2","RColorBrewer","tidyverse","ggrepel")
lapply(lib,library,character.only=T)


#### set your working directory
setwd("<path>/gene_expression_analysis/")

### King penguin analysis

# read in targets
king_targets <- read.table("king_all_tissues",h=T)

#### load raw counts
counts <- read.table("final_counts.txt", 
                     stringsAsFactors=F,sep="\t",h=T)
head(counts)

#### make gene column as row header
counts <- counts %>% column_to_rownames("Gene")

#### get the dimensions for counts and remove very lowly expressed genes
dim(counts)

## filter for genes across groups and tissues 

# Define tissue groups
tissues <- list(
  Brain = grep("^KB", colnames(counts), value=TRUE),
  Kidney = grep("^KK", colnames(counts), value=TRUE),
  Liver = grep("^KL", colnames(counts), value=TRUE),
  Muscle = grep("^KM", colnames(counts), value=TRUE),
  Skin = grep("^KS", colnames(counts), value=TRUE)
)

# Define filtering function
filter_by_tissue <- function(counts, tissues, min_samples=5, threshold=5) {
  keep_genes <- apply(counts, 1, function(gene_counts) {
    # Check for each tissue group
    expressed_in_groups <- sapply(tissues, function(samples) {
      sum(gene_counts[samples] > threshold) >= min_samples
    })
    # Keep gene if expressed in at least one tissue group
    any(expressed_in_groups)
  })
  
  # Filter the count matrix
  filtered_counts <- counts[keep_genes, ]
  
  return(filtered_counts)
}

# Apply the filtering function
filtered_counts <- filter_by_tissue(counts, tissues, min_samples=5, threshold=1)

dim(filtered_counts)

## remove everything with less than 10 counts (CPM) + present in 2 or more samples
#keep <- rowSums( counts(dds) >= X ) >= Y ## Love recommends X to be 10 and Y to be the smallest group size
keep <- rowSums((counts)) >= 1
counts2 <- counts[keep,]
dim(counts2) ## new dimensions


##### get a bar plot of library sizes 
librarySizes <- colSums(filtered_counts)

## plot using basic R
barplot(librarySizes, 
        names=names(librarySizes), 
        las=2, 
        main="Barplot of library sizes")

# remove any samples with particularly low counts

####### get box plot of distribution of samples 
logcounts <- log2(filtered_counts + 1) ### first convert the data into log values

# using basic R
# generate a color vector based on the different treatments 
statusCol <- as.numeric(factor(king_targets$Tissue)) + 1

# generate boxplots to check sample distribution
boxplot(logcounts, 
        xlab="", 
        ylab="Log2(Counts)",
        las=2,
        col=statusCol)

## check everything is nice and even - no outliers

### plot with ggplot
# make long
logcounts_long <- gather(logcounts,key="tissue",value="value",KB01:KS10)

# count each gene
# data %>% group_by(factor1, factor2) %>% summarize(count=n())

# add tissue column for colour groupings:
logcounts_long$Tissue <- c(rep("Brain",57315),rep("Kidney",57315),rep("Liver",57315),
                           rep("Muscle",57315),rep("Skin",57315))


palette=c("#096735","#aa7db1","#ec154f","#f26722","#0f0c0e")

ggplot(logcounts_long)+
  geom_boxplot(aes(x=Tissue,y=value,fill=Tissue,colour=Tissue),lwd=0.8)+
  theme_bw()+
  scale_colour_manual(values=alpha(palette,0.8))+
  scale_fill_manual(values=alpha(palette,0.5))+
  theme(axis.text.y = element_text(size=14),
        axis.text.x = element_text(size=10,angle=-45,vjust=0.6),
        axis.title.y = element_text(size=18),
        axis.title.x = element_blank(),
        legend.position = "none")+
  ylab("Log2(counts)")

## check log2 counts across tissues


###### Now the QC is finished, time for some actual analyses!

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
head(assay(vsd), 3)

vst_counts <- assay(vsd)

# Round all numeric columns to 2 decimal places
vst_counts <- round(vst_counts)

# write.table(vst_counts,"vst_normalised_KP_counts.tsv",row.names=T,col.names=T,quote=F,sep="\t")

df <- vst_counts
# Define tissue groups
tissues <- list(
  Brain = grep("^KB", colnames(df), value=TRUE),
  Kidney = grep("^KK", colnames(df), value=TRUE),
  Liver = grep("^KL", colnames(df), value=TRUE),
  Muscle = grep("^KM", colnames(df), value=TRUE),
  Skin = grep("^KS", colnames(df), value=TRUE)
)

# Calculate mean counts per tissue
mean_counts <- data.frame(
  Gene = rownames(df),
  Brain = rowMeans(df[, tissues$Brain]),
  Kidney = rowMeans(df[, tissues$Kidney]),
  Liver = rowMeans(df[, tissues$Liver]),
  Muscle = rowMeans(df[, tissues$Muscle]),
  Skin = rowMeans(df[, tissues$Skin])
)

# write.table(mean_counts,"mean_vst_normalised_KP_counts.tsv",row.names=F,col.names=T,quote=F,sep="\t")

### intersect with the bed file of positions
bed <- read.csv("gene_annotation.bed",sep="\t",h=T)

# Merge the BED file with the counts based on the Gene column
merged_data <- inner_join(bed[, c("chr", "start", "end", "Gene")], mean_counts, by="Gene")

# write.table(merged_data,"all_tissue_gene_counts.tsv",row.names=F,col.names=T,quote=F,sep="\t")

## plot PCA

plotPCA(vsd, intgroup=c("Tissue"))

## customise
pcaData <- plotPCA(vsd, intgroup=c("Tissue"), returnData=TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
#palette=c("#FF7477","#E69597","#CEB5B7","#B5D6D6","#A7BED3")
#palette2=c("#aa7db1","#ec154f","#0f0c0e","#096735","#f26722")
palette2=c("#096735","#aa7db1","#ec154f","#f26722","#0f0c0e")

# flip PC2 axis:
pcaData <- pcaData %>% mutate(PC2_flipped=ifelse(pcaData$PC2<0,abs(pcaData$PC2),0-(pcaData$PC2)))


## plot a pretty PCA of the tissues
PCA <- ggplot(pcaData, aes(PC1, PC2, color=Tissue,fill=Tissue,label=name)) +
  geom_point(size=4,shape=21,stroke=1.5) +
  # geom_text_repel() +
  xlab(paste0("PC1: ",percentVar[1],"%")) +
  ylab(paste0("PC2: ",percentVar[2],"%")) + 
  coord_fixed()+
  scale_colour_manual(values=palette2)+
  scale_fill_manual(values=alpha(palette2,0.5))+
  #scale_x_continuous(limits=c(-120,120),breaks=seq(-120,120,20))+
  #scale_y_continuous(limits=c(-90,90),breaks=seq(-80,80,20))+
  theme_classic()+
  theme(legend.position="right",
        axis.text=element_text(size=18, family="Times"),
        axis.title=element_text(size=20,family="Times"),
        legend.title=element_text(size=16,family="Times"))
        legend.text=element_text(size=14,family="Times"))

PCA

## save PCA
ggsave("../figs/PCA_geneexp_king_legend.pdf", PCA, width = 10, height = 10, units="cm",device=cairo_pdf,limitsize=F)


### perform DE analysis:

res <- DESeq(ddsObj)
head(res)
summary(res)
resultsNames(res)


#########################
######## BRAIN ##########
#########################
res_brain_vs_all = results(res,contrast=list(c("TissueBrain"),c("TissueSkin","TissueLiver","TissueKidney","TissueMuscle")),
                           listValues=c(1,-1/4))
summary(res_brain_vs_all)

## write as a dataframe for all results
res_brain <- as.data.frame(res_brain_vs_all)
## make colnames first column:
res_brain <- tibble::rownames_to_column(res_brain, "Gene")


### write a dataframe with only results at a padj of 0.05 and a logFC of ...?
res_brain_sig <- res_brain %>% dplyr::filter(padj<0.01) %>% filter (log2FoldChange > 5 | log2FoldChange < -5)


## intersect with the bed file:
merged_brain <- inner_join(bed[, c("chr", "start", "end", "Gene")], res_brain_sig, by="Gene")

## write sig results
write.table(merged_brain,"brain_sig_enhanced.tsv",row.names=F,col.names=T,quote=F,sep="\t")

##########################
######## SKIN ##########
#########################
res_skin_vs_all = results(res,contrast=list(c("TissueSkin"),c("TissueBrain","TissueLiver","TissueKidney","TissueMuscle")),
                          listValues=c(1,-1/4))

summary(res_skin_vs_all)

## write as a dataframe for all results
res_skin <- as.data.frame(res_skin_vs_all)
## make colnames first column:
res_skin <- tibble::rownames_to_column(res_skin, "Gene")


### write a dataframe with only results at a padj of 0.05 and a logFC of ...?
res_skin_sig <- res_skin %>% dplyr::filter(padj<0.01) %>% filter (log2FoldChange > 5 | log2FoldChange < -5)

## intersect with the bed file:
merged_skin <- inner_join(bed[, c("chr", "start", "end", "Gene")], res_skin_sig, by="Gene")

## write sig results
write.table(merged_skin,"skin_sig_enhanced.tsv",row.names=F,col.names=T,quote=F,sep="\t")

##########################
######## LIVER ##########
#########################
res_liver_vs_all = results(res,contrast=list(c("TissueLiver"),c("TissueSkin","TissueBrain","TissueKidney","TissueMuscle")),
                           listValues=c(1,-1/4))

summary(res_liver_vs_all)

## write as a dataframe for all results
res_liver <- as.data.frame(res_liver_vs_all)
## make colnames first column:
res_liver <- tibble::rownames_to_column(res_liver, "Gene")


### write a dataframe with only results at a padj of 0.05 and a logFC of ...?
res_liver_sig <- res_liver %>% dplyr::filter(padj<0.01) %>% filter (log2FoldChange > 5 | log2FoldChange < -5)

## intersect with the bed file:
merged_liver <- inner_join(bed[, c("chr", "start", "end", "Gene")], res_liver_sig, by="Gene")

## write sig results
write.table(merged_liver,"liver_sig_enhanced.tsv",row.names=F,col.names=T,quote=F,sep="\t")

##########################
######## KIDNEY #########
#########################
res_kidney_vs_all = results(res,contrast=list(c("TissueKidney"),c("TissueSkin","TissueLiver","TissueBrain","TissueMuscle")),
                            listValues=c(1,-1/4))

summary(res_kidney_vs_all)

## write as a dataframe for all results
res_kidney <- as.data.frame(res_kidney_vs_all)
## make colnames first column:
res_kidney <- tibble::rownames_to_column(res_kidney, "Gene")

### write a dataframe with only results at a padj of 0.05 and a logFC of ...?
res_kidney_sig <- res_kidney %>% dplyr::filter(padj<0.01) %>% filter (log2FoldChange > 5 | log2FoldChange < -5)

## intersect with the bed file:
merged_kidney <- inner_join(bed[, c("chr", "start", "end", "Gene")], res_kidney_sig, by="Gene")

## write sig results
write.table(merged_kidney,"kidney_sig_enhanced.tsv",row.names=F,col.names=T,quote=F,sep="\t")

##########################
######## MUSCLE #########
######################### 
res_muscle_vs_all = results(res,contrast=list(c("TissueMuscle"),c("TissueSkin","TissueLiver","TissueKidney","TissueBrain")),
                            listValues=c(1,-1/4))

summary(res_muscle_vs_all)

## write as a dataframe for all results
res_muscle <- as.data.frame(res_muscle_vs_all)
## make colnames first column:
res_muscle <- tibble::rownames_to_column(res_muscle, "Gene")

### write a dataframe with only results at a padj of 0.05 and a logFC of ...?
res_muscle_sig <- res_muscle %>% dplyr::filter(padj<0.01) %>% filter (log2FoldChange > 5 | log2FoldChange < -5)

## intersect with the bed file:
merged_muscle <- inner_join(bed[, c("chr", "start", "end", "Gene")], res_muscle_sig, by="Gene")

## write sig results
write.table(merged_muscle,"muscle_sig_enhanced.tsv",row.names=F,col.names=T,quote=F,sep="\t")

min(merged_skin$log2FoldChange)

setwd("<path>/circos_gene_expression/")

liver <- read.delim("liver_sig0.05.fc5.txt",h=F)
head(liver)
min(liver$V4)
max(liver$V4)

liver[liver$V4 == min(liver$V4), ]



