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

family_map <- c(
  "Bank Walk" = "V",
  "Stream Walk" = "V",
  "Walk" = "V",
  "Boat" = "V",
  "Float" = "V",
  "Snorkel" = "V",
  "Snorkel Swim" = "V",
  "Strip Counts" = "V",
  "Spot Checks" = "V",
  "Dead Pitch" = "V",
  "Peak Live and Dead Count" = "V",
  "Fence" = "FS",
  "Electronic Counters" = "FS",
  "Enumeration By Hatchery" = "FS",
  "Broodstock Removal" = "FS",
  "Fixed Wing Aircraft" = "A",
  "Helicopter" = "A",
  "Hydroacoustic Station" = "S",
  "Trap" = "T",
  "Redd Counts" = "R",
  "Electroshocking" = "P",
  "Tag Recovery" = "M",
  "Based on Angling Catch" = "P",
  "Fixed Site Census" = "FS",
  "Resistivity Counter" = "FS",
  "Video Counter" = "FS",
  "Sonar-ARIS" = "S",
  "Sonar-DIDSON" = "S",
  "Mark & Recapture: Petersen" = "M",
  "Mark & Recapture: Jolly-Seber" = "M",
  "Mark & Recapture: Bayesian" = "M",
  "Mark & Recapture: Open Model" = "M",
  "Area Under the Curve" = "V",
  "Peak Live + Dead" = "V",
  "Peak Live + Cumulative Dead" = "V",
  "(Peak Live+Cum Dead)*Expansion" = "V",
  "Peak Live * Expansion" = "V",
  "Redd Count" = "R",
  "Cumulative Cpue" = "P",
  "Cumulative New" = "V"
)

map_family <- function(values) {
  fam <- rep("Unmapped", length(values))
  for (i in seq_along(values)) {
    v <- values[i]
    if (is.na(v) || v == "") {
      next
    }
    hit <- family_map[tolower(names(family_map)) == tolower(v)]
    if (length(hit) > 0 && !is.na(hit[[1]])) {
      fam[i] <- hit[[1]]
    }
  }
  fam
}

raw <- raw %>%
  mutate(ANALYSIS_YR = as.integer(ANALYSIS_YR)) %>%
  filter(!is.na(ANALYSIS_YR), ANALYSIS_YR >= 1990, ANALYSIS_YR <= 2025)

# Enumeraton long format
enum_long <- raw %>%
  select(year = ANALYSIS_YR, method_raw = ENUMERATION_METHODS) %>%
  filter(!is.na(method_raw), method_raw != "") %>%
  rowwise() %>%
  mutate(method = list(clean_method(split_terms(method_raw)))) %>%
  unnest(cols = c(method)) %>%
  filter(!is.na(method), method != "") %>%
  mutate(
    method = clean_method(method),
    method_family = map_family(method),
    type = "Enumeration"
  )

# Estimate long format
est_long <- raw %>%
  select(year = ANALYSIS_YR, method_raw = ESTIMATE_METHOD) %>%
  filter(!is.na(method_raw), method_raw != "") %>%
  rowwise() %>%
  mutate(method = list(clean_method(split_terms(method_raw)))) %>%
  unnest(cols = c(method)) %>%
  filter(!is.na(method), method != "") %>%
  mutate(
    method = clean_method(method),
    method_family = map_family(method),
    type = "Estimate"
  )

# Figure 1
term_unique <- bind_rows(
  enum_long %>% group_by(year, type) %>% summarise(unique_terms = n_distinct(method), .groups = "drop"),
  est_long %>% group_by(year, type) %>% summarise(unique_terms = n_distinct(method), .groups = "drop")
)

p1 <- ggplot(term_unique, aes(x = year, y = unique_terms, color = type)) +
  geom_line(linewidth = 1) +
  geom_point(size = 1.6) +
  scale_x_continuous(breaks = seq(1990, 2025, 5)) +
  labs(
    title = "Unique method terms by analysis year",
    x = "Year",
    y = "Number of unique terms",
    color = "Field"
  ) +
  theme_minimal(base_size = 11)

ggsave(file.path(out_dir, "appendix_e_figure1_unique_terms_by_year.png"), p1, width = 7, height = 4, dpi = 180)

# Figure 2
enum_top <- enum_long %>% count(method, sort = TRUE) %>% top_n(20, n) %>% mutate(type = "Enumeration")
est_top <- est_long %>% count(method, sort = TRUE) %>% top_n(20, n) %>% mutate(type = "Estimate")

top_terms <- bind_rows(enum_top, est_top)
top_terms$method <- reorder(top_terms$method, top_terms$n)

p2 <- ggplot(top_terms, aes(x = n, y = method, fill = type)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~type, scales = "free_y") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "Top method terms in NuSEDS SEN method fields",
    x = "Record count",
    y = "Method term"
  ) +
  theme_minimal(base_size = 10)

ggsave(file.path(out_dir, "appendix_e_figure2_top_terms_faceted.png"), p2, width = 7.5, height = 7, dpi = 180)

# Figure 3
family_trends <- bind_rows(enum_long, est_long) %>%
  mutate(method_family = factor(method_family, levels = c("FS", "S", "A", "T", "R", "P", "M", "V", "Unmapped"))) %>%
  count(year, type, method_family, name = "n") %>%
  group_by(year, type) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

p3 <- ggplot(family_trends, aes(x = year, y = prop, fill = method_family)) +
  geom_area(position = "stack", alpha = 0.9, color = "white", linewidth = 0.15) +
  facet_wrap(~type, ncol = 1) +
  scale_x_continuous(breaks = seq(1990, 2025, 5)) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title = "Method-family composition over time",
    x = "Year",
    y = "Share of method records",
    fill = "Method family"
  ) +
  theme_minimal(base_size = 11)

ggsave(file.path(out_dir, "appendix_e_figure3_family_share_over_time.png"), p3, width = 7.5, height = 6, dpi = 180)

# Figure 4
unmapped <- bind_rows(enum_long, est_long) %>%
  count(year, type, method_family, name = "n") %>%
  filter(method_family == "Unmapped") %>%
  complete(year = full_seq(min(raw$ANALYSIS_YR):max(raw$ANALYSIS_YR), 1), type, fill = list(n = 0))

p4 <- ggplot(unmapped, aes(x = year, y = n, color = type)) +
  geom_line(linewidth = 1) +
  geom_point(size = 1.4) +
  scale_x_continuous(breaks = seq(1990, 2025, 5)) +
  labs(
    title = "Unmapped method terms by year",
    x = "Year",
    y = "Unmapped record count",
    color = "Field"
  ) +
  theme_minimal(base_size = 11)

ggsave(file.path(out_dir, "appendix_e_figure4_unmapped_by_year.png"), p4, width = 7, height = 4, dpi = 180)

# Figure 5
coverage <- raw %>%
  mutate(
    has_enum = !is.na(ENUMERATION_METHODS) & ENUMERATION_METHODS != "",
    has_est = !is.na(ESTIMATE_METHOD) & ESTIMATE_METHOD != "",
    status = case_when(
      has_enum & has_est ~ "Both",
      has_enum & !has_est ~ "Enumeration only",
      !has_enum & has_est ~ "Estimate only",
      TRUE ~ "Neither"
    )
  ) %>%
  filter(status != "Neither") %>%
  count(ANALYSIS_YR, status, name = "n")

p5 <- ggplot(coverage, aes(x = ANALYSIS_YR, y = n, fill = status)) +
  geom_col(position = "stack") +
  scale_x_continuous(breaks = seq(1990, 2025, 5)) +
  labs(
    title = "Method-field coverage by year",
    x = "Year",
    y = "Record count",
    fill = "Method-field status"
  ) +
  theme_minimal(base_size = 11)

ggsave(file.path(out_dir, "appendix_e_figure5_method_field_coverage.png"), p5, width = 7.5, height = 4, dpi = 180)
