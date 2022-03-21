#!/bin/bash

# Script for concatenating and merging peaks from all samples by pulldown

# Example usage:
# sbatch --array 0-3 merge_peak_files_by_pulldown.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=1:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J merge_by_pulldown
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Load modules
module load bedtools/2.28.0

# Define query files
# Each query will be a pulldown with a set of replicates
queries=($(ls *_mergedpeaks.bed | xargs -n 1 basename | sed 's/MDBK_UT_//g' | sed 's/MDBK_IFNG_2h_//g' | sed 's/_R.*//g' | grep -Ev "all|tmp|lessThan|greaterThan" | sort | uniq))

# Concatenate all narrowPeak regions
pwd; hostname; date

echo "Merging narrowPeak regions from all samples"
echo "Proccessing pulldown: "${queries[$SLURM_ARRAY_TASK_ID]}

cat *_${queries[$SLURM_ARRAY_TASK_ID]}_R*mergedpeaks.bed > all_${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks.bed.tmp

# Sort
echo $(date +"[%b %d %H:%M:%S] Sorting regions...")

bedtools sort \
-i all_${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks.bed.tmp \
> all_${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks_sorted.bed.tmp

# Merge intervals within 100bp from each other
echo $(date +"[%b %d %H:%M:%S] Merging intervals within 100bp from each other...")

bedtools merge \
-i all_${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks_sorted.bed.tmp \
-d 100 \
> all_${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks_sorted_merged100bp.bed.tmp

# Label the regions
echo $(date +"[%b %d %H:%M:%S] Labeling the regions...")

cat all_${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks_sorted_merged100bp.bed.tmp \
| awk '{print $0 "\t" "region"NR}' \
> all_${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks.bed

# Remove tmp files
echo $(date +"[%b %d %H:%M:%S] Removing intermediate files...")

rm all_${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks.bed.tmp
rm all_${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks.bed_sorted.tmp
rm all_${queries[$SLURM_ARRAY_TASK_ID]}_mergedpeaks.bed_sorted_merged100bp.tmp

echo $(date +"[%b %d %H:%M:%S] Done")