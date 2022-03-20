#!/bin/bash

# Script for calling peaks with macs2 in SE mode (against IgG control)

# Example usage:
# sbatch --array=0-27 call_peaks_with_macs2_SE.sbatch

## General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=6:00:00
#SBATCH --mem=8G

# Job name and output
#SBATCH -J macs2_SE
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Load modules
module load python/2.7.14/MACS/2.1.1

# Define query files
queries=($(awk '(NR>1){if ($3 != "NA") print $2}' sample_names.txt | sed 's/_s.*fastq.gz//' | sort | uniq))

# Define paired control file
controlName=$(grep -w "${queries[$SLURM_ARRAY_TASK_ID]}_s1.fastq.gz" sample_names.txt | cut -f 3)

# Call peaks
pwd; hostname; date

echo "Target file: "${queries[$SLURM_ARRAY_TASK_ID]_merged_filtered.sorted.bam}
echo "Control file: "$(ls ${controlName}*_merged_filtered.sorted.bam)

echo "Starting macs2..."

macs2 callpeak \
--treatment ${queries[$SLURM_ARRAY_TASK_ID]}_merged_filtered.sorted.bam \
--control ${controlName}*_merged_filtered.sorted.bam \
--outdir ./ \
--name ${queries[$SLURM_ARRAY_TASK_ID]}_SE \
--format BAM \
--pvalue 0.01 \
--gsize 2.72e9 \
--shift=-75 \
--extsize=150 \
--bdg \
--SPMR \
--call-summits

echo $(date +"[%b %d %H:%M:%S] Done")