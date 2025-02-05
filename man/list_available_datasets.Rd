% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-db-metadata.R
\name{list_available_datasets}
\alias{list_available_datasets}
\title{List Available Datasets}
\usage{
list_available_datasets()
}
\value{
A data frame where each row corresponds to a dataset, with columns for the
dataset name (\code{name}), number of rows (\code{numRows}), and variable count (\code{variableCount}).
}
\description{
Retrieves a summary of available datasets in the datasource, including the dataset name,
number of rows, and variable count for each dataset.
}
\examples{
\dontrun{
  datasets_summary <- list_available_datasets()
  print(datasets_summary)
}
}
