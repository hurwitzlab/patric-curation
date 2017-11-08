#!/usr/bin/env bash
#
# Script to submit fastas to phaster.ca for phage identification
#

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=100

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

if [[ -d "$PHASTER_OUT_DIR" ]]; then
    echo "Continuing where you left off..."
else
    mkdir -p "$PHASTER_OUT_DIR"
fi

#doing complete genomes first ~9,000 / 100 = 90 subjobs 
cd "$COMPLETE_DIR"

export FILES_LIST="$PRJ_DIR/fna_files"

echo "Finding genomes"

find . -type f -iname "*.fna" | sed "s/^\.\///" > $FILES_LIST 

echo "Checking if already processed"

if [ -e $PRJ_DIR/todo_list ]; then
    rm $PRJ_DIR/todo_list
fi

export FILES_TO_PROCESS="$PRJ_DIR/todo_list"

while read FASTA; do
    
    BASE=$(basename $FASTA .fna)

    OUT_DIR=$PHASTER_OUT_DIR/$BASE

    if [[ -d $OUT_DIR ]]; then
        if [[ -z $(find $OUT_DIR -iname detail.txt) ]]; then
            echo $FASTA >> $FILES_TO_PROCESS
        else
            continue
        fi
    else
        echo $FASTA >> $FILES_TO_PROCESS
    fi

done < $FILES_LIST

NUM_FILES=$(lc $FILES_TO_PROCESS)

echo \"Found $NUM_FILES to process\"

#JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N taxoner -j oe -o "$STDOUT_DIR" $WORKER_DIR/run-taxoner-se.sh)
#
#if [ $? -eq 0 ]; then
#  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: time you enjoy wasting is not wasted time.
#else
#  echo -e "\nError submitting job\n$JOB\n"
#fi
#
