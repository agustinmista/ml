#!/bin/bash

DATASET=datasets/parallel
BASENAME=$DATASET/parallel

BAYES=./nb_n

ITERATIONS=20

# create_netfile $iter $n1
function create_netfile {
    
    PREFIX=$BASENAME.$1.$2
    
    rm -f $PREFIX.nb
    
    for arg in $2 2 250 200 10000 $RANDOM 0 
    do 
        echo $arg >> $PREFIX.nb 
    done
}

# train $iter $n1
function train {
    PREFIX=$BASENAME.$1.$2
   
    echo "Training [ITER=$1, N1=$2, PREFIX=$PREFIX] started"
    ln -f $BASENAME.$2.data $PREFIX.data 
    ln -f $BASENAME.$2.test $PREFIX.test 
    
    $BAYES $PREFIX &> $PREFIX.report;
    echo "Training [ITER=$1] finished"
}


# append_dicrete_error $n2
function append_discrete_error {

    TRAIN=$(grep -h Entrenamiento: $BASENAME.*.$1.report |
            awk -F ':' '{gsub(/(%| )/,""); print $2}' |
            sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }') 
    
    TEST=$(grep -h Test: $BASENAME.*.$1.report |
            awk -F ':' '{gsub(/(%| )/,""); print $2}' |
            sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }') 

    echo "$1, $TRAIN, $TEST" >> $BASENAME.error.bayes

}


###########################
##         MAIN          ##
###########################
rm -f $DATASET/*.mse
rm -f $DATASET/*.avg
rm -f $DATASET/*.report
rm -f $DATASET/*.net
rm -f $DATASET/*.error.discrete

for n1 in 2 4 8 16 32
do
    echo "======== TRANING BATCH [N1=$n2] ========"
    for i in $(seq 1 $ITERATIONS)
    do
        create_netfile $i $n1
        train $i $n1 &
        sleep 0.1
        
    done
    wait
    append_discrete_error $n1
done

echo "Finished!"

    
