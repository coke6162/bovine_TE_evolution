#!/bin/bash

# Script for merging macs2 narrowPeak files from SE and PE modes

# Example usage:
# sbatch --array=0-27 merge_peak_files.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=1:00:00
#SBATCH --mem=1G

# Job name and output
#SBATCH -J merge_peaks
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Load modules
module load bedtools/2.28.0

# Define query files
queries=($(ls *_SE_peaks.narrowPeak | xargs -n 1 basename | sed 's/_SE_peaks.narrowPeak//g'))

# Merge SE & PE peaks
pwd; hostname; date

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Merging peak files...")

cat ${queries[$SLURM_ARRAY_TASK_ID]}_SE_peaks.narrowPeak ${queries[$SLURM_ARRAY_TASK_ID]}_PE_peaks.narrowPeak \
| bedtools sort -i - \
| bedtools merge -i - -c 5 -o max \
| awk '{print $1 "\t" $2 "\t" $3 "\t" "'${queries[$SLURM_ARRAY_TASK_ID]}_peak'"NR "\t" $4 "\t" "."}' \
> ${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks.bed

echo $(date +"[%b %d %H:%M:%S] Done")