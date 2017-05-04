#!/bin/bash

UNIVERSE_SIZE=10000
DATASETS=datasets/parallel_sized
TESTFILE=$DATASETS/testfile

parallel_GEN=../gen/parallel
DTREE_GEN=./c4.5
PLOTTER=../gen/plot.R

echo "Generating universe of size $UNIVERSE_SIZE"
mkdir -p $DATASETS
rm -rf $DATASETS/*

$parallel_GEN 2 $UNIVERSE_SIZE 0.78 $TESTFILE
echo "size,ebp_train,ebp_test,eap_train,eap_test" >> $DATASETS/parallel.error.avg
echo "size,sbp,sap" >> $DATASETS/parallel.size.avg

for size in 100 200 300 500 1000 5000
do
	echo "Training with size $size"
	rm -f $DATASETS/parallel.$size.values
	for i in $(seq 1 20)
	do
		echo "Training dataset number $i"
		ln -f $TESTFILE.data $DATASETS/parallel.$size.$i.test
		$parallel_GEN 2 $size 0.78 $DATASETS/parallel.$size.$i
		$DTREE_GEN -u -f $DATASETS/parallel.$size.$i | grep "<<" &>> $DATASETS/parallel.$size.raw
        sleep 1
	done

    echo "Generating Error/Tree size CSV file for size $size."
    cat $DATASETS/parallel.$size.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $2}'| paste -d "," - - >> $DATASETS/parallel.$size.ebp.csv
    cat $DATASETS/parallel.$size.raw | awk -F "[()]" '{gsub(/(%| )/,""); print $4}'| paste -d "," - - >> $DATASETS/parallel.$size.eap.csv
    cat $DATASETS/parallel.$size.raw | awk -F "[()]" '{print $1}' | awk '{print $1}' | awk 'NR%2==0' >> $DATASETS/parallel.$size.sbp.csv
    cat $DATASETS/parallel.$size.raw | awk -F "[()]" '{print $3}' | awk '{print $1}' | awk 'NR%2==0' >> $DATASETS/parallel.$size.sap.csv
    
    ebp_train=$(cat $DATASETS/parallel.$size.ebp.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    ebp_test=$(cat $DATASETS/parallel.$size.ebp.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    eap_train=$(cat $DATASETS/parallel.$size.eap.csv | awk -F',' '{sum+=$1; ++n} END { print sum/n }') 
    eap_test=$(cat $DATASETS/parallel.$size.eap.csv | awk -F',' '{sum+=$2; ++n} END { print sum/n }') 
    echo "$size,$ebp_train,$ebp_test,$eap_train,$eap_test" >> $DATASETS/parallel.error.avg

    sbp=$(cat $DATASETS/parallel.$size.sbp.csv | awk '{sum+=$1} END {print sum/NR}')
    sap=$(cat $DATASETS/parallel.$size.sap.csv | awk '{sum+=$1} END {print sum/NR}')
    echo "$size,$sbp,$sap" >> $DATASETS/parallel.size.avg

done

