#!/bin/bash

UNIVERSE_SIZE=10000
DATASETS=datasets/spiral
TESTFILE=$DATASETS/spiral10000

SPIRALGEN=../gen/spiral
DTREEGEN=./c4.5
PLOTTER=../gen/plot.R

echo "Generating universe of size $UNIVERSE_SIZE"
mkdir -p $DATASETS

$SPIRALGEN $UNIVERSE_SIZE $TESTFILE

for size in 150 600 3000
do
	echo "Training with size $size"
	cp $TESTFILE.data $DATASETS/spiral$size.test
	$SPIRALGEN $size $DATASETS/spiral$size 		&>  $DATASETS/spiral$size.report
	$DTREEGEN -u -f $DATASETS/spiral$size 		&>> $DATASETS/spiral$size.report
	$PLOTTER $DATASETS/spiral$size.data 		&>> $DATASETS/spiral$size.report
	$PLOTTER $DATASETS/spiral$size.prediction 	&>> $DATASETS/spiral$size.report
done

