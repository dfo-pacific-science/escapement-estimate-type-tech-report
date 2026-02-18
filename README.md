# Escapement Estimate Type Technical Report (Bookdown)

This repository contains the Bookdown source for the **Updated Escapement Estimate Type Classification Guidance** technical report.

## Build locally

From the repo root in R:

```r
# Install/report dependencies (csasdown is GitHub-only)
install.packages(c("bookdown", "kableExtra", "remotes"))
remotes::install_github("pbs-assess/csasdown")

# HTML (for website / GitHub Pages)
bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook")

# PDF (CSAS tech report format)
bookdown::render_book(
  "index.Rmd",
  output_format = "csasdown::techreport_pdf"
)
```

- **HTML output**: `_book/`
- **PDF output**: written to `_book/` and/or the repo root depending on `csasdown` settings and LaTeX.

## GitHub Pages

This repo is set up to deploy the Bookdown HTML site to **GitHub Pages via GitHub Actions**.

- The workflow builds the site into `_book/` and publishes it using the GitHub Pages “Actions” source.

## Optional inputs (NuSEDS data dictionary)

Some tables will auto-populate if the NuSEDS data dictionary CSV is present at:

- `docs/context/Data_Dictionary_NuSEDS_EN.csv`

If the file is absent, the report will still render, but those tables will show a placeholder note instead of definitions/crosswalk values.

## Cross-repo dependencies

The narrative in this report references implementation artifacts maintained in:

- `https://github.com/dfo-pacific-science/smn-escapement-estimates-toolkit`

Current draft alignment is to toolkit commit `8eda70f` (classification key YAML, classification engine, Shiny app flow, and path tests).

## Citation

A machine-readable citation file is provided as `CITATION.cff`.

## Lightweight adoption tracking

A low-effort monthly tracking template is available at `docs/usage-metrics.md`.

