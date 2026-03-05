#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(yaml)
  library(here)
})

in_path <- here::here("data", "raw", "sleep_memory_2x2.csv")
out_yml <- here::here("outputs", "results", "anova.yml")
out_plot <- here::here("outputs", "figures", "interaction.png")

df <- readr::read_csv(in_path, show_col_types = FALSE) %>%
  mutate(
    sleep = factor(sleep, levels = c("Wake", "Sleep")),
    cue = factor(cue, levels = c("Control", "TMR"))
  )

# Descriptives
desc <- df %>%
  group_by(sleep, cue) %>%
  summarise(
    n = n(),
    mean = mean(recall_score),
    sd = sd(recall_score),
    .groups = "drop"
  )

# 2x2 between-subjects ANOVA
fit <- aov(recall_score ~ sleep * cue, data = df)
aov_tab <- summary(fit)[[1]]

# Extract sums of squares
ss_sleep <- unname(aov_tab["sleep", "Sum Sq"])
ss_cue <- unname(aov_tab["cue", "Sum Sq"])
ss_int <- unname(aov_tab["sleep:cue", "Sum Sq"])
ss_err <- unname(aov_tab["Residuals", "Sum Sq"])

df_sleep <- unname(aov_tab["sleep", "Df"])
df_cue <- unname(aov_tab["cue", "Df"])
df_int <- unname(aov_tab["sleep:cue", "Df"])
df_err <- unname(aov_tab["Residuals", "Df"])

f_sleep <- unname(aov_tab["sleep", "F value"])
f_cue <- unname(aov_tab["cue", "F value"])
f_int <- unname(aov_tab["sleep:cue", "F value"])

p_sleep <- unname(aov_tab["sleep", "Pr(>F)"])
p_cue <- unname(aov_tab["cue", "Pr(>F)"])
p_int <- unname(aov_tab["sleep:cue", "Pr(>F)"])

# Partial eta squared for between-subjects ANOVA
pes_sleep <- ss_sleep / (ss_sleep + ss_err)
pes_cue <- ss_cue / (ss_cue + ss_err)
pes_int <- ss_int / (ss_int + ss_err)

results <- list(
  dataset = list(
    file = "data/raw/sleep_memory_2x2.csv",
    n = nrow(df),
    dv = "recall_score",
    factors = list(
      sleep = levels(df$sleep),
      cue = levels(df$cue)
    )
  ),
  descriptives = desc %>%
    mutate(
      mean = round(mean, 2),
      sd = round(sd, 2)
    ) %>%
    arrange(sleep, cue) %>%
    split(seq_len(nrow(.))) %>%
    lapply(as.list),
  anova = list(
    sleep = list(df1 = df_sleep, df2 = df_err, f = f_sleep, p = p_sleep, partial_eta_sq = pes_sleep),
    cue = list(df1 = df_cue, df2 = df_err, f = f_cue, p = p_cue, partial_eta_sq = pes_cue),
    interaction = list(df1 = df_int, df2 = df_err, f = f_int, p = p_int, partial_eta_sq = pes_int)
  )
)

dir.create(dirname(out_yml), recursive = TRUE, showWarnings = FALSE)
yaml::write_yaml(results, out_yml)

# Interaction plot
plot_df <- desc %>%
  mutate(
    se = sd / sqrt(n)
  )

p <- ggplot(plot_df, aes(x = cue, y = mean, group = sleep, linetype = sleep)) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.1) +
  labs(
    x = "Cue condition",
    y = "Mean recall score",
    linetype = "Sleep condition",
    title = "Recall performance by sleep and cue condition"
  ) +
  theme_minimal(base_size = 12)

dir.create(dirname(out_plot), recursive = TRUE, showWarnings = FALSE)
ggsave(out_plot, p, width = 7, height = 4.5, dpi = 150)

message("Wrote: ", out_yml)
message("Wrote: ", out_plot)
