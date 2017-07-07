args <- commandArgs(trailingOnly = TRUE)
packageName <- args[1]
packageVersion <- args[2]
pkg <- paste0(packageName, "_", packageVersion, "_R_x86_64-pc-linux-gnu.tar.gz")
install.packages(pkg, lib = .libPaths()[[1]], repos = NULL)