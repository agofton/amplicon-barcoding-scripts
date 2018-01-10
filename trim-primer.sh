#!/bin/bash
#
# Require usearch10  and usearch8 to be installed on $PATH or else mod script to specift complete path to usearch10/8
#
# Usage
#
# $ trim_primers.sh [raw data dir] [output dir] [fwd primer seq 5-3] [rev primer seq 5-3] [num missmatches: Int(defult=2)]
#
################################################################################
################################################################################

# Defining varibles
  input_dir=${1?Error: no input directory given}
  output_dir=${2?Error: no output director given}
  fwd_seq=${3?Error: no fwd primer seq given}
  rev_seq=${4?Error: no rev primer seq given}
  missmatches=${5:-2} #defult is 2

# Creating working folders
  mkdir trimming_working_files
  mkdir trimming_working_files/seqs_w_fwd_primer
  mkdir trimming_working_files/seqs_wo_fwd_primer
  mkdir trimming_working_files/seqs_w_fwd_and_rev_primer
  mkdir trimming_working_files/seqs_w_fwd_wo_rev_primer
  mkdir ${output_dir}

# Creating primer databases
# fwd
  echo ">fwd_primer" > trimming_working_files/fwd_primer_db.fasta
  echo ${fwd_seq} >> trimming_working_files/fwd_primer_db.fasta

# rev
  echo ">rev_primer" > trimming_working_files/rev_primer_db.fasta
  echo ${rev_seq} >> trimming_working_files/rev_primer_db.fasta

# fwd and rev
  echo ">fwd_primer" > trimming_working_files/both_primers_db.fasta
  echo ${fwd_seq} >> trimming_working_files/both_primers_db.fasta
  echo ">rev_primer" >> trimming_working_files/both_primers_db.fasta
  echo ${rev_seq} >> trimming_working_files/both_primers_db.fasta

# Finding seqs with fwd primers
for file in ${input_dir}/*.fasta
  do
    usearch10 -search_oligodb ${file} -db trimming_working_files/fwd_primer_db.fasta -strand both -matched "trimming_working_files/seqs_w_fwd_primer/$(basename ${file})" -notmatched "trimming_working_files/seqs_wo_fwd_primer/$(basename ${file})" -maxdiffs ${missmatches}
    echo ""
  done

# Finding seq with fwd and rev primers
for file in trimming_working_files/seqs_w_fwd_primer/*.fasta
  do
    usearch10 -search_oligodb ${file} -db trimming_working_files/rev_primer_db.fasta -strand both -matched "trimming_working_files/seqs_w_fwd_and_rev_primer/$(basename ${file})" -notmatched "trimming_working_files/seqs_w_fwd_and_rev_primer/$(basename ${file})" -maxdiffs ${missmatches}
    echo ""
  done

# Trimming primer seqs
for file in trimming_working_files/seqs_w_fwd_and_rev_primer/*.fasta
  do

    usearch8 -search_pcr ${file} -db trimming_working_files/both_primers_db.fasta -strand both -maxdiffs ${missmatches} -pcr_strip_primers -ampout "${output_dir}/$(basename ${file})"

    echo ""
  done

################################################################################
################################################################################
