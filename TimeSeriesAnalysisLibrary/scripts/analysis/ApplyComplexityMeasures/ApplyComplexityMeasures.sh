#!/bin/bash

export R_LIBS=~/R

Rscript /home/jmoreno/code/TimeSeriesAnalysisLibrary/scripts/analysis/apply_complexity_measures.R 1201 1400
Rscript /home/jmoreno/code/TimeSeriesAnalysisLibrary/scripts/analysis/apply_complexity_measures.R 1401 1600
Rscript /home/jmoreno/code/TimeSeriesAnalysisLibrary/scripts/analysis/apply_complexity_measures.R 1601 1800
Rscript /home/jmoreno/code/TimeSeriesAnalysisLibrary/scripts/analysis/apply_complexity_measures.R 1801 2000
Rscript /home/jmoreno/code/TimeSeriesAnalysisLibrary/scripts/analysis/apply_complexity_measures.R 2001 2200
Rscript /home/jmoreno/code/TimeSeriesAnalysisLibrary/scripts/analysis/apply_complexity_measures.R 2201 4000