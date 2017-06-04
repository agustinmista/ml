#!/bin/bash

DATASET=datasets/parallel
BASENAME=$DATASET/parallel

BP=./bp

ITERATIONS=20

# create_netfile $iter $n1
function create_netfile {
    
    PREFIX=$BASENAME.$1.$2
    
    rm -f $PREFIX.net
    
    for arg in $2 6 1 250 200 10000 40000 0.01 0.5 400 0 $RANDOM 0 
    do 
        echo $arg >> $PREFIX.net 
    done
}

# train $iter $n1
function train {
    PREFIX=$BASENAME.$1.$2
   
    echo "Training [ITER=$1, N1=$2, PREFIX=$PREFIX] started"
    ln -f $BASENAME.$2.data $PREFIX.data 
    ln -f $BASENAME.$2.test $PREFIX.test 
    
    $BP $PREFIX &> $PREFIX.report;
    echo "Training [ITER=$1] finished"
}


# generate_avg_mse $n1
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
    generate_avg_mse $n1
    append_discrete_error $n1
done

echo "Finished!"

    
