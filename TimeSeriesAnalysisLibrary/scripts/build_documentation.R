library(devtools)
args <- commandArgs(trailingOnly = TRUE)
pkg <- paste0("packages/", args[1])
devtools::document(pkg=pkg)