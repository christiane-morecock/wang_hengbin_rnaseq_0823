#!usr/bin/env bash
#########################
##  execute script in current directory
#$ -cwd

##  any .e/.o to show up here
#$ -e ./logs/
#$ -o ./logs/

## Shell for qsub to use
#$ -S /bin/bash

##  Name the job
#$ -N batch_2

##  Verbose
#$ -V

##  email
#$ -M morecockcm@vcu.edu
#$ -m beas

##  Memory and cpu slots
#$ -l mem_free=2G
#$ -pe smp 4

##  Job array
#$ -t 1-4:1



for file in align_sh/*;
do
	qsub "${file[SGE_TASK_ID - 1]}"
done

