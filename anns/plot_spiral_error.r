#!/usr/bin/env Rscript

require(plot3D)
require(oce)
require(spatstat)
require(imager)
require(xtable)


data <- read.csv("datasets/spiral/spiral.error.discrete", header=F)



png("doc/spiral_error.png")
par(mar=c(4,4,1,1))

plot(data, col="red", pch=20, lwd=2, type="o", ylab="Discrete error percentage", xlab="Intermediate layer neurons number")
