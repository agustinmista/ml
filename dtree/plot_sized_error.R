#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 2) { 
    message("USAGE: ./plot_error.R diagonal.error.avg parallel.error.avg")
    quit()
}

input_diagonal <- args[1]
input_parallel <- args[2]

values_diagonal <- read.csv(file=input_diagonal)
values_parallel <- read.csv(file=input_parallel)

minX <- min(values_diagonal$size, values_parallel$size)
maxX <- max(values_diagonal$size, values_parallel$size)
minY <- min(values_diagonal$ebp_test, values_diagonal$ebp_train, values_parallel$ebp_test, values_parallel$ebp_train)
maxY <- max(values_diagonal$ebp_test, values_diagonal$ebp_train, values_parallel$ebp_test, values_parallel$ebp_train)

# Plot before prunning data
output_before_prunning <- paste("doc/sized_error_before_prunning.png")

png(output_before_prunning)
plot(values_diagonal$size, values_diagonal$ebp_train, col="red"
par(mar=c(4,4,1,1))
    , type = "o"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "Training size"
    , ylab = "Error percentage"
    , lwd = 2
    , lty = 3
    )
lines(values_parallel$size, values_parallel$ebp_train, col="green", type = "o", lwd = 2, lty=3)
lines(values_diagonal$size, values_diagonal$ebp_test, col="red", type = "o", lwd = 2)
lines(values_parallel$size, values_parallel$ebp_test, col="green", type = "o", lwd = 2)


legend(  x="topright"
       , legend=c("Diagonal train","Diagonal test", "Parallel train", "Parallel test")
       , col=c("red", "red", "green", "green")
       , lty=c(3,1,3,1)
       , lwd=2
       , pch=c(NA,NA,NA,NA) 
       )

	## Plot after prunning data
minY <- min(values_diagonal$eap_test, values_diagonal$eap_train, values_parallel$eap_test, values_parallel$eap_train)
maxY <- max(values_diagonal$eap_test, values_diagonal$eap_train, values_parallel$eap_test, values_parallel$eap_train)

output_before_prunning <- paste("doc/sized_error_after_prunning.png")

png(output_before_prunning)
par(mar=c(4,4,1,1))
plot(values_diagonal$size, values_diagonal$eap_train, col="red"
    , type = "o"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "Training dataset size"
    , ylab = "Error percentage"
    , lwd = 2
    , lty=3 
    )

lines(values_parallel$size, values_parallel$eap_train, col="green", type = "o", lty=3)
lines(values_diagonal$size, values_diagonal$eap_test, col="red", type = "o", lwd = 2)
lines(values_parallel$size, values_parallel$eap_test, col="green", type = "o", lwd = 2)


legend(  x="topright"
       , legend=c("Diagonal train","Diagonal test", "Parallel train", "Parallel test")
       , col=c("red", "red", "green", "green")
       , lty=c(3,1,3,1)
       , lwd=2
       , pch=c(NA,NA,NA,NA) 
       )
