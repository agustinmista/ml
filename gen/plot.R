#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1) { 
    message("No input file specified!")
    quit()
}

input <- args[1]
message(paste("Opening file:", input))

values <- read.csv(file=input, header=FALSE)
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

message("Statisticts") 
message(paste("1\U03C3 = (X := ", sd(ones$X),     ", Y := ", sd(ones$Y),     ")", sep=""))
message(paste("1\U03BC = (X := ", mean(ones$X),   ", Y := ", mean(ones$Y),   ")", sep=""))
message(paste("0\U03C3 = (X := ", sd(zeroes$X),   ", Y := ", sd(zeroes$Y),   ")", sep=""))
message(paste("0\U03BC = (X := ", mean(zeroes$X), ", Y := ", mean(zeroes$Y), ")", sep=""))

output <- paste(input, ".pdf", sep="")
message(paste("Saving plot to", output))

pdf(output)
plot(zeroes$X, zeroes$Y, col="red"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "X", ylab = "Y"
    , pch = 20, cex = .5
    )

points(ones$X, ones$Y, col="green", pch = 20, cex = .5)

abline(v = mean(zeroes$X), col = "darkred", lty = "dashed")
abline(h = mean(zeroes$Y), col = "darkred", lty = "dashed")
abline(v = mean(ones$X), col = "darkgreen", lty = "dashed")
abline(h = mean(ones$Y), col = "darkgreen", lty = "dashed")


