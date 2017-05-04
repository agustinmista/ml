#!/bin/bash

UNIVERSE_SIZE=10000
DIMS=5
SIZE=250

DATASETS=datasets/diagonal_noise
TESTFILE=$DATASETS/testfile

DIAGONAL_GEN=../gen/diagonal
DTREE_GEN=./c4.5
BAYES=./bayes_error_diagonal.R

mkdir -p $DATASETS
rm -rf $DATASETS/*

echo "c, ebp_train, ebp_test, eap_train, eap_test, bayes" >> $DATASETS/diagonal.error.avg

for c in 0.5 1.0 1.5 2.0 2.5
do
    echo "========================================"
    echo "Training with C=$c"

    echo "Generating universe with d=$DIMS  size=$UNIVERSE_SIZE  C=$c"
    $DIAGONAL_GEN $DIMS $UNIVERSE_SIZE $c $TESTFILE


	for i in $(seq 1 20)
	do
	    echo "Training dataset number $i"
	    ln -f $TESTFILE.data $DATASETS/diagonal.$c.$i.test
	    $DIAGONAL_GEN $DIMS $SIZE $c $DATASETS/diagonal.$c.$i
	    $DTREE_GEN -u -f $DATASETS/diagonal.$c.$i | grep "<<" &>> $DATASETS/diagonal.$c.raw
        $BAYES $DATASETS/diagonal.$c.$i.data >> $DATASETS/diagonal.$c.bayes
        sleep 1
    done

    echo "Generating error file report."
    cat $DATASETS/diagonal.$c.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $2}'| paste -d "," - - >> $DATASETS/diagonal.$c.ebp.csv
    cat $DATASETS/diagonal.$c.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $4}'| paste -d "," - - >> $DATASETS/diagonal.$c.eap.csv
    
    ebp_train=$(cat $DATASETS/diagonal.$c.ebp.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    ebp_test=$(cat $DATASETS/diagonal.$c.ebp.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    eap_train=$(cat $DATASETS/diagonal.$c.eap.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    eap_test=$(cat $DATASETS/diagonal.$c.eap.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    bayes=$(cat $DATASETS/diagonal.$c.bayes | awk '{sum+=$1; ++n} END {print sum/n}')
    echo "$c, $ebp_train, $ebp_test, $eap_train, $eap_test, $bayes" >> $DATASETS/diagonal.error.avg

done
