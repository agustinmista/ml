#!/bin/bash

UNIVERSE_SIZE=10000
SIZE=250
C=0.78

DATASETS=datasets/diagonal_dimmed
TESTFILE=$DATASETS/testfile

DIAGONAL_GEN=../gen/diagonal
DTREE_GEN=./c4.5

mkdir -p $DATASETS
rm -rf $DATASETS/*

echo "dim, ebp_train, ebp_test, eap_train, eap_test" >> $DATASETS/diagonal.error.avg

for dim in 2 4 8 16 32
do
    echo "========================================"
    echo "Training with dim=$dim"

    echo "Generating universe with d=$dim  size=$UNIVERSE_SIZE  C=$C"
    $DIAGONAL_GEN $dim $UNIVERSE_SIZE $C $TESTFILE

	for i in $(seq 1 20)
	do
	    echo "Training dataset number $i"
	    ln -f $TESTFILE.data $DATASETS/diagonal.$dim.$i.test
	    $DIAGONAL_GEN $dim $SIZE $C $DATASETS/diagonal.$dim.$i
	    $DTREE_GEN -u -f $DATASETS/diagonal.$dim.$i | grep "<<" &>> $DATASETS/diagonal.$dim.raw
    done

    echo "Generating error file report."
    cat $DATASETS/diagonal.$dim.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $2}'| paste -d "," - - >> $DATASETS/diagonal.$dim.ebp.csv
    cat $DATASETS/diagonal.$dim.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $4}'| paste -d "," - - >> $DATASETS/diagonal.$dim.eap.csv
    
    ebp_train=$(cat $DATASETS/diagonal.$dim.ebp.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    ebp_test=$(cat $DATASETS/diagonal.$dim.ebp.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    eap_train=$(cat $DATASETS/diagonal.$dim.eap.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    eap_test=$(cat $DATASETS/diagonal.$dim.eap.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    echo "$dim, $ebp_train, $ebp_test, $eap_train, $eap_test" >> $DATASETS/diagonal.error.avg

done
