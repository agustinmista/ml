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

minX <- min(values_diagonal$dim, values_parallel$dim)
maxX <- max(values_diagonal$dim, values_parallel$dim)

# Plot before prunning data
minY <- min(values_diagonal$ebp_test, values_parallel$ebp_test)
maxY <- max(values_diagonal$ebp_test, values_parallel$ebp_test)

output_before_prunning <- paste("doc/dimmed_error_before_prunning.png")
png(output_before_prunning)
par(mar=c(4,4,1,1))
plot(values_diagonal$dim, values_diagonal$ebp_test, col="red"
    , type = "l"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "Dimensions number"
    , ylab = "Error percentage"
    , lwd = 3
    )
lines(values_parallel$dim, values_parallel$ebp_test, col="green", lwd = 3)

legend(  x="topleft"
       , legend=c("diagonal", "parallel")
       , col=c("red", "green")
       , lty=c(1,1)
       , lwd=3
       , pch=c(NA,NA) 
       )

## Plot after prunning data
minY <- min(values_diagonal$eap_test, values_parallel$eap_test)
maxY <- max(values_diagonal$eap_test, values_parallel$eap_test)

output_after_prunning <- paste("doc/dimmed_error_after_prunning.png")
png(output_after_prunning)
par(mar=c(4,4,1,1))
plot(values_diagonal$dim, values_diagonal$eap_test, col="red"
    , type = "l"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "Dimensions number"
    , ylab = "Error percentage"
    , lwd = 3
    )
lines(values_parallel$dim, values_parallel$eap_test, col="green", lwd = 3)

legend(  x="topleft"
       , legend=c("diagonal", "parallel")
       , col=c("red", "green")
       , lty=c(1,1)
       , lwd=3
       , pch=c(NA,NA) 
       )
