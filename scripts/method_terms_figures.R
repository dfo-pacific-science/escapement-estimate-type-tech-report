library(readr)
library(dplyr)
library(stringr)
library(ggplot2)
library(tidyr)
library(scales)

input_path <- "/Users/alan/.openclaw/workspace/tmp/est-type-context/all_area_sen_survey_method.csv"
out_dir <- "/Users/alan/.openclaw/workspace/code/escapement-estimate-type-tech-report/docs/figures"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

raw <- read_csv(input_path, show_col_types = FALSE)

clean_method <- function(x) {
  x <- as.character(x)
  x <- str_trim(x)
  x <- str_replace_all(x, "\\r", "")
  x <- str_replace_all(x, "\\n", " ")
  str_replace_all(x, "\\s+", " ")
}

split_terms <- function(x) {
  x <- as.character(x)
  x <- x[!is.na(x)]
  out <- unlist(str_split(x, "[;,/]"))
  out <- str_trim(out)
  out <- na_if(out, "")
  out <- na_if(out, "NA")
  out <- out[!is.na(out)]
  out
}

raw <- raw %>%
  mutate(ANALYSIS_YR = as.integer(ANALYSIS_YR)) %>%
  filter(!is.na(ANALYSIS_YR), ANALYSIS_YR >= 1990, ANALYSIS_YR <= 2025)

# Build long tables of method terms by year.
term_long <- function(field_name, type_label) {
  raw %>%
    select(year = ANALYSIS_YR, method_raw = all_of(field_name)) %>%
    filter(!is.na(method_raw), method_raw != "") %>%
    mutate(type = type_label) %>%
    rowwise() %>%
    mutate(method = list(clean_method(split_terms(method_raw)))) %>%
    unnest(cols = c(method)) %>%
    ungroup() %>%
    filter(!is.na(method), method != "")
}

enum_long <- term_long("ENUMERATION_METHODS", "Enumeration")
est_long <- term_long("ESTIMATE_METHOD", "Estimate")

# Figure 1: Make the "unique terms" story interpretable by also showing record volume.
records_by_year <- bind_rows(
  raw %>% filter(!is.na(ENUMERATION_METHODS), ENUMERATION_METHODS != "") %>% count(year = ANALYSIS_YR) %>% mutate(type = "Enumeration", metric = "Records with method", value = n) %>% select(year, type, metric, value),
  raw %>% filter(!is.na(ESTIMATE_METHOD), ESTIMATE_METHOD != "") %>% count(year = ANALYSIS_YR) %>% mutate(type = "Estimate", metric = "Records with method", value = n) %>% select(year, type, metric, value)
)

unique_by_year <- bind_rows(
  enum_long %>% group_by(year, type) %>% summarise(value = n_distinct(method), .groups = "drop") %>% mutate(metric = "Unique method terms") %>% select(year, type, metric, value),
  est_long %>% group_by(year, type) %>% summarise(value = n_distinct(method), .groups = "drop") %>% mutate(metric = "Unique method terms") %>% select(year, type, metric, value)
)

fig1_df <- bind_rows(records_by_year, unique_by_year)

p1 <- ggplot(fig1_df, aes(x = year, y = value)) +
  geom_line(linewidth = 0.9, color = "#2C7FB8") +
  geom_point(size = 1.5, color = "#2C7FB8") +
  facet_grid(metric ~ type, scales = "free_y") +
  scale_x_continuous(breaks = seq(1990, 2025, 5)) +
  labs(
    title = "Method-field completeness and term diversity by analysis year",
    x = "Year",
    y = NULL
  ) +
  theme_minimal(base_size = 10)

ggsave(file.path(out_dir, "appendix_e_figure1_unique_terms_by_year.png"), p1, width = 7.5, height = 5.6, dpi = 180)

# Figure 2: Top terms. Use free x-scales so each panel is readable.
enum_top <- enum_long %>% count(method, sort = TRUE) %>% slice_max(n, n = 20) %>% mutate(type = "Enumeration")
est_top <- est_long %>% count(method, sort = TRUE) %>% slice_max(n, n = 20) %>% mutate(type = "Estimate")

top_terms <- bind_rows(enum_top, est_top)

# Reorder within each panel by count (simple and stable).
top_terms <- top_terms %>%
  group_by(type) %>%
  arrange(n, .by_group = TRUE) %>%
  mutate(method = factor(method, levels = unique(method))) %>%
  ungroup()

p2 <- ggplot(top_terms, aes(x = n, y = method, fill = type)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~type, scales = "free") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "Top method terms in NuSEDS SEN method fields",
    x = "Record count",
    y = "Method term"
  ) +
  theme_minimal(base_size = 10)

ggsave(file.path(out_dir, "appendix_e_figure2_top_terms_faceted.png"), p2, width = 7.5, height = 7, dpi = 180)
