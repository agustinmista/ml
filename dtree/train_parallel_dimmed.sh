#!/bin/bash

UNIVERSE_SIZE=10000
SIZE=250
C=0.78

DATASETS=datasets/parallel_dimmed
TESTFILE=$DATASETS/testfile

PARALLEL_GEN=../gen/parallel
DTREE_GEN=./c4.5

mkdir -p $DATASETS
rm -rf $DATASETS/*

echo "dim, ebp_train, ebp_test, eap_train, eap_test" >> $DATASETS/parallel.error.avg

for dim in 2 4 8 16 32
do
    echo "========================================"
    echo "Training with dim=$dim"

    echo "Generating universe with d=$dim  size=$UNIVERSE_SIZE  C=$C"
    $PARALLEL_GEN $dim $UNIVERSE_SIZE $C $TESTFILE

	for i in $(seq 1 20)
	do
	    echo "Training dataset number $i"
	    ln -f $TESTFILE.data $DATASETS/parallel.$dim.$i.test
	    $PARALLEL_GEN $dim $SIZE $C $DATASETS/parallel.$dim.$i
	    $DTREE_GEN -u -f $DATASETS/parallel.$dim.$i | grep "<<" &>> $DATASETS/parallel.$dim.raw
        sleep 1
    done

    echo "Generating error file report."
    cat $DATASETS/parallel.$dim.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $2}'| paste -d "," - - >> $DATASETS/parallel.$dim.ebp.csv
    cat $DATASETS/parallel.$dim.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $4}'| paste -d "," - - >> $DATASETS/parallel.$dim.eap.csv
    
    ebp_train=$(cat $DATASETS/parallel.$dim.ebp.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    ebp_test=$(cat $DATASETS/parallel.$dim.ebp.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    eap_train=$(cat $DATASETS/parallel.$dim.eap.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    eap_test=$(cat $DATASETS/parallel.$dim.eap.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    echo "$dim, $ebp_train, $ebp_test, $eap_train, $eap_test" >> $DATASETS/parallel.error.avg

done
