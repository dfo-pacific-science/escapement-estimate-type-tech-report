render_root_artifacts <- function(convert_pdf = TRUE) {
  render_result <- csasdown::render()

  docx_src <- file.path("_book", "techreport.docx")
  docx_dst <- "techreport.docx"
  pdf_src_stale <- file.path("_book", "techreport.pdf")
  pdf_dst <- "techreport.pdf"

  if (!file.exists(docx_src)) {
    stop(sprintf("Expected rendered DOCX at %s, but it was not found.", docx_src))
  }

  if (file.exists(docx_dst)) {
    file.remove(docx_dst)
  }

  copied <- file.copy(docx_src, docx_dst, overwrite = TRUE)
  if (!copied || !file.exists(docx_dst)) {
    stop(sprintf("Failed to copy rendered DOCX from %s to %s.", docx_src, docx_dst))
  }

  if (file.exists(pdf_src_stale)) {
    file.remove(pdf_src_stale)
  }

  if (isTRUE(convert_pdf)) {
    soffice_bin <- Sys.which("soffice")
    if (!nzchar(soffice_bin) && file.exists("/Applications/LibreOffice.app/Contents/MacOS/soffice")) {
      soffice_bin <- "/Applications/LibreOffice.app/Contents/MacOS/soffice"
    }

    if (!nzchar(soffice_bin)) {
      stop(
        paste(
          "Rendered DOCX to repo root, but LibreOffice 'soffice' was not found for PDF conversion.",
          "Install LibreOffice or add 'soffice' to PATH."
        )
      )
    }

    if (file.exists(pdf_dst)) {
      file.remove(pdf_dst)
    }

    conversion_output <- system2(
      soffice_bin,
      c("--headless", "--convert-to", "pdf", "--outdir", ".", docx_dst),
      stdout = TRUE,
      stderr = TRUE
    )

    conversion_status <- attr(conversion_output, "status")
    if (!is.null(conversion_status) && conversion_status != 0) {
      stop(paste(c("LibreOffice PDF conversion failed:", conversion_output), collapse = "\n"))
    }

    if (!file.exists(pdf_dst)) {
      stop(sprintf("Expected rendered PDF at %s, but it was not created.", pdf_dst))
    }
  }

  invisible(render_result)
}
