#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 2) { 
    message("USAGE: ./plot_noise_error.R diagonal.error.avg parallel.error.avg")
    quit()
}

input_diagonal <- args[1]
input_parallel <- args[2]

values_diagonal <- read.csv(file=input_diagonal)
values_parallel <- read.csv(file=input_parallel)

minX <- min(values_diagonal$c, values_parallel$c)
maxX <- max(values_diagonal$c, values_parallel$c)

# Plot before prunning data
minY <- min(values_diagonal$ebp_test, values_parallel$ebp_test)
maxY <- max(values_diagonal$ebp_test, values_parallel$ebp_test)

output_before_prunning <- paste("doc/noise_error_before_prunning.png")
png(output_before_prunning)
plot(values_diagonal$c, values_diagonal$ebp_test, col="red"
    , type = "o"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "C dispersion"
    , ylab = "Error percentage"
    , lwd = 2
    )
lines(values_parallel$c, values_parallel$ebp_test, col="green", type = "o", lwd = 2)
lines(values_diagonal$c, values_diagonal$bayes, col="red", type = "o", lwd = 2, lty=3)
lines(values_parallel$c, values_parallel$bayes, col="green", type = "o", lwd = 2, lty=3)

legend(  x="topleft"
       , legend=c("Diagonal", "Diagonal Bayes", "Parallel", "Parallel Bayes")
       , col=c("red", "red", "green", "green")
       , lty=c(1,3,1,3)
       , lwd=2
       , pch=c(NA,NA,NA,NA) 
       )

## Plot after prunning data
minY <- min(values_diagonal$eap_test, values_parallel$eap_test)
maxY <- max(values_diagonal$eap_test, values_parallel$eap_test)

output_after_prunning <- paste("doc/noise_error_after_prunning.png")
png(output_after_prunning)
plot(values_diagonal$c, values_diagonal$eap_test, col="red"
    , type = "o"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "C dispersion"
    , ylab = "Error percentage"
    , lwd = 2
    )
lines(values_parallel$c, values_parallel$eap_test, col="green", type = "o", lwd = 2)
lines(values_diagonal$c, values_diagonal$bayes, col="red", type = "o", lwd = 2, lty=3)
lines(values_parallel$c, values_parallel$bayes, col="green", type = "o", lwd = 2, lty=3)

legend(  x="topleft"
       , legend=c("Diagonal", "Diagonal Bayes", "Parallel", "Parallel Bayes")
       , col=c("red", "red", "green", "green")
       , lty=c(1,3,1,3)
       , lwd=2
       , pch=c(NA,NA,NA,NA) 
       )
