#!/bin/bash

# Script for running MELT Preprocess

# 'ARS-UCD1.2_Btau5.0.1Y.fa' available at https://sites.ualberta.ca/~stothard/1000_bull_genomes/

# Example usage:
# sbatch --array 0-37 MELT_Insertion_Preprocess.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=24:00:00
#SBATCH --mem=4GB

# Job name and output
#SBATCH -J Preprocess
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=1

# Define path variables
tmpDir=java_tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Define query files
queries=($(ls *_merged_marked.bam | xargs -n 1 basename))

# Load modules
module load bowtie/2.2.9 samtools/1.10

# Make temporary directory
pwd; hostname; date

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}

echo "Making temporary directories..."

mkdir -p ${tmpDir}

# Run MELT
echo $(date +"[%b %d %H:%M:%S] Preprocessing bams with MELT...")

java \
-Xmx4G -Djava.io.tmpdir=${tmpDir} -XX:ParallelGCThreads=${numThreads} \
-jar /Shares/CL_Shared/programs/MELTv2.1.5/MELT.jar Preprocess \
-bamfile ${queries[$SLURM_ARRAY_TASK_ID]} \
-h ARS-UCD1.2_Btau5.0.1Y.fa

echo $(date +"[%b %d %H:%M:%S] Done")