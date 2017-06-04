#!/usr/bin/env Rscript

require(plot3D)
require(oce)
require(spatstat)
require(imager)
require(xtable)


plot_decay <- function(msefile) {

    data <- read.csv(msefile, header=F, sep=" ")
    
    x = 1:500
    smoothed <- loess(data$V8~x, span=0.1)


    png(paste(msefile,"decay", "png", sep="."))
    par(mar=c(4,4,1,1))
    plot(data$V8, col="blue", lwd=1, cex=0.2, pch=21,
         xlab="Epoch", ylab="Decay", xaxt="n")
    
    lines(predict(smoothed), col="blue", lwd=3) 

    axis(1, at=seq(0, 500, 100), labels=c("0", "20000", "40000", "60000", "80000", "100000"))
    
}


plot_error <- function(msefile) {

    data <- read.csv(msefile, header=F, sep=" ")
    x = 1:500
    lo_train <- loess(data$V2~x, span=0.2)
    lo_test <- loess(data$V4~x, span=0.2)

    minY = min(data$V2, data$V4)
    maxY = max(data$V2, data$V4)

    png(paste(msefile,"error", "png", sep="."))
    par(mar=c(4,4,1,1))
    plot(data$V2, col="red", lwd=1, cex=0.2, pch=21,
         xlab="Epoch", ylab="Mean Square Error", xaxt="n", ylim=c(minY, maxY))
    points(data$V4, col="blue", lwd=1, cex=0.2, pch=21)   

    lines(predict(lo_train), col="red", lwd=3) 
    lines(predict(lo_test), col="blue", lwd=3) 

    axis(1, at=seq(0, 500, 100), labels=c("0", "20000", "40000", "60000", "80000", "100000"))

    legend(x="topright", legend=c("Train", "Test"), col=c("red", "blue"), lwd=2)
}

plot_error("datasets/sunspots/ssp.1.mse.avg")
plot_error("datasets/sunspots/ssp.0.1.mse.avg")
plot_error("datasets/sunspots/ssp.0.01.mse.avg")
plot_error("datasets/sunspots/ssp.0.001.mse.avg")
plot_error("datasets/sunspots/ssp.0.0001.mse.avg")
plot_error("datasets/sunspots/ssp.0.00001.mse.avg")
plot_error("datasets/sunspots/ssp.0.000001.mse.avg")
plot_error("datasets/sunspots/ssp.0.0000001.mse.avg")
plot_error("datasets/sunspots/ssp.0.00000001.mse.avg")

plot_decay("datasets/sunspots/ssp.1.mse.avg")
plot_decay("datasets/sunspots/ssp.0.1.mse.avg")
plot_decay("datasets/sunspots/ssp.0.01.mse.avg")
plot_decay("datasets/sunspots/ssp.0.001.mse.avg")
plot_decay("datasets/sunspots/ssp.0.0001.mse.avg")
plot_decay("datasets/sunspots/ssp.0.00001.mse.avg")
plot_decay("datasets/sunspots/ssp.0.000001.mse.avg")
plot_decay("datasets/sunspots/ssp.0.0000001.mse.avg")
plot_decay("datasets/sunspots/ssp.0.00000001.mse.avg")

