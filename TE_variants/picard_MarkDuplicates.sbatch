#!/bin/bash

# Script for running picard MarkDuplicates

# Example usage:
# sbatch --array 0-37 picard_MarkDuplicates.sbatch

# General settings
#SBATCH -p long
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --time=4-0:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J MarkDuplicates
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=8

# Define path variables
tmpDir=java_tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Define query files
queries=($(ls *_merged.bam | xargs -n 1 basename | sed 's/_merged.bam//g' | uniq))

# Make temporary directory
pwd; hostname; date

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}

echo "Making temporary directory..."

mkdir -p ${tmpDir}

# Run picard
echo $(date +"[%b %d %H:%M:%S] Marking duplicates with picard...")

java \
-Xmx8G -Djava.io.tmpdir=${tmpDir} -XX:ParallelGCThreads=${numThreads} \
-jar /opt/picard/2.6.0/picard-2.6.0.jar MarkDuplicates \
INPUT=${queries[$SLURM_ARRAY_TASK_ID]}_merged.bam \
OUTPUT=${queries[$SLURM_ARRAY_TASK_ID]}_merged_marked.bam \
METRICS_FILE=metrics/${queries[$SLURM_ARRAY_TASK_ID]}_merged_metrics.txt \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=STRICT \
OPTICAL_DUPLICATE_PIXEL_DISTANCE=2500

echo $(date +"[%b %d %H:%M:%S] Done")