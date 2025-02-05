#' Generate Citation or BibTeX for a Table
#'
#' Generates a citation or BibTeX entry for a table in the data warehouse. If a DOI exists, it
#' constructs the citation or BibTeX using the DOI. If no DOI is present, it uses the 
#' reference column. If neither is available, it returns NA. Prints a warning if the table does not exist.
#'
#' @param table_name A character string specifying the name of the table.
#' @param if_bibtex Logical; if TRUE, returns the BibTeX entry instead of the citation. Defaults to FALSE.
#' @return A character string containing the citation or BibTeX entry, NA if neither is available, or NULL if the table does not exist.
#' @export
cite <- function(table_name, if_bibtex=FALSE) {
  dict_path = "../data/IRW Data Dictionary - data index.csv"
  dict <- read.csv(dict_path, stringsAsFactors = FALSE)
  table_row <- dict[dict$Filename == table_name, ]
  
  if (nrow(table_row) == 0) {
    warning("The table '", table_name, "' does not exist in the metadata.")
    return(NULL)
  }
  
  doi <- table_row$DOI
  reference <- table_row$Reference
  
  # Retrieve BibTeX
  if (if_bibtex) {
    # Generate BibTeX from DOI
    if (!is.null(doi) && nzchar(doi)) {
      response <- tryCatch({
        httr::GET(glue::glue("https://doi.org/{doi}"), httr::add_headers(Accept = "application/x-bibtex"))
      }, error = function(e) NULL)
      if (!is.null(response) && httr::status_code(response) == 200) {
        bibtex <- httr::content(response, as = "text", encoding = "UTF-8")
      } else {
        bibtex <- glue::glue("# Error fetching BibTeX for DOI: {doi}")
      }
    } else{ # Try read pre-defined BibTeX
      bibtex_dict_path <- "../data/BibTex_Manual.csv"
      bibtex_dict <- read.csv(bibtex_dict_path, stringsAsFactors = FALSE)
      bibtex_table_row <- bibtex_dict[bibtex_dict$Filename == table_name, ]
      if (nrow(bibtex_table_row) == 0) {
        warning("# No BibTeX or DOI available for table: ", table_name)
        return(NULL)
      }
      bibtex <- bibtex_table_row$BibTex
    } 
    if (!is.na(bibtex)) {
      cat("BibTeX entry for table ", table_name, "is\n", bibtex)
    }
    return(bibtex)
  } else {
    # Generate citation based on available data
    if (!is.null(doi) && nzchar(doi)) {
      citation <- paste0("https://doi.org/", doi)
    } else if (!is.null(reference) && nzchar(reference)) {
      citation <- reference
    } else {
      citation <- NA
    }
    if (!is.na(citation)) {
      cat("To cite ", table_name, " in publication use:\n", citation)
    }
    return(citation)
  }
}

