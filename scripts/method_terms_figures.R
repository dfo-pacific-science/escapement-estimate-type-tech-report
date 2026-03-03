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

# Figure: top terms (top 10) in each method field.
enum_top <- enum_long %>% count(method, sort = TRUE) %>% slice_max(n, n = 10) %>% mutate(type = "Enumeration")
est_top <- est_long %>% count(method, sort = TRUE) %>% slice_max(n, n = 10) %>% mutate(type = "Estimate")

top_terms <- bind_rows(enum_top, est_top)

# Reorder within each panel by count (stable and readable).
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
    x = "Record count",
    y = "Method term"
  ) +
  theme_minimal(base_size = 9)

ggsave(
  file.path(out_dir, "appendix_e_figure2_top_terms_faceted.png"),
  p2,
  width = 6.0,
  height = 5.0,
  dpi = 180
)
