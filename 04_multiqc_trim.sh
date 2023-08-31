#!/usr/bin/env bash
#####################################################
##  execute script in current directory
#$ -cwd

##  any .e/.o to show up here
#$ -e ./logs/
#$ -o ./logs/

## Shell for qsub to use
#$ -S /bin/bash

##  Name the job
#$ -N qc_raw

##  Verbose
#$ -V

##  email
#$ -M morecockcm@vcu.edu
#$ -m beas

## Memory and cpu slots
#$ -l mem_free=2G
#$ -pe smp 6
#################################################
START=$(date +%s)
#######################################################
INPUT_DIR=$(pwd)/merged_files/fastq/
OUTPUT_DIR=$(pwd)/output/fastqc_merged/
#--------------------------------------------
# Files to process 
#----
FASTA_FILES=$(find $INPUT_DIR -type f -name "*.gz" -print | sort | tr '\n' ' ')
#--------------------------------------------

source /vcu_gpfs2/home/mccbnfolab/enable_pyenv.sh

FASTQC=/vcu_gpfs2/home/mccbnfolab/RNA-seq-pipeline/FastQC/fastqc

mkdir -p $OUTPUT_DIR

$FASTQC -o $OUTPUT_DIR -t 8 $FASTA_FILES

## Generate MultiQC report
pushd $OUTPUT_DIR
multiqc .
popd
##############################################################
END=$(date +%s)
touch $OUTPUT_DIR/timelapsed.txt
echo "Elapsed Time: $(($END-$START))" >> $OUTPUT_DIR/timelapsed.txt

