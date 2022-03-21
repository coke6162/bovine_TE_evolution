#!/bin/bash

# Script for computing bam alignment count matrix

# Example usage:
# sbatch --array=0-3 compute_bam_matrix.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 2
#SBATCH --time=12:00:00
#SBATCH --mem=4GB

# Job name and output
#SBATCH -J bam_matrix
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Load modules
module load bedtools/2.28.0

# Define query files
queries=($(ls all*bed | xargs -n 1 basename | sed 's/all_//g' | sed 's/_mergedpeaks.bed//g'))

# Define all bam files
# Need to modify query to match peak name to bam name
# Example query: RPB1_merged
# Example bam: RPB1_R1_merged
# Need to create a variable that matches for RPB1_R.
bamName=$(echo ${queries[$SLURM_ARRAY_TASK_ID]} | awk -F "_" '{if ($2 && $3) print $1 "_R[0-9]_" $2 "_" $3; else if ($2) print $1 "_R[0-9]_" $2; else print $1 "_R[0-9]"}')
bams=$(ls *_${bamName}_filtered.sorted.bam)

# Define bed file
bedFile=$(ls all_${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks*.bed)

# Compute a matrix of bam alignment counts for each region of interest
pwd; hostname; date

echo "Sample: "${queries[$SLURM_ARRAY_TASK_ID]}
echo "Bam files: "${bams}
echo "Bed file: "${bedFile}

echo $(date +"[%b %d %H:%M:%S] Computing matrix of bam alignment counts...")

bedtools multicov \
-bams ${bams} \
-bed ${bedFile} \
> bamCounts_${queries[$SLURM_ARRAY_TASK_ID]}_d100.tab

echo $(date +"[%b %d %H:%M:%S] Done")