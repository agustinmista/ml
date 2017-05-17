#!/bin/bash

DATASET=datasets/dos_elipses
BASENAME=$DATASET/dos_elipses

BP=./bp

ITERATIONS=20

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
            awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }')
    
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

for mom in 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9
do
    for lr in 0.1 0.4 0.7 0.01 0.04 0.07 0.001
    do
        echo "======== TRANING BATCH [LR=$lr, MOM=$mom] ========"
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

    
