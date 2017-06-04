#!/bin/bash

DATASET=datasets/spiral
BASENAME=$DATASET/spiral

DISCRETIZER=./discretiza
PLOT=./plot_spiral.r


###########################
##         MAIN          ##
###########################

for n2 in 2 5 10 20 40
do
    $DISCRETIZER $BASENAME.1.$n2
    $PLOT $BASENAME.1.$n2.predic.d
done

echo "Finished!"

    
