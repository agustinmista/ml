#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 2) { 
    message("USAGE: ./plot_error.R diagonal.size.avg parallel.size.avg")
    quit()
}

input_diagonal <- args[1]
input_parallel <- args[2]

values_diagonal <- read.csv(file=input_diagonal)
values_parallel <- read.csv(file=input_parallel)

minX <- min(values_diagonal$size, values_parallel$size)
maxX <- max(values_diagonal$size, values_parallel$size)
minY <- min(values_diagonal$sbp, values_parallel$sbp, values_diagonal$sap, values_parallel$sap)
maxY <- max(values_diagonal$sbp, values_parallel$sbp, values_diagonal$sap, values_parallel$sap)

# Plot before prunning data
output_before_prunning <- paste("doc/sized_size_before_prunning.png")

png(output_before_prunning)
par(mar=c(4,4,1,1))
plot(values_diagonal$size, values_diagonal$sbp, col="red"
    , type = "o"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "Training size"
    , ylab = "Tree size"
    , lwd = 2
    )
lines(values_parallel$size, values_parallel$sbp, col="green", type = "o", lwd = 2)

legend(  x="topleft"
       , legend=c("Diagonal", "Parallel")
       , col=c("red", "green")
       , lty=c(1,1)
       , lwd=3
       , pch=c(NA,NA) 
       )

## Plot after prunning data
output_after_prunning <- paste("doc/sized_size_after_prunning.png")

png(output_after_prunning)
par(mar=c(4,4,1,1))
plot(values_diagonal$size, values_diagonal$sap, col="red"
    , type = "o"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "Training size"
    , ylab = "Tree size"
    , lwd = 2
    )

lines(values_parallel$size, values_parallel$sap, col="green", type = "o", lwd = 3)

legend(  x="topleft"
       , legend=c("Diagonal", "Parallel")
       , col=c("red", "green")
       , lty=c(1,1)
       , lwd=3
       , pch=c(NA,NA) 
       )
