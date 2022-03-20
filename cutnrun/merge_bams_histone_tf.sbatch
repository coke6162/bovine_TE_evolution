#!/bin/bash

# Script for merging histone & tf bam files

# Example usage:
# sbatch --array 0-15 merge_bams_histone_tf.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --time=1:00:00
#SBATCH --mem=4GB

# Job name and output
#SBATCH -J merge
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=2

# Load modules
module load samtools

# Define query files
queries=($(ls *_filtered.sorted.bam | xargs -n 1 basename | grep -v "IgG" | sed 's/_s._filtered.sorted.bam//g' | uniq))

# Define tmpDir variable
tmpDir=tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Make temporary directory
pwd; hostname; date

echo "Making temporary directories..."

mkdir -p ${tmpDir}

# Write a temporary file referencing bams to merge (one per line)
echo $(date +"[%b %d %H:%M:%S] Writing temporary bamlist file...")

ls ${queries[$SLURM_ARRAY_TASK_ID]}*_filtered.sorted.bam | tr ' ' '\n' \
> ${queries[$SLURM_ARRAY_TASK_ID]}_bamlist.txt.tmp

# Merge bam files
echo $(date +"[%b %d %H:%M:%S] Merging bam files...")

samtools merge -@ ${numThreads} -b ${queries[$SLURM_ARRAY_TASK_ID]}_bamlist.txt.tmp \
${queries[$SLURM_ARRAY_TASK_ID]}_merged_filtered.bam.tmp

# Sort merged bam file
echo $(date +"[%b %d %H:%M:%S] Sorting merged bam file...")

samtools sort -@ ${numThreads} -T ${tmpDir} ${queries[$SLURM_ARRAY_TASK_ID]}_merged_filtered.bam.tmp \
> ${queries[$SLURM_ARRAY_TASK_ID]}_merged_filtered.sorted.bam

# Index merged bam file
echo $(date +"[%b %d %H:%M:%S] Indexing merged bam file...")

samtools index -@ ${numThreads} ${queries[$SLURM_ARRAY_TASK_ID]}_merged_filtered.sorted.bam \
> ${queries[$SLURM_ARRAY_TASK_ID]}_merged_filtered.sorted.bam.bai

# Remove temporary files
echo $(date +"[%b %d %H:%M:%S] Removing temporary files...")

rm ${queries[$SLURM_ARRAY_TASK_ID]}_bamlist.txt.tmp
rm ${queries[$SLURM_ARRAY_TASK_ID]}_merged_filtered.bam.tmp
rm -r ${tmpDir}/

echo $(date +"[%b %d %H:%M:%S] Done")