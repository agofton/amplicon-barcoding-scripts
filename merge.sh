#!/bin/bash
#
# Require usearch10 to be installed on $PATH or else mod script to specift complete path to usearch10
#
# Usage
#
# $ merge.sh [raw data dir] [output dir] [min alignment overlap: Int] [min merged length: Int]
#
################################################################################
################################################################################

raw_data_dir=${1?Error: raw data directory not given}
merged_data_dir=${2?Error: output diretory not given}
min_overlap=${3?Error: min overlap not given}
min_len=${4?Error: min merged length no given}

mkdir ${merged_data_dir}
mkdir working1
for file in ${raw_data_dir}/*R1_001.fastq
  do

usearch10 -fastq_mergepairs ${file} \
-reverse "${raw_data_dir}/$(basename -s R1_001.fastq ${file})R2_001.fastq" \
-fastqout "working1/$(basename -s L001_R1_001.fastq "$file")merged.fastq" \
-fastq_minovlen ${min_overlap} \
-fastq_minmergelen ${min_len} \
-fastq_maxdiffs 50 \
-fastq_pctid 40 \
-relabel @

  done

# Filter PhiX

for file in working1/*.fastq
  do
    usearch10 -filter_phix ${file} -output "${merged_data_dir}/$(basename ${file})"
  done

rm -r working1
################################################################################
################################################################################
