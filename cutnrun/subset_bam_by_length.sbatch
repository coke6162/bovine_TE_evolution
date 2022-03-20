#!/bin/bash

# Script for subsetting bam files by length

# Example usage:
# sbatch --array 0-11 subset_bam_by_length.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --time=12:00:00
#SBATCH --mem=6GB

# Job name and output
#SBATCH -J subset
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Define query files
queries=($(ls *_merged_filtered.sorted.bam | xargs -n 1 basename | grep -v "IgG" | grep -v "H3K27ac" | grep -v "lessThan150" | grep -v "greaterThan151" | sed 's/_merged_filtered.sorted.bam//g' | uniq))

# Load modules
module purge
module load samtools/1.10 python/3.6.3

# Define key variables
numThreads=2

# Define temporary directory
tmpDir=tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Make temporary directories
pwd; hostname; date

echo "Making temporary directories..."

mkdir -p ${tmpDir}

# Define temporary directory for deeptools
TMPDIR="${tmpDir}"
export TMPDIR

# Retain fragments <= 150bp in length
echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Starting deeptools alignmentSieve...")

alignmentSieve \
--bam ${queries[$SLURM_ARRAY_TASK_ID]}_merged_filtered.sorted.bam \
--outFile ${queries[$SLURM_ARRAY_TASK_ID]}_lessThan150_merged_filtered.bam.tmp \
--maxFragmentLength 150 --numberOfProcessors ${numThreads} \

# Retain fragments > 150bp in length
echo $(date +"[%b %d %H:%M:%S] Starting deeptools alignmentSieve...")

alignmentSieve \
--bam ${queries[$SLURM_ARRAY_TASK_ID]}_merged_filtered.sorted.bam \
--outFile ${queries[$SLURM_ARRAY_TASK_ID]}_greaterThan151_merged_filtered.bam.tmp \
--minFragmentLength 151 --numberOfProcessors ${numThreads}

# Sort subsetted bams
echo $(date +"[%b %d %H:%M:%S] Sorting subsetted bams...")

for i in $(ls ${queries[$SLURM_ARRAY_TASK_ID]}_*_merged_filtered.bam.tmp)
do
	samtools sort -@ ${numThreads} -T ${tmpDir}${i} -o ${i%.tmp}
done

# Index subsetted bams
echo $(date +"[%b %d %H:%M:%S] Indexing subsetted bams...")

for i in $(ls ${queries[$SLURM_ARRAY_TASK_ID]}_*_merged_filtered.bam)
do
	samtools index -@ ${numThreads} ${i} ${i}.bai
done

# Remove temporary files
echo $(date +"[%b %d %H:%M:%S] Removing temporary files...")

rm ${queries[$SLURM_ARRAY_TASK_ID]}_lessThan150_merged_filtered.bam.tmp
rm ${queries[$SLURM_ARRAY_TASK_ID]}_greaterThan151_merged_filtered.bam.tmp
rm -rf ${tmpDir}

echo $(date +"[%b %d %H:%M:%S] Done")