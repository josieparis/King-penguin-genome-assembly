#!/usr/bin/env Rscript
# [original] local: <path>/plot_mito_duplication.R
# Supplementary figure: HiFi read support for the tandem duplication in the
# king penguin mitogenome (PZ518787.1, 20,520 bp).
#
# Drawn directly from the two tables that accompany it, so figure and tables
# cannot disagree:
#   depth_per_base.tsv    per-base HiFi depth (top panel)
#   read_alignments.tsv   one row per read, folded coordinates (bottom panel)
#
# Run from the folder containing those files:
#   Rscript plot_mito_duplication.R
# Outputs: SuppFig_mito_duplication.pdf and SuppFig_mito_duplication.png

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(readr)
  library(patchwork)
  library(grid)
})

# ---- locate input files ------------------------------------------------------
args <- commandArgs(trailingOnly = FALSE)
script_file <- sub("^--file=", "", args[grepl("^--file=", args)])
dir <- if (length(script_file)) dirname(normalizePath(script_file)) else getwd()

depth <- read_tsv(file.path(dir, "depth_per_base.tsv"), show_col_types = FALSE)
reads <- read_tsv(file.path(dir, "read_alignments.tsv"), show_col_types = FALSE)

# ---- genome landmarks (see region_depth_summary.tsv) -------------------------
genome_len  <- max(depth$position)          # 20,520
single_end  <- 14804                        # trnF-CYTB single-copy region: 1-14,804
copy1       <- c(14805, 17967)              # duplicated block, copy 1
copy2       <- c(17968, genome_len)         # duplicated block, copy 2
junction1   <- single_end + 0.5             # CYTB / copy 1
junction2   <- copy1[2] + 0.5               # copy 1 / copy 2

mean_single <- mean(depth$depth[depth$position <= single_end])   # 28.4x

# ---- colours (sampled from the reference figure) ----------------------------
col_depth   <- "#92aec6"
col_depth_l <- "#839cb1"
col_trav    <- "#a0717b"   # traverses the entire duplicated region
col_span    <- "#d1a1a5"   # spans the copy 1 / copy 2 junction only
col_other   <- "#d6d9dd"   # other reads
col_copy1   <- "#f6ecec"   # shading, copy 1
col_copy2   <- "#edf2ec"   # shading, copy 2
col_lab1    <- "#a0717b"
col_lab2    <- "#7f9d78"
col_axis    <- "grey25"
col_dash    <- "grey35"

# ---- read panel data ---------------------------------------------------------
reads <- reads %>%
  rename(start = `Alignment start`, end = `Alignment end`,
         crosses = `Crosses sequence origin`,
         spans12 = `Spans copy1/copy2 junction (>=1 kb flanks)`) %>%
  arrange(start) %>%
  mutate(row = n() - row_number() + 1,       # first read on the top row
         class = case_when(
           Category == "traverses entire duplicated region" ~ "trav",
           Category == "spans copy1/copy2 junction"         ~ "span",
           TRUE                                             ~ "other"),
         class = factor(class, levels = c("trav", "span", "other")))

n_reads <- nrow(reads)
n_trav  <- sum(reads$class == "trav")
n_span  <- sum(reads$spans12 == "yes")       # includes the traversing reads

# reads crossing the origin are drawn as two segments on the same row
segs <- bind_rows(
  reads %>% filter(crosses == "no")  %>% transmute(row, class, x0 = start, x1 = end),
  reads %>% filter(crosses == "yes") %>% transmute(row, class, x0 = start, x1 = genome_len),
  reads %>% filter(crosses == "yes") %>% transmute(row, class, x0 = 1,     x1 = end)
)
bar_h <- 0.41                                # half-height of a read bar (rows are 1 apart)

# legend key: a short, wide bar like the reads themselves
draw_key_bar <- function(data, params, size) {
  rectGrob(width = unit(1, "npc"), height = unit(0.42, "npc"),
           gp = gpar(col = NA, fill = data$fill))
}

# ---- shared pieces -----------------------------------------------------------
x_scale <- function() {
  scale_x_continuous(
    limits = c(0, genome_len),
    breaks = seq(0, 20000, 2000),
    labels = function(x) ifelse(x == 0, "0", paste0(x / 1000, " kb")),
    expand = c(0, 0))
}

shading <- list(
  annotate("rect", xmin = junction1, xmax = junction2, ymin = -Inf, ymax = Inf, fill = col_copy1),
  annotate("rect", xmin = junction2, xmax = Inf,       ymin = -Inf, ymax = Inf, fill = col_copy2)
)
junction_lines <- geom_vline(xintercept = c(junction1, junction2),
                             colour = col_dash, linetype = "32", linewidth = 0.35)

base_theme <- theme_classic(base_size = 9) +
  theme(
    axis.line        = element_line(colour = col_axis, linewidth = 0.35),
    axis.ticks       = element_line(colour = col_axis, linewidth = 0.35),
    axis.ticks.length = unit(2, "pt"),
    axis.text        = element_text(colour = "grey30", size = 8),
    axis.title       = element_text(colour = "grey15", size = 9.5),
    plot.margin      = margin(4, 6, 2, 4)
  )

# ---- top panel: depth --------------------------------------------------------
p_depth <- ggplot(depth, aes(position, depth)) +
  shading +
  geom_area(fill = col_depth, colour = col_depth_l, linewidth = 0.25,
            outline.type = "upper") +
  geom_hline(yintercept = mean_single, colour = col_dash,
             linetype = "32", linewidth = 0.35) +
  junction_lines +
  annotate("text", x = mean(copy1), y = 41.5, label = "copy 1",
           colour = col_lab1, size = 3.1) +
  annotate("text", x = mean(copy2), y = 41.5, label = "copy 2",
           colour = col_lab2, size = 3.1) +
  x_scale() +
  scale_y_continuous(limits = c(0, 46), breaks = seq(0, 40, 10),
                     expand = c(0, 0)) +
  labs(y = "Depth (×)", x = NULL) +
  base_theme +
  theme(axis.text.x = element_blank(),
        plot.margin = margin(4, 6, 6, 4))

# ---- bottom panel: reads -----------------------------------------------------
p_reads <- ggplot(segs) +
  shading +
  geom_rect(aes(xmin = x0, xmax = x1, ymin = row - bar_h, ymax = row + bar_h,
                fill = class), key_glyph = draw_key_bar) +
  junction_lines +
  scale_fill_manual(
    values = c(trav = col_trav, span = col_span, other = col_other),
    labels = c(
      trav  = sprintf("traverses the entire duplicated region (%d)", n_trav),
      span  = sprintf("spans the copy 1 / copy 2 junction (%d)", n_span),
      other = "other reads"),
    name = NULL) +
  x_scale() +
  scale_y_continuous(limits = c(0, n_reads + 1), expand = c(0, 0)) +
  labs(x = "Position on mitogenome (bp)",
       y = sprintf("HiFi reads (n = %d)", n_reads)) +
  base_theme +
  theme(
    axis.line.y   = element_blank(),
    axis.text.y   = element_blank(),
    axis.ticks.y  = element_blank(),
    legend.position   = "bottom",
    legend.text       = element_text(size = 8, colour = "grey20"),
    legend.key.width  = unit(0.6, "cm"),
    legend.key.height = unit(0.32, "cm"),
    legend.key.spacing.x = unit(0.7, "cm"),
    legend.margin     = margin(2, 0, 0, 0)
  )

# ---- assemble and save -------------------------------------------------------
fig <- p_depth / p_reads + plot_layout(heights = c(1, 3.1))

out <- file.path(dir, "SuppFig_mito_duplication")
ggsave(paste0(out, ".png"), fig, width = 7, height = 5.4, units = "in",
       dpi = 300, device = ragg::agg_png, bg = "white")
ggsave(paste0(out, ".pdf"), fig, width = 7, height = 5.4, units = "in",
       device = cairo_pdf, bg = "white")
cat("wrote", paste0(out, c(".png", ".pdf")), sep = "\n")
