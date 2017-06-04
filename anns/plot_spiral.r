#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1) { 
    message("No input file specified!")
    quit()
}

input <- args[1]
message(paste("Opening file:", input))

values <- read.csv(file=input, header=FALSE, sep="\t")
colnames(values) <- c("X", "Y", "Class")

if (ncol(values) != 3) {
    message("Expecting a 2-dimensional dataset")
    quit()
} 

zeroes <- subset(values, Class == '0')
ones   <- subset(values, Class == '1')

minX <- min(zeroes$X, ones$X)
maxX <- max(zeroes$X, ones$X)
minY <- min(zeroes$Y, ones$Y)
maxY <- max(zeroes$Y, ones$Y)


output <- paste(input, ".png", sep="")
message(paste("Saving plot to", output))

png(output)
par(mar=c(4,4,1,1))
plot(zeroes$X, zeroes$Y, col="red"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "X", ylab = "Y"
    , pch = 20, cex = .5
    )

points(ones$X, ones$Y, col="green", pch = 20, cex = .5)
