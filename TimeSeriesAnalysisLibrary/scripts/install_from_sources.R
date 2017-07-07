args <- commandArgs(trailingOnly = TRUE)
packageName <- args[1]
packageVersion <- args[2]
pkg <- paste0(packageName, "_", packageVersion, ".tar.gz")
install.packages(pkg, lib = .libPaths()[[1]], repos = NULL)