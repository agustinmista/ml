#!/bin/bash

DATASET=datasets/spiral
BASENAME=$DATASET/spiral

BP=./bp

ITERATIONS=20

# create_netfile $iter $n2
function create_netfile {
    
    PREFIX=$BASENAME.$1.$2
    
    rm -f $PREFIX.net
    
    for arg in 2 $2 1 2000 1600 2000 40000 0.01 0.5 400 0 $RANDOM 0 
    do 
        echo $arg >> $PREFIX.net 
    done
}

# train $iter $n2
function train {
    PREFIX=$BASENAME.$1.$2
   
    echo "Training [ITER=$1, N2=$2, PREFIX=$PREFIX] started"
    ln -f $BASENAME.data $PREFIX.data 
    ln -f $BASENAME.test $PREFIX.test 
    
    $BP $PREFIX &> $PREFIX.report;
    echo "Training [ITER=$1] finished"
}


# generate_avg_mse $n2
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

# append_dicrete_error $n2
function append_discrete_error {

    ERROR=$(grep -h discreto $BASENAME.*.$1.report |
            awk -F ':' '{gsub(/(%| )/,""); print $2}' |
            sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }') 
    
    echo "$1, $ERROR" >> $BASENAME.error.discrete

}


###########################
##         MAIN          ##
###########################
rm -f $DATASET/*.mse
rm -f $DATASET/*.avg
rm -f $DATASET/*.report
rm -f $DATASET/*.net
rm -f $DATASET/*.error*

for n2 in 2 5 10 20 40
do
    echo "======== TRANING BATCH [N2=$n2] ========"
    for i in $(seq 1 $ITERATIONS)
    do
        create_netfile $i $n2
        train $i $n2 &
        sleep 0.1
        
    done
    wait
    generate_avg_mse $n2
    append_discrete_error $n2
done

echo "Finished!"

    
