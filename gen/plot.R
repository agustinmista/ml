#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 1) { 
    message("No input file specified!")
    quit()
}

input <- args[1]

values <- read.csv(file=input, header=FALSE)
cols <- colnames(values)

if (ncol(values) != 3) {
    message("Expecting a 2-dimensional dataset")
    quit()
} 

zeroes <- subset(values, V3 == '0')
ones   <- subset(values, V3 == '1')

minX <- min(zeroes$V1, ones$V1)
maxX <- max(zeroes$V1, ones$V1)
minY <- min(zeroes$V2, ones$V2)
maxY <- max(zeroes$V2, ones$V2)

message("Statisticts") 
message(paste("1\U03C3 = (X := ", sd(ones$V1),     ", Y := ", sd(ones$V2),     ")", sep=""))
message(paste("1\U03BC = (X := ", mean(ones$V1),   ", Y := ", mean(ones$V2),   ")", sep=""))
message(paste("0\U03C3 = (X := ", sd(zeroes$V1),   ", Y := ", sd(zeroes$V2),   ")", sep=""))
message(paste("0\U03BC = (X := ", mean(zeroes$V1), ", Y := ", mean(zeroes$V2), ")", sep=""))

output <- paste(input, ".pdf", sep="")
message(paste("Saving plot to", output))

pdf(output)
plot(zeroes$V1, zeroes$V2, col="red"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "X", ylab = "Y"
    )

points(ones$V1, ones$V2, col="green")

