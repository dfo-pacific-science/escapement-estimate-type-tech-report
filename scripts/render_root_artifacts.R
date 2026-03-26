render_root_artifacts <- function() {
  render_result <- csasdown::render()
  docx_path <- file.path("_book", "techreport.docx")

  if (!file.exists(docx_path)) {
    stop(sprintf("Expected rendered DOCX at %s, but it was not found.", docx_path))
  }

  invisible(render_result)
}
