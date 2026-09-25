# [original] local: <path>/generate_circos_legends.R
rm(list=ls()) #clears all variables
objects() # clear all objects
graphics.off() #close all figures

lib<-c("RColorBrewer","ggplot2","RColorBrewer","tidyverse","ggrepel","reshape2")
lapply(lib,library,character.only=T)

setwd("<path>/circos_plot/")

# Define color palette
palette_colors <- colorRampPalette(brewer.pal(9, "PuRd"))(13)


# Create a fake dataframe
set.seed(123)
df <- data.frame(
  Row = 1:10,  # Add row numbers for proper plotting
  Var1 = runif(10, 0, 1),
  Var2 = runif(10, 0, 1),
  Var3 = runif(10, 0, 1)
)

# Reshape the data into long format for ggplot
df_melt <- melt(df, id.vars = "Row")  # Use Row as an identifier

gene_legend <- ggplot(df_melt, aes(x = variable, y = as.factor(Row), fill = value)) +
  geom_tile() +
  scale_fill_gradientn(colors = palette_colors, 
                       limits = c(0, 1),
                       breaks = c(0, 0.5, 1),
                       labels = c("0", "0.5","1")) + 
  theme_minimal() +
  labs(x = "Variable", y = "Row", fill = "Value")

ggsave("gene_legend.pdf", gene_legend, width = 20, height = 20, units="cm",device=cairo_pdf,limitsize=F)


# Generate 13 colors from the YlOrRd palette
palette_colors <- colorRampPalette(brewer.pal(9, "YlOrRd"))(13)

repeat_legend <- ggplot(df_melt, aes(x = variable, y = as.factor(Row), fill = value)) +
  geom_tile() +
  scale_fill_gradientn(colors = palette_colors, 
                       limits = c(0, 1),
                       breaks = c(0, 0.5, 1),
                       labels = c("0", "0.5", "1")) + 
  theme_minimal() +
  labs(x = "Variable", y = "Row", fill = "Value")

ggsave("repeat_legend.pdf", repeat_legend, width = 20, height = 20, units="cm",device=cairo_pdf,limitsize=F)








