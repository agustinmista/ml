#!/bin/bash

DATASET=datasets/ikeda
BASENAME=$DATASET/ikeda

BP=./bp

ITERATIONS=20

# create_netfile $iter $ts
function create_netfile {
    
    PREFIX=$BASENAME.$1.$2
    
    rm -f $PREFIX.net
    
    for arg in 5 40 1 100 $2 2000 20000 0.01 0.3 200 0 $RANDOM 0 
    do 
        echo $arg >> $PREFIX.net 
    done
}

# train $iter $ts
function train {
    PREFIX=$BASENAME.$1.$2
   
    echo "Training [ITER=$1, TS=$2, PREFIX=$PREFIX] started"
    ln -f $BASENAME.data $PREFIX.data 
    ln -f $BASENAME.test $PREFIX.test 
    
    $BP $PREFIX &> $PREFIX.report;
    echo "Training [ITER=$1] finished"
}


# generate_avg_mse $ts
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

# append_dicrete_error $ts
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

for ts in 95 75 50
do
    echo "======== TRANING BATCH [TS=$ts] ========"
    for i in $(seq 1 $ITERATIONS)
    do
        create_netfile $i $ts
        train $i $ts &
        sleep 0.1
        
    done
    wait
    generate_avg_mse $ts
    append_test_error $ts
done

echo "Finished!"   
