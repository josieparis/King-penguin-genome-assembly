# [original] local: <path>/plot_telomeric_repeats.R
# new general run
rm(list=ls()) #clears all variables
objects() # clear all objects
graphics.off() #close all figures

## load libs
lib<-c("ggplot2", "grid", "gridExtra","stringr", "data.table", "plyr", "cowplot", "dplyr", "tidyverse")
lapply(lib,library,character.only=T)

setwd("<path>/Genome_files/")

dd <- read.csv("telomeres/KP_search_100kb_telomeric_repeat_windows.csv",h=T)
head(dd)
data <- dd

data <- data %>%
  filter(grepl("^SUPER_", id)) %>%
  mutate(total_repeats = forward_repeat_number + reverse_repeat_number) %>%
  group_by(id) %>% 
  # Subtract the minimum value for each chromosome from each total_repeats value
  mutate(total_repeats_norm = total_repeats - min(total_repeats)) %>% 
  ungroup()

data$id <- factor(data$id, levels = unique(data$id))

# data <- data %>% filter(id == "SUPER_1")

# Plot total repeats vs. window position and facet by chromosome
telomeres <- ggplot(data, aes(x = window, y = total_repeats_norm)) +
 # geom_line(aes(group = 1)) +
  geom_point(size=0.1) +
  facet_wrap(~ id, scales = "free_x") +
  labs(
    x = "Window Position",
    y = "Total Telomeric Repeats",
  ) +
  theme_bw()+
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        panel.grid = element_blank(),
        axis.ticks = element_blank())


ggsave("../figs/telomeres.pdf", telomeres, width = 15, height = 15, units="cm",device=cairo_pdf,limitsize=F)







