#!/bin/bash

DATASET=datasets/dos_elipses
BASENAME=$DATASET/dos_elipses

BP=./bp

ITERATIONS=11

# create_netfile $iter $lr $mom
function create_netfile {
    
    PREFIX=$BASENAME.$1.$2.$3
    
    rm -f $PREFIX.net
    
    for arg in 2 6 1 500 400 2000 40000 $2 $3 400 0 $RANDOM 0 
    do 
        echo $arg >> $PREFIX.net 
    done
}

# train $iter $lr $mom
function train {
    PREFIX=$BASENAME.$1.$2.$3
   
    echo "Training [ITER=$1, LR=$2, MOM=$3, PREFIX=$PREFIX] started"
    ln -f $BASENAME.data $PREFIX.data 
    ln -f $BASENAME.test $PREFIX.test 
    
    $BP $PREFIX &> $PREFIX.report;
    echo "Training [ITER=$1] finished"
}


# generate_avg_mse $lr $mom
function generate_avg_mse {
    echo "Generating $BASENAME.$1.$2.mse.avg"
    
    awk '{rows=FNR; cols=NF; for (i = 1; i <= NF; i++) { total[FNR, i] += $i }}
         FILENAME != lastfn { count++; lastfn = FILENAME }
         END { 
            for (i = 1; i <= rows; i++) { 
                for (j =  1; j <= cols; j++) printf("%s ", total[i, j]/count)
                printf("\n")
            }
    }' $BASENAME.*.$1.$2.mse > $BASENAME.$1.$2.mse.avg

}

# append_dicrete_error $lr $mom
function append_discrete_error {

    ERROR=$(grep -h discreto $BASENAME.*.$1.$2.report |
            awk -F ':' '{gsub(/(%| )/,""); print $2}' |
            sort -n | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }') 

    echo "$1, $2, $ERROR" >> $BASENAME.error.discrete

}


###########################
##         MAIN          ##
###########################
rm -f $DATASET/*.mse
rm -f $DATASET/*.avg
rm -f $DATASET/*.report
rm -f $DATASET/*.net
rm -f $DATASET/*.error*

for mom in $(seq 0 0.05 0.95)
do
    for lr in 0.1000 0.0794 0.0631 0.0501 0.0398 0.0316 0.0251 0.0200 0.0158 0.0126 0.0100 0.0079 0.0063 0.0050 0.0040 0.0032 0.0025 0.0020 0.0016 0.0013 0.0010 
    do
        echo $lr
        echo "======== traning batch [lr=$lr, mom=$mom] ========"
        for i in $(seq 1 $ITERATIONS)
        do
            create_netfile $i $lr $mom
            train $i $lr $mom &
            sleep 0.1
        done
        wait
        generate_avg_mse $lr $mom
        append_discrete_error $lr $mom
    done
done

echo "Finished!"

    
