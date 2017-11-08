export CWD=$PWD
export SCRIPT_DIR=$CWD
#root project dir
export PRJ_DIR="/rsgrps/bhurwitz/scottdaniel/patric-curation"
#where the worker scripts are (PBS batch scripts and their python/perl workdogs)
export WORKER_DIR="$SCRIPT_DIR/workers"

# IMPORTANT VARIABLES YOU NEED TO SET, YES YOU! 
#export SING_IMG="/rsgrps/bhurwitz/scottdaniel/singularity-images"
## Name of working directory within singularity image that will be mapped to SRA_DIR
#export SING_WD="/work"
##bt2 mapping directory for singularity container
#export SING_BT2="/bt2"

#Virsorter db
#export VSDATA="/rsgrps/bhurwitz/hurwitzlab/data/virsorter-data"

#Reference data
export REF_DIR="/rsgrps/bhurwitz/hurwitzlab/data/reference"
#Patric bacteria
export GENOME_DIR="$REF_DIR/patric_genomes"
#complete genomes
export COMPLETE_DIR="$GENOME_DIR/complete"
#wgs genomes
export WGS_DIR="$GENOME_DIR/wgs"
#phaster reports
export PHASTER_OUT_DIR="$GENOME_DIR/phaster_out"

#test in
#export TEST_IN_DIR="$PRJ_DIR/test_genomes"

#test out
#export TEST_OUT_DIR="$PRJ_DIR/test_phaster_out"

#GFFS (needed for prophET)
#export GFFS="$REF_DIR/patric_annot/gff"

#export BT2_DIR="$REF_DIR/patric_bowtie2_index"
#patric metadata including genome_lineage
#export META_DIR="$REF_DIR/patric_metadata"

###############################
#FUNCTIONS#####################
###############################
# --------------------------------------------------
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}

# --------------------------------------------------
function lc() {
    wc -l $1 | cut -d ' ' -f 1
}
# --------------------------------------------------
function get_lines() {
  FILE=$1
  OUT_FILE=$2
  START=${3:-1}
  STEP=${4:-1}

  if [ -z $FILE ]; then
    echo No input file
    exit 1
  fi

  if [ -z $OUT_FILE ]; then
    echo No output file
    exit 1
  fi

  if [[ ! -e $FILE ]]; then
    echo Bad file \"$FILE\"
    exit 1
  fi

  awk "NR==$START,NR==$(($START + $STEP - 1))" $FILE > $OUT_FILE
}
