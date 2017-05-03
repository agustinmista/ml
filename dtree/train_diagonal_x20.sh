#!/bin/bash

UNIVERSE_SIZE=10000
DATASETS=datasets/diagonal_x20
TESTFILE=$DATASETS/testfile

DIAGONAL_GEN=../gen/diagonal
DTREE_GEN=./c4.5
PLOTTER=../gen/plot.R

echo "Generating universe of size $UNIVERSE_SIZE"
mkdir -p $DATASETS
rm -r $DATASETS/*

$DIAGONAL_GEN 2 $UNIVERSE_SIZE 0.78 $TESTFILE
echo "size,ebp_train,ebp_test,eap_train,eap_test" >> $DATASETS/diagonal.error.avg
echo "size,sbp,sap" >> $DATASETS/diagonal.size.avg

for size in 100 200 300 500 1000 5000
do
	echo "Training with size $size"
	rm -f $DATASETS/diagonal.$size.values
	for i in $(seq 1 20)
	do
		echo "Training dataset number $i"
		ln -f $TESTFILE.data $DATASETS/diagonal.$size.$i.test
		$DIAGONAL_GEN 2 $size 0.78 $DATASETS/diagonal.$size.$i
		$DTREE_GEN -u -f $DATASETS/diagonal.$size.$i | grep "<<" &>> $DATASETS/diagonal.$size.raw
        sleep 1
	done

    echo "Generating Error/Tree size CSV file for size $size."
    cat $DATASETS/diagonal.$size.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $2}'| paste -d "," - - >> $DATASETS/diagonal.$size.ebp.csv
    cat $DATASETS/diagonal.$size.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $4}'| paste -d "," - - >> $DATASETS/diagonal.$size.eap.csv
    cat $DATASETS/diagonal.$size.raw | awk -F "[()]" '{print $1}' | awk '{print $1}' | awk 'NR%2==0' >> $DATASETS/diagonal.$size.sbp.csv
    cat $DATASETS/diagonal.$size.raw | awk -F "[()]" '{print $3}' | awk '{print $1}' | awk 'NR%2==0' >> $DATASETS/diagonal.$size.sap.csv
    
    ebp_train=$(cat $DATASETS/diagonal.$size.ebp.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    ebp_test=$(cat $DATASETS/diagonal.$size.ebp.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    eap_train=$(cat $DATASETS/diagonal.$size.eap.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    eap_test=$(cat $DATASETS/diagonal.$size.eap.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    echo "$size,$ebp_train,$ebp_test,$eap_train,$eap_test" >> $DATASETS/diagonal.error.avg

    sbp=$(cat $DATASETS/diagonal.$size.sbp.csv | awk '{sum+=$1} END {print sum/NR}')
    sap=$(cat $DATASETS/diagonal.$size.sap.csv | awk '{sum+=$1} END {print sum/NR}')
    echo "$size,$sbp,$sap" >> $DATASETS/diagonal.size.avg

done

