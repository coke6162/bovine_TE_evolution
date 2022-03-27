#!/bin/bash

# Script for running picard MergeSamFiles

# Example usage:
# sbatch --array 0-37 picard_MergeSam.sbatch

## General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=24:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J MergeSam
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=4

# Define path variables
tmpDir=java_tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Define query samples
# This assumes your samples are uniquely identified at the start, followed by an underscore
# If no underscore (i.e. sampleName.sorted.bam), this will also remove everything after the first "."
# i.e. "Limousin1_run1_lane1.sorted.bam"
queries=($(ls *.sorted.bam | xargs -n 1 basename | cut -d_ -f1 | cut -d. -f1 | sort | uniq))

# Make temporary directory
pwd; hostname; date

echo "Picard MergeSamFiles version: "$(java -jar /opt/picard/2.6.0/picard-2.6.0.jar MergeSamFiles --version)

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}

echo "Making temporary directory..."

mkdir -p ${tmpDir}

# Create a text file specifying all bam files to merge
# This will put "INPUT=" in front of each file (needed to run Picard MergeSamFiles)
# This works if all your samples share a common suffix & end in ".bam"
echo $(date +"[%b %d %H:%M:%S] Creating a txt file giving names of all files to merge...")

ls | grep "^${queries[$SLURM_ARRAY_TASK_ID]}.*bam$" - > ${queries[$SLURM_ARRAY_TASK_ID]}_merge_list.txt.tmp
sed 's,^,INPUT='"./"'\/,g' ${queries[$SLURM_ARRAY_TASK_ID]}_merge_list.txt.tmp > ${queries[$SLURM_ARRAY_TASK_ID]}_merge_list.txt
rm ${queries[$SLURM_ARRAY_TASK_ID]}_merge_list.txt.tmp

# Run Picard MergeSamFiles
echo $(date +"[%b %d %H:%M:%S] Merging bam files with picard...")

java \
-Xmx8G -Djava.io.tmpdir=${tmpDir} -XX:ParallelGCThreads=${numThreads} \
-jar /opt/picard/2.6.0/picard-2.6.0.jar MergeSamFiles \
$(cat ${queries[$SLURM_ARRAY_TASK_ID]}_merge_list.txt) \
OUTPUT=${queries[$SLURM_ARRAY_TASK_ID]}_merged.bam \
SORT_ORDER=coordinate ASSUME_SORTED=true \
USE_THREADING=true \
MERGE_SEQUENCE_DICTIONARIES=true CREATE_INDEX=true \
VALIDATION_STRINGENCY=STRICT

echo $(date +"[%b %d %H:%M:%S] Done")