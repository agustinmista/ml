#!/usr/bin/env Rscript

require(plot3D)
require(oce)
require(spatstat)
require(imager)
require(xtable)


diagonal_dtree_data <- read.csv("datasets/diagonal/diagonal.error.dtree")
parallel_dtree_data <- read.csv("datasets/parallel/parallel.error.dtree")

diagonal_ann_data <- read.csv("datasets/diagonal/diagonal.error.discrete", header=F)
parallel_ann_data <- read.csv("datasets/parallel/parallel.error.discrete", header=F)


diag_train_dtree = diagonal_dtree_data$eap_train
diag_test_dtree = diagonal_dtree_data$eap_test

par_train_dtree = parallel_dtree_data$eap_train
par_test_dtree = parallel_dtree_data$eap_test

diag_test_ann = diagonal_ann_data$V2
par_test_ann = parallel_ann_data$V2

#dims = diagonal_dtree_data$dim
dims_names = c("2", "4", "8", "16", "32") 

dims = diagonal_ann_data$V1


#png("doc/anns_vs_dtree.png")
#par(mar=c(4,4,1,1))
#plot(dims, diag_train_dtree,  col="red", ylim=c(0,35), pch=20, lwd=2, type="o", ylab="Discrete error percentage", xlab="Dimensions", xaxt="n")
#points(dims, diag_test_dtree, col="blue", pch=20, lwd=2, type="o")
#points(dims, par_train_dtree, col="green", pch=20, lwd=2, type="o")
#points(dims, par_test_dtree, col="orange", pch=20, lwd=2, type="o")
#points(dims, diag_test_ann, col="orange", pch=20, lwd=2, type="o")
#points(dims, par_test_ann, col="black", pch=20, lwd=2, type="o")
#legend(x = "topleft",legend = c("Diagonal Train @ DT", "Diagonal Test @ DT", "Parallel Train @ DT", "Parallel Test @ DT", "Diagonal Test @ ANN", "Parallel Test @ ANN"), col=c("red", "blue", "green", "orange", "orange", "black"), lwd=2)
#axis(1, at=dims, labels=dims_names)

png("doc/anns_vs_dtree.png")
par(mar=c(4,4,1,1))
plot(dims, diag_test_dtree,  col="red", ylim=c(10,35), pch=20, lwd=2, type="o", ylab="Discrete error percentage", xlab="Dimensions") # xaxt="n")
points(dims, diag_test_ann, col="blue", pch=20, lwd=2, type="o")
points(dims, par_test_dtree, col="green", pch=20, lwd=2, type="o")
points(dims, par_test_ann, col="orange", pch=20, lwd=2, type="o")
legend(x = "topleft",legend = c("Diagonal @ DT", "Parallel @ DT", "Diagonal @ ANN", "Parallel @ ANN"), col=c("red", "green", "blue", "orange"), lwd=2)
#axis(1, at=dims, labels=dims_names)
