#!/bin/bash

UNIVERSE_SIZE=10000
DIMS=5
SIZE=250

DATASETS=datasets/parallel_noise
TESTFILE=$DATASETS/testfile

PARALLEL_GEN=../gen/parallel
DTREE_GEN=./c4.5
BAYES=./bayes_error_parallel.R

mkdir -p $DATASETS
rm -rf $DATASETS/*

echo "c, ebp_train, ebp_test, eap_train, eap_test, bayes" >> $DATASETS/parallel.error.avg

for c in 0.5 1.0 1.5 2.0 2.5
do
    echo "========================================"
    echo "Training with C=$c"

    echo "Generating universe with d=$DIMS  size=$UNIVERSE_SIZE  C=$c"
    $PARALLEL_GEN $DIMS $UNIVERSE_SIZE $c $TESTFILE


	for i in $(seq 1 20)
	do
	    echo "Training dataset number $i"
	    ln -f $TESTFILE.data $DATASETS/parallel.$c.$i.test
	    $PARALLEL_GEN $DIMS $SIZE $c $DATASETS/parallel.$c.$i
	    $DTREE_GEN -u -f $DATASETS/parallel.$c.$i | grep "<<" &>> $DATASETS/parallel.$c.raw
        $BAYES $DATASETS/parallel.$c.$i.data >> $DATASETS/parallel.$c.bayes
        sleep 1
    done

    echo "Generating error file report."
    cat $DATASETS/parallel.$c.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $2}'| paste -d "," - - >> $DATASETS/parallel.$c.ebp.csv
    cat $DATASETS/parallel.$c.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $4}'| paste -d "," - - >> $DATASETS/parallel.$c.eap.csv
    
    ebp_train=$(cat $DATASETS/parallel.$c.ebp.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    ebp_test=$(cat $DATASETS/parallel.$c.ebp.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    eap_train=$(cat $DATASETS/parallel.$c.eap.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    eap_test=$(cat $DATASETS/parallel.$c.eap.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    bayes=$(cat $DATASETS/parallel.$c.bayes | awk '{sum+=$1; ++n} END {print sum/n}')
    echo "$c, $ebp_train, $ebp_test, $eap_train, $eap_test, $bayes" >> $DATASETS/parallel.error.avg

done
