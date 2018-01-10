#!/bin/bash
#
# Require usearch10 to be installed on $PATH or else mod script to specift complete path to usearch10
#
# Usage
#
# $ filter.sh [input dir-merged data)] [output dir] [error rate:float]
#
################################################################################
################################################################################

input_dir=${1?Error: no input directory given}
QF=${2?Error: no output directory given}
error_rate=${3:-0.5}

mkdir ${QF}

for file in ${input_dir}/*.fastq
  do

usearch10 -fastq_filter ${file} -fastaout "${QF}/$(basename "$file" .fastq)_QF.fasta" -fastq_maxee_rate ${error_rate}

done

################################################################################
################################################################################
