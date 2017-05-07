#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1) { 
    message("No input file specified!")
    quit()
}

input <- args[1]
message(paste("Opening file:", input))

values <- read.csv(file=input, header=FALSE)
colnames(values) <- c("X", "Y", "N1", "N2", "N3", "N4", "Class")

zeroes <- subset(values, Class == '0')
ones   <- subset(values, Class == '1')

minX <- min(zeroes$X, ones$X)
maxX <- max(zeroes$X, ones$X)
minY <- min(zeroes$Y, ones$Y)
maxY <- max(zeroes$Y, ones$Y)

png("doc/xor_classes.png")
par(mar=c(4,4,1,1))
plot(zeroes$X, zeroes$Y, col="red"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "X", ylab = "Y"
    , pch = 20, cex = .5
    )
rect(-1.5,1.5,0,0, col=rgb(0,1,0,0.02), border=NA)
rect(0,0,1.5,-1.5, col=rgb(0,1,0,0.02), border=NA)
rect(0,0,1.5,1.5,  col=rgb(1,0,0,0.02), border=NA)
rect(-1.5,-1.5,0,0,col=rgb(1,0,0,0.02), border=NA)
points(ones$X, ones$Y, col="green", pch = 20, cex = .5)
