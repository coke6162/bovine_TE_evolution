#!/bin/bash

# Script for merging s1, s2, s3, and s4 bam files

# Example usage:
# sbatch --array 0-13 merge_bams.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --time=12:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J merge_bams
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Email notifications
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=identikey@colorado.edu

# Set constant variables
numThreads=2

# Load modules
module load samtools/1.10

# Define query files
# Note that this expects technical replicates to be defined with a common pattern
# Technical replicate #1 should be named sample_s1.sorted.uniq.bam, technical replicate #2 sample_s2.sorted.uniq.bam, etc.
queries=($(ls *_s[0-9].sorted.uniq.bam | sed 's/_s.*//g' | uniq))

# Define path variables
tmpDir=tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Make temporary directory
pwd; hostname; date

echo "Making temporary directory..."

mkdir -p ${tmpDir}

# Write a temporary file containing input bams (one per line)
echo $(date +"[%b %d %H:%M:%S] Writing temporary bamlist file...")

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}

ls ${queries[$SLURM_ARRAY_TASK_ID]}*.sorted.uniq.bam \
| tr ' ' '\n' \
> ${queries[$SLURM_ARRAY_TASK_ID]}_bamlist.txt.tmp

# Merge bam files
echo $(date +"[%b %d %H:%M:%S] Merging bam files...")

samtools merge \
-@ ${numThreads} \
-b ${queries[$SLURM_ARRAY_TASK_ID]}_bamlist.txt.tmp \
${queries[$SLURM_ARRAY_TASK_ID]}_merged.uniq.bam.tmp

# Sort merged bam file
echo $(date +"[%b %d %H:%M:%S] Sorting merged bam file...")

samtools sort \
-@ ${numThreads} \
-T ${tmpDir} \
${queries[$SLURM_ARRAY_TASK_ID]}_merged.uniq.bam.tmp \
> ${queries[$SLURM_ARRAY_TASK_ID]}_merged.sorted.uniq.bam

# Index merged bam file
echo $(date +"[%b %d %H:%M:%S] Indexing merged bam file...")

samtools index \
-@ ${numThreads} \
${queries[$SLURM_ARRAY_TASK_ID]}_merged.sorted.uniq.bam \
> ${queries[$SLURM_ARRAY_TASK_ID]}_merged.sorted.uniq.bam.bai

# Remove unmerged bams
echo $(date +"[%b %d %H:%M:%S] Removing unmerged bams...")

rm ${queries[$SLURM_ARRAY_TASK_ID]}*_s[0-9].sorted.uniq.bam

# Remove intermediate files
echo $(date +"[%b %d %H:%M:%S] Removing intermediate files...")

rm ${queries[$SLURM_ARRAY_TASK_ID]}_bamlist.txt.tmp
rm ${queries[$SLURM_ARRAY_TASK_ID]}_merged.uniq.bam.tmp
rm -r ${tmpDir}/

echo $(date +"[%b %d %H:%M:%S] Done")