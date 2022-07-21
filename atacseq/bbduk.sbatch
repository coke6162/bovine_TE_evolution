#!/bin/bash

# Script for running bbduk with paired-end data
# 'adapters.fa' supplied through github repos

# Example usage:
# sbatch --array 0-3 bbduk.sbatch.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=2:00:00
#SBATCH --mem=8G

# Job name and output
#SBATCH -J bbduk
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=1

# Load module
module load bbmap/38.05

# Define query files
# Removes suffix to generate a unique identifier for each pair of files
# Modify to fit input file name if necessary
queries=($(ls *.fastq.gz | sed 's/_1.fastq.gz//g' | sed 's/_2.fastq.gz//g' | uniq))

# Define adapter file
adapterFile=/opt/bbmap/38.05/resources/adapters.fa

# Run bbduk
pwd; hostname; date

echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Running bbduk...")

bbduk.sh -Xmx8g \
in1=${queries[$SLURM_ARRAY_TASK_ID]}_1.fastq.gz \
in2=${queries[$SLURM_ARRAY_TASK_ID]}_2.fastq.gz \
out1=${queries[$SLURM_ARRAY_TASK_ID]}_1_trimmed.fastq.gz \
out2=${queries[$SLURM_ARRAY_TASK_ID]}_2_trimmed.fastq.gz \
ref=adapters.fa \
ktrim=r k=34 mink=11 hdist=1 tpe tbo \
qtrim=r trimq=10 \
t=${numThreads}

echo $(date +"[%b %d %H:%M:%S] Done")