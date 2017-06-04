#!/usr/bin/env Rscript

require(plot3D)
require(oce)
require(spatstat)
require(imager)
require(xtable)


########################################
##       Discrete error table         ##
########################################
raw_error <- read.csv("datasets/dos_elipses/dos_elipses.error.discrete"
    , header = FALSE
    , col.names = c("LR", "MOM", "ERROR"))

LRs <- sort(unique(raw_error$LR))
MOMs <- sort(unique(raw_error$MOM))

error_matrix <- matrix(ncol = length(LRs), nrow = length(MOMs))
error_matrix[,] = 0

colnames(error_matrix) <- LRs
rownames(error_matrix) <- MOMs

for (lr in LRs) {
    for (mom in MOMs) {
        err = subset(subset(raw_error, LR == lr), MOM == mom)$ERROR
        error_matrix[toString(mom), toString(lr)] = err
    }
}

print(error_matrix)

smoothed_error = as.matrix(isoblur(as.cimg(error_matrix), 1)) 
smoothed_error[18, 9] = 5

print(smoothed_error)

png("doc/local_minimums_heatmap.png")
par(mar=c(4,4,1,1))
image2D( z = smoothed_error
       , x = MOMs
       , xlab = "Momentum"
       , y = LRs
       , ylab = "Learning Rate"
       , log = "y"
       , colkey = FALSE
       , contour = list(lwd = 3, nlevels = 3, labcex = 1.2)
       ) 

print(xtable(error_matrix))



########################################
##      Best train mse by epoch       ##
########################################
best = "datasets/dos_elipses/dos_elipses.10.0.0063.0.85.mse"

data <- read.csv(best, header=FALSE, sep="\t")
names(data) <- c("mse", "train_mse", "val_mse", "test_mse", "train_disc", "val_disc", "test_disc")

x <- 1:100
lo_train <- loess(data$train_mse~x, span=0.4)
lo_val <- loess(data$val_mse~x, span=0.4)
lo_test <- loess(data$test_mse~x, span=0.4)

png("doc/local_minimums_best_mse.png")
par(mar=c(4,4,1,1))

plot(x, data$train_mse, col="red",bg="red", cex=0.5, pch=21, ylim = c(0.11,0.16),
     xlab = "Epoch", ylab = "Mean Square Error", xaxt="n")
lines(predict(lo_train), col="red", lwd=2)
axis(1, at=seq(0, 100, 25), labels=seq(0, 40000, 10000))

points(x, data$val_mse, col="green",bg="green", cex=0.5, pch=21 )
lines(predict(lo_val), col="green", lwd=2)

points(x, data$test_mse, col="blue",bg="blue", cex=0.5, pch=21 )
lines(predict(lo_test), col="blue", lwd=2)

legend(x="topright", legend=c("Train", "Validation", "Test"), col=c("red", "green", "blue"), lwd=2)
