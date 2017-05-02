#!/bin/bash

UNIVERSE_SIZE=10000
DATASETS=datasets/diagonal_x20
TESTFILE=$DATASETS/testfile

DIAGONAL_GEN=../gen/diagonal
DTREE_GEN=./c4.5
PLOTTER=../gen/plot.R

echo "Generating universe of size $UNIVERSE_SIZE"
mkdir -p $DATASETS

$DIAGONAL_GEN 2 $UNIVERSE_SIZE 0.78 $TESTFILE

for size in 100 200 300 500 1000 5000
do
	echo "Training with size $size"
	rm -f $DATASETS/diagonal.$size.values
	for i in $(seq 1 20)
	do
		echo "Training dataset number $i"
		ln -f $TESTFILE.data $DATASETS/diagonal.$size.$i.test
		$DIAGONAL_GEN 2 $size 0.78 $DATASETS/diagonal.$size.$i
		$DTREE_GEN -u -f $DATASETS/diagonal.$size.$i &>> $DATASETS/diagonal.$size.$i.report
		grep "<<" $DATASETS/diagonal.$size.$i.report | tail -n 1 &>> $DATASETS/diagonal.$size.values
		sleep 1
	done
done

