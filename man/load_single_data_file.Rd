% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load_single_data_file.R
\name{load_single_data_file}
\alias{load_single_data_file}
\title{Load a single data file}
\usage{
load_single_data_file(input_file_path, contig_lengths,
  plot.unplaced = TRUE)
}
\arguments{
\item{input_file_path}{Path to a data file.}

\item{contig_lengths}{A list of contig lengths obtained with the \code{\link{load_contig_lengths}} function.}

\item{plot.unplaced}{If TRUE, unplaced contigs will be plotted as a supercontig (default TRUE).}
}
\value{
A data frame storing the data from the input file.
}
\description{
Loads a single data file generated by PSASS
}
\examples{
data <- load_single_data_file("fst_window.tsv", contig_lengths, plot.unplaced = FALSE)
}
