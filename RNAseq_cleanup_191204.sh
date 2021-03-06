#!/usr/bin/env bash

################################################
# Program:
# RNAseq_cleanup_191204.sh
#
# Author:
# Erin Osborne Nishimura
#
# Date initiated:
# December, 04, 2019
#
# Description:
#
# This is a very basic pipeline to clean up the files generated from RNAseq_analyzer_181117.sh
#
# Requires: A metadata file with two columns. The first two columns are fastq file names. 
#           The third column is a "nickname" of each sample
#			Later columns can be included with other metadata information
#           Metadata file should be placed within the inputdir directory.
# 
# Executed with:
# bash RNAseq_cleanup_191204.sh
################################################

echo -e ">>> INITIATING cleanup with command:\n\t$0 $@"


####### MODIFY THIS SECTION #############

#The input samples (metadata file and _fastq.gz files) live in directory:
inputdir="<inputdir>"

#This is the output_directory:
#DATE=`date +%Y-%m-%d`
#OR
DATE=2019-12-04
outputdir="../../03_output/"$DATE"_output/"


########## DONE MODIFYING ###############





####### META DATA #############

# Read the metadata file and extract information out of it.

#These are the sample names, R1:
samples1=( $(cut -f 1 --output-delimiter=' ' $1) )

#These are the sample names, R2:
samples2=( $(cut -f 2 --output-delimiter=' ' $1) )

#These are the nicknames I want to give the files:
names=( $(cut -f 3 --output-delimiter=' ' $1) )




####### RE-ZIPPING #############

### REZIP ALL THE INPUT FILES: 

#echo -e ">>>Zipping files"
#for fastqfile in ${samples1[@]}
#do
#   echo -e "gzipping $fastqfile"
#   gzip $inputdir$fastqfile
#done
#for fastqfile in ${samples2[@]}
#do
#   echo -e "gzipping $fastqfile"
#   gzip $inputdir$fastqfile
#done




####### DELETING FILES #############

# Delete .sam files.  X.sam files are huge and redundant with _sort.bam files. 
echo -e "\n>>> DELETING .sam files. Ensuring that _sort.bam files exists and keeping it:"
outhisat2=$outputdir"03_hisat2/"
samout=$outputdir"05_samtools/"

for (( counter=0; counter < ${#names[@]}; counter++ ))
do
    echo -e ${names[$counter]}

done

for seqname in ${names[@]}
do
	# test whether the _sort.bam file exists
	sortbamfile=${samout}${seqname}_sort.bam
	if [ -s  $sortbamfile ] 
	then
		# remove the .sam file
		echo -e "\t$ rm ${outhisat2}${seqname}.sam"
		rm ${outhisat2}${seqname}.sam
	fi
done


# Delete .bam files.  X.bam files are not necessary when we have smaller _sort.bam files. 
echo -e "\n>>> DELETING .bam files. Ensuring that _sort.bam files exists and keeping it:"


for seqname in ${names[@]}
do
	# test whether the _sort.bam file exists
	sortbamfile=${samout}${seqname}_sort.bam
	if [ -s  $sortbamfile ] 
	then
		# Delete the .bam file
		echo -e "\t$ rm ${samout}${seqname}.bam"
		rm ${samout}${seqname}.bam
	fi
done


echo -e "\n>>> END PROGRAM: Clean up is complete."
