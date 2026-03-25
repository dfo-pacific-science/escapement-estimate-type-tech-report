# Escapement Estimate Type Technical Report

This repository contains the csasdown source for the **Updated Escapement Estimate Type Classification Guidance** technical report.

The workflow is **report-first** and keeps the final rendered artifacts in the **repo root**:

- `techreport.docx`
- `techreport.pdf`

`_book/` remains the intermediate csasdown/bookdown render directory.

## Open in RStudio

1. Open `escapement-estimate-type-tech-report.Rproj`
2. Install the required packages in the R console:

```r
install.packages(c("bookdown", "kableExtra", "remotes"))
remotes::install_github("pbs-assess/csasdown")
```

## Build the report locally

### Render the technical report DOCX + PDF to repo root

From the repo root, run:

```bash
Rscript render-techreport.R
```

This wrapper script:

1. runs `csasdown::render()`
2. copies the rendered DOCX from `_book/techreport.docx` to `./techreport.docx`
3. converts that root DOCX to `./techreport.pdf` with LibreOffice

The RStudio **Knit** button is also wired to the same root-artifact flow.

### Where the rendered files go

Final tracked artifacts:

- `techreport.docx`
- `techreport.pdf`

Intermediate render output:

- `_book/techreport.docx`

## LibreOffice requirement for PDF output

This repo still creates the PDF as a **DOCX -> PDF conversion step** after the csasdown DOCX render.

If LibreOffice is installed, the helper script will use either:

- `soffice` on your `PATH`, or
- `/Applications/LibreOffice.app/Contents/MacOS/soffice` on macOS

If LibreOffice is missing, the DOCX render will still complete, but PDF creation will fail with a direct error message.

## GitHub distribution

This repo no longer relies on GitHub Pages for a live PDF site.

The intended downloadable artifacts are the root-level tracked files:

- `techreport.docx`
- `techreport.pdf`

## Optional inputs (NuSEDS data dictionary)

Some tables auto-populate if this file is present:

- `docs/context/Data_Dictionary_NuSEDS_EN.csv`

If it is absent, the report still renders, but those tables show placeholder text instead of populated definitions/crosswalk values.

## Cross-repo dependencies

The narrative in this report references implementation artifacts maintained in:

- `https://github.com/dfo-pacific-science/smn-escapement-estimates-toolkit`

Current alignment is to toolkit release `v0.1.0` (classification key YAML, classification engine, Shiny app flow, and path tests).

## Citation

A machine-readable citation file is provided as `CITATION.cff`.
