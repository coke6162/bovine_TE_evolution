#!/bin/bash

# Script for running bwa
# bwa index located in a subdirectory named "index" (not supplied)
# 'ARS-UCD1.2_Btau5.0.1Y.fa' available at https://sites.ualberta.ca/~stothard/1000_bull_genomes/

# Example usage:
# sbatch --array 0-329 bwa_mem.sbatch

## General settings
#SBATCH -p long
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=3-0:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J bwa_mem
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Load modules
module load bwa/0.7.15 samtools/1.10

# Set constant variables
numThreads=4

# Define query files
# This will include all identifying information except for the file suffix
# Modify sed arguments to fit your naming system (i.e. R1 instead of 1)
queries=($(ls *.fastq | xargs -n 1 basename | sed 's/_1.fastq//g' | sed 's/_2.fastq//g' | uniq))

# Set sample variable (i.e. Limousin2)
# This stores everything up to the first underscore as the sample information
# For example, this will work with 'Limousin2_run1_lane1'
sample=$(echo ${queries[$SLURM_ARRAY_TASK_ID]} | cut -d _ -f 1)

# Run bwa
pwd; hostname; date

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Aligning reads to the genome...")

bwa mem \
-M -t ${numThreads} \
-R "@RG\tID:${queries[$SLURM_ARRAY_TASK_ID]}\tLB:IlluminaExome\tPL:ILLUMINA\tSM:${sample}" \
index/ARS-UCD1.2_Btau5.0.1Y \
${queries[$SLURM_ARRAY_TASK_ID]}_1.fastq \
${queries[$SLURM_ARRAY_TASK_ID]}_2.fastq \
| samtools view -@ ${numThreads} -Sb > ${queries[$SLURM_ARRAY_TASK_ID]}.bam

echo $(date +"[%b %d %H:%M:%S] Done")