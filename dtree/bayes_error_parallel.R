#!/usr/bin/env Rscript

classify = function(x) { as.integer(x[1] < 0)    }

args <- commandArgs(trailingOnly=TRUE)

data <- read.csv(file=args[1], header=FALSE)

truth <- data[,6]
prediction <- apply(data[,-6],1,classify)
total <- length(truth)
errors <- sum(truth != prediction)

cat(100 - errors/total*100, sep="\n")
