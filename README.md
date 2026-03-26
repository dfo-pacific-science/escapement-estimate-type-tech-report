# Escapement Estimate Type Technical Report

This repository contains the `csasdown` source for the **Updated Escapement Estimate Type Classification Guidance** technical report.

The simplest local workflow is:

- knit the report in RStudio, or
- run `Rscript render-techreport.R`

Both routes render the Word report to `_book/techreport.docx`.

## Open in RStudio

1. Open `escapement-estimate-type-tech-report.Rproj`.
2. Install the required packages in the R console:

```r
install.packages(c("bookdown", "kableExtra", "remotes"))
remotes::install_github("pbs-assess/csasdown")
```

## Build the report

### RStudio

Use the **Knit** button in RStudio.

### Command line

From the repo root, run:

```bash
Rscript render-techreport.R
```

## Output files

Primary render output:

- `_book/techreport.docx`

## PDF use

This repo no longer creates PDFs. If a PDF is needed, open `_book/techreport.docx` in Word and export or save as PDF there.

## Notes

The report abstract is maintained in the YAML of `index.Rmd` and is also emitted into the report body so it appears reliably in the rendered DOCX.

Some tables auto-populate if `docs/context/Data_Dictionary_NuSEDS_EN.csv` is present. If it is absent, the report still renders, but those tables show placeholder text instead of populated definitions/crosswalk values.

The narrative in this report references implementation artifacts maintained in `https://github.com/dfo-pacific-science/smn-escapement-estimates-toolkit`.

A machine-readable citation file is provided as `CITATION.cff`.
