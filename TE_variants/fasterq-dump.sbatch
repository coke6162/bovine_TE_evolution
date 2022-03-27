#!/bin/bash

# Script to download fastq files from sra and rename

# Example usage:
# sbatch --array 0-329 fasterq-dump.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=12:00:00
#SBATCH --mem=4GB

# Job name and output
#SBATCH -J fasterq-dump
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Load modules
module load sra/2.10.5

# Set temporary dir
tmpDir=tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Define query files
# This works with a txt file where the first column (starting with row #2) contains SRR IDs
# If your SRR IDs are in a column other than the first, modify the 'print $1' argument
# If you do not have a header, remove the 'NR>1' argument
queries=($(cat sample_names.txt | awk '(NR>1){print $1}'))

# Set variable for renaming
newName=$(grep -w ${queries[$SLURM_ARRAY_TASK_ID]} sample_names.txt | awk -F " " '{print $3}')

# Make temporary directory
pwd; hostname; date

echo "Making temporary directory..."

mkdir -p ${tmpDir}

# Run fastq-dump
echo $(date +"[%b %d %H:%M:%S] Downloading srr...")

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}

fasterq-dump \
--threads 1 \
--mem 8GB \
--temp ${tmpDir} \
--split-files ${queries[$SLURM_ARRAY_TASK_ID]}

# Remove temporary dir
echo $(date +"[%b %d %H:%M:%S] Removing temporary directory...")

rm -r ${tmpDir}

# Rename
echo $(date +"[%b %d %H:%M:%S] Renaming fastq files...")

mv ${queries[$SLURM_ARRAY_TASK_ID]}_1.fastq ${newName}_1.fastq
mv ${queries[$SLURM_ARRAY_TASK_ID]}_2.fastq ${newName}_2.fastq

echo $(date +"[%b %d %H:%M:%S] Done")