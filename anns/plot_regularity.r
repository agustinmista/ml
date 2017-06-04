#!/usr/bin/env Rscript

require(plot3D)
require(oce)
require(spatstat)
require(imager)
require(xtable)

data50 = "datasets/ikeda/ikeda.50.mse.avg"

data <- read.csv(data50, header=FALSE, sep=" ")
names(data) <- c("mse", "train_mse", "val_mse", "test_mse", "train_disc", "val_disc", "test_disc")

x <- 1:100
lo_train <- loess(data$train_mse~x, span=0.15)
lo_val <- loess(data$val_mse~x, span=0.15)
lo_test <- loess(data$test_mse~x, span=0.15)


png("doc/ikeda.50.mse.avg.png")
par(mar=c(4,4,1,1))

minY = min(data$train_mse, data$val_mse, data$test_mse)
maxY = max(data$train_mse, data$val_mse, data$test_mse)

plot(x, data$train_mse, col="red",bg="red", cex=0.5, pch=21, # ylim = c(0.11,0.15),
     xlab = "Epoch", ylab = "Mean Square Error", xaxt="n", ylim=c(0, 0.32))

points(x, data$val_mse, col="green",bg="green", cex=0.5, pch=21 )
points(x, data$test_mse, col="blue",bg="blue", cex=0.5, pch=21 )


lines(predict(lo_train), col="red", lwd=2)
lines(predict(lo_val), col="green", lwd=2)
lines(predict(lo_test), col="blue", lwd=2)

axis(1, at=seq(0, 100, 25), labels=seq(0, 20000, 5000))
legend(x="topright", legend=c("Train", "Validation", "Test"), col=c("red", "green", "blue"), lwd=2)
