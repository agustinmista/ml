#!/bin/bash

DATASET=datasets/sunspots
BASENAME=$DATASET/ssp

BP=./bp-wd

ITERATIONS=20

# create_netfile $iter $wd
function create_netfile {
    
    PREFIX=$BASENAME.$1.$2
    
    rm -f $PREFIX.net
    
    for arg in 12 6 1 180 180 107 100000 0.01 0.3 200 0 $RANDOM 0 $2    
    do 
        echo $arg >> $PREFIX.net 
    done
}

# train $iter $wd
function train {
    PREFIX=$BASENAME.$1.$2
   
    echo "Training [ITER=$1, WD=$2, PREFIX=$PREFIX] started"
    ln -f $BASENAME.data $PREFIX.data 
    ln -f $BASENAME.test $PREFIX.test 
    
    $BP $PREFIX &> $PREFIX.report;
    echo "Training [ITER=$1] finished"
}


# generate_avg_mse $wd
function generate_avg_mse {
    echo "Generating $BASENAME.$1.mse.avg"
    
    awk '{rows=FNR; cols=NF; for (i = 1; i <= NF; i++) { total[FNR, i] += $i }}
         FILENAME != lastfn { count++; lastfn = FILENAME }
         END { 
            for (i = 1; i <= rows; i++) { 
                for (j =  1; j <= cols; j++) printf("%s ", total[i, j]/count)
                printf("\n")
            }
    }' $BASENAME.*.$1.mse > $BASENAME.$1.mse.avg

}

# append_dicrete_error $wd
function append_test_error {

    ERROR=$(grep -h Test: $BASENAME.*.$1.report |
            awk -F ':' '{gsub(/(%| )/,""); print $2}' |
            sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }') 
    
    echo "$1, $ERROR" >> $BASENAME.error

}


###########################
##         MAIN          ##
###########################
rm -f $DATASET/*.mse
rm -f $DATASET/*.avg
rm -f $DATASET/*.report
rm -f $DATASET/*.net
rm -f $DATASET/*.error*

for wd in 1 0.1 0.01 0.001 0.0001 0.00001 0.000001 0.0000001 0.00000001
do
    echo "======== TRANING BATCH [WD=$wd] ========"
    for i in $(seq 1 $ITERATIONS)
    do
        create_netfile $i $wd
        train $i $wd &
        sleep 0.1
    done
    wait
    generate_avg_mse $wd
    append_test_error $wd
done

echo "Finished!"   
