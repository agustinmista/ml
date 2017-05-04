#!/usr/bin/env Rscript

classify = function(x) {
    dista = (x[1]-1)^2 + (x[2]-1)^2 + (x[3]-1)^2 + (x[4]-1)^2 + (x[5]-1)^2
    distb = (x[1]+1)^2 + (x[2]+1)^2 + (x[3]+1)^2 + (x[4]+1)^2 + (x[5]+1)^2
    as.integer(dista > distb)
    }

args <- commandArgs(trailingOnly=TRUE)

data <- read.csv(file=args[1], header=FALSE)

truth <- data[,6]
prediction <- apply(data[,-6],1,classify)
total <- length(truth)
errors <- sum(truth != prediction)

cat(100 - errors/total*100, sep="\n")
