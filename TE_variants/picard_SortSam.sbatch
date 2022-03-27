#!/bin/bash

# Script for running picard SortSam

# Example usage:
# sbatch --array 0-329 picard_SortSam.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=24:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J SortSam
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=4

# Define path variables
tmpDir=java_tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Define query files
queries=($(ls *.bam | xargs -n 1 basename | sed 's/.bam//g' | uniq))

# Make temporary directory
pwd; hostname; date

echo "Picard SortSam version: "$(java -jar /opt/picard/2.6.0/picard-2.6.0.jar SortSam --version)

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}

echo "Making temporary directory..."

mkdir -p ${tmpDir}

# Run picard
echo $(date +"[%b %d %H:%M:%S] Sorting bam files with picard...")

java \
-Xmx8G -Djava.io.tmpdir=${tmpDir} -XX:ParallelGCThreads=${numThreads} \
-jar /opt/picard/2.6.0/picard-2.6.0.jar SortSam \
INPUT=${queries[$SLURM_ARRAY_TASK_ID]}.bam \
OUTPUT=${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam \
SORT_ORDER=coordinate \
VALIDATION_STRINGENCY=STRICT

echo $(date +"[%b %d %H:%M:%S] Done")