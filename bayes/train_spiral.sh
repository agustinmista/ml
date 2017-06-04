#!/bin/bash

DATASET=datasets/spiral
BASENAME=$DATASET/spiral

BAYES=./nb_n

ITERATIONS=20

# create_netfile $iter
function create_netfile {
    
    PREFIX=$BASENAME.$1
    
    rm -f $PREFIX.nb
    
    for arg in 2 2 2000 1600 2000 $RANDOM 0 
    do 
        echo $arg >> $PREFIX.nb 
    done
}

# train $iter
function train {
    PREFIX=$BASENAME.$1
   
    echo "Training [ITER=$1, PREFIX=$PREFIX] started"
    ln -f $BASENAME.data $PREFIX.data 
    ln -f $BASENAME.test $PREFIX.test 
    
    $BAYES $PREFIX &> $PREFIX.report;
    echo "Training [ITER=$1] finished"
}


# append_dicrete_error
function append_discrete_error {

    TRAIN=$(grep -h Entrenamiento: $BASENAME.*.report |
            awk -F ':' '{gsub(/(%| )/,""); print $2}' |
            sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }') 
    
    TEST=$(grep -h Test: $BASENAME.*.report |
            awk -F ':' '{gsub(/(%| )/,""); print $2}' |
            sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }') 

    echo "$TRAIN, $TEST" >> $BASENAME.error.discrete

}


###########################
##         MAIN          ##
###########################
rm -f $DATASET/*.mse
rm -f $DATASET/*.avg
rm -f $DATASET/*.report
rm -f $DATASET/*.net
rm -f $DATASET/*.error.discrete

echo "======== TRANING BATCH ========"
for i in $(seq 1 $ITERATIONS)
do
    create_netfile $i
    train $i &
    sleep 0.1
    
done
wait
append_discrete_error

echo "Finished!"

    
