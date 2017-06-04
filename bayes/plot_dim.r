#!/usr/bin/env Rscript

require(plot3D)
require(oce)
require(spatstat)
require(imager)
require(xtable)


diagonal_dtree_data <- read.csv("datasets/diagonal/diagonal.error.dtree")
parallel_dtree_data <- read.csv("datasets/parallel/parallel.error.dtree")

diagonal_ann_data <- read.csv("datasets/diagonal/diagonal.error.ann", header=F)
parallel_ann_data <- read.csv("datasets/parallel/parallel.error.ann", header=F)

diagonal_bayes_data <- read.csv("datasets/diagonal/diagonal.error.bayes", header=F)
parallel_bayes_data <- read.csv("datasets/parallel/parallel.error.bayes", header=F)

diag_test_dtree = diagonal_dtree_data$eap_test
diag_test_ann = diagonal_ann_data$V2
diag_test_bayes = diagonal_bayes_data$V3

par_test_dtree = parallel_dtree_data$eap_test
par_test_ann = parallel_ann_data$V2
par_test_bayes = parallel_bayes_data$V3

dims = diagonal_ann_data$V1

png("doc/bayes_vs_anns_vs_dtree.png")
par(mar=c(4,4,1,1))

plot( dims, diag_test_dtree, log="y"
    , ylim=c(10,35) , ylab="Discrete error percentage", xlab="Dimensions"
    , col="red", pch=19, lwd=1, type="b", cex=1.5)

points(dims, diag_test_ann, col="green", cex=1.5, pch=19, lwd=1, type="b")
points(dims, diag_test_bayes, col="blue", cex=1.5, pch=19, lwd=1, type="b")

points(dims, par_test_dtree, col="red", cex=1.5, pch=17, lwd=1, type="b")
points(dims, par_test_ann, col="green", cex=1.5, pch=17, lwd=1, type="b")
points(dims, par_test_bayes, col="blue", cex=1.5, pch=17, lwd=1, type="b")

legend(x = "topleft"
       , legend = c( "Decision Tree", "Neural Networks", "Naive-Bayes"
                    , "Diagonal", "Parallel")
       , pch = c(NA, NA, NA, 19, 17)
       , lty = c(1,1,1, NA, NA)
       , col = c("red", "green", "blue", "black", "black"), lwd=1)
