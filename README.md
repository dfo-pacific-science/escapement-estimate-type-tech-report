# Escapement Estimate Type Technical Report

This repository contains the csasdown source for the **Updated Escapement Estimate Type Classification Guidance** technical report.

The workflow is now **report-first** and uses **`csasdown` directly**.

## Open in RStudio

1. Open `escapement-estimate-type-tech-report.Rproj`
2. Install the required packages in the R console:

```r
install.packages(c("bookdown", "kableExtra", "remotes"))
remotes::install_github("pbs-assess/csasdown")
```

## Build the report locally

### Render the technical report DOCX

From the R console in RStudio:

```r
csasdown::render()
```

This repo’s `index.Rmd` already uses the `csasdown` knit hook, so the RStudio render/knit flow also goes through `csasdown::render()`.

### Where the rendered files go

The main rendered report file is:

- `_book/techreport.docx`

That is the primary local artifact produced by `csasdown`.

## Create a local PDF from RStudio

On this install, `csasdown` provides `techreport_docx`, but not a `techreport_pdf` output format. So local PDF creation is still a **DOCX -> PDF conversion step** after render.

If LibreOffice is installed, you can run this from the R console in RStudio:

```r
soffice_bin <- Sys.which("soffice")
if (!nzchar(soffice_bin) && file.exists("/Applications/LibreOffice.app/Contents/MacOS/soffice")) {
  soffice_bin <- "/Applications/LibreOffice.app/Contents/MacOS/soffice"
}

system2(
  soffice_bin,
  c(
    "--headless",
    "--convert-to", "pdf",
    "--outdir", "_book",
    "_book/techreport.docx"
  )
)
```

Expected PDF output:

- `_book/techreport.pdf`

If `soffice` is not installed or not on your path, install LibreOffice first.

## GitHub Pages

GitHub Pages is now a simple **PDF-first** site.

The workflow there is:

1. render DOCX with `csasdown::render()`
2. convert `_book/techreport.docx` to PDF with LibreOffice
3. publish `techreport.pdf`

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
