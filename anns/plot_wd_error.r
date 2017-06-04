#!/usr/bin/env Rscript

require(plot3D)
require(oce)
require(spatstat)
require(imager)
require(xtable)


data <- read.csv("datasets/sunspots/ssp.error", header=F)



png("doc/sunspots_error.png")
par(mar=c(4,4,1,1))

plot(data, col="red",log = "x", pch=20, lwd=2, type="o", ylab="Mean Square Error", xlab="Gamma")
