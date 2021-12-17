#!/bin/bash

# Script for generating fastq quality control reports

# Example usage:
# sbatch --array 0-137 fastqc.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --time=1:00:00
#SBATCH --mem=4GB

# Job name and output
#SBATCH -J fastqc
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Load FastQC
module load fastqc/0.11.8

# Define constant variables
numThreads=2

# Define query files
queries=($(ls *.fastq.gz))

# Run FastQC
pwd; hostname; date

echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Running fastqc on fastq files...")

fastqc -o fastqc_out -f fastq -t ${numThreads} ${queries[$SLURM_ARRAY_TASK_ID]}

echo $(date +"[%b %d %H:%M:%S] Done")