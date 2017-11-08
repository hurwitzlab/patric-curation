#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=1:mem=2gb
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

CONFIG="$SCRIPT_DIR/config.sh"

if [ -e $CONFIG ]; then
  . "$CONFIG"
else
  echo Missing config \"$CONFIG\"
  exit 1
fi

TMP_FILES=$(mktemp)

get_lines $FILES_TO_PROCESS $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Found \"$NUM_FILES\" files to process

while read FASTA; do
   
    BASE=$(basename $FASTA .fna)

    FULLPATH=$COMPLETE_DIR/$FASTA

    echo $0 is submitting $FULLPATH
    echo $0 is outputting to $PHASTER_OUT_DIR
    echo $0 is extracting resultant "$BASE".zip

    $WORKER_DIR/Phaster.ipy -i $FULLPATH -o $PHASTER_OUT_DIR -x

    if [ ! -e "$PHASTER_OUT_DIR"/"$BASE".zip ]; then
        echo Something went majorly wrong and didnt even make a zipfile
        echo Exiting before breaking anything further \(and wasting time\)
        exit 1
    fi
   
done < "$TMP_FILES"


