#!/bin/bash

# Script for running qualimap bamqc

# Example usage:
# sbatch --array 0-37 qualimap_bamqc.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=12:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J qualimap
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=4

# Define path variables
tmpDir=java_tmp

# Define query files
queries=($(ls *_merged_marked.bam | xargs -n 1 basename | sed 's/_merged_marked.bam//g'))

# Make output directory
pwd; hostname; date

echo "Making output directory..."

mkdir -p qualimap_out/${queries[$SLURM_ARRAY_TASK_ID]}

# Run qualimap
echo $(date +"[%b %d %H:%M:%S] Run qualimap bamqc...")

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}

qualimap bamqc \
-bam ${queries[$SLURM_ARRAY_TASK_ID]}_merged_marked.bam \
-outdir qualimap_out/${queries[$SLURM_ARRAY_TASK_ID]} \
-outfile qualimap_out/${queries[$SLURM_ARRAY_TASK_ID]}/${queries[$SLURM_ARRAY_TASK_ID]}.pdf -outformat PDF \
-nt ${numThreads} --java-mem-size=8G \
-c -nw 400 -hm 3

# Write file containing coverage info (for easy reference)
echo $(date +"[%b %d %H:%M:%S] Extracting coverage info...")

grep "mean coverageData" \
qualimap_out/${queries[$SLURM_ARRAY_TASK_ID]}/genome_results.txt \
> qualimap_out/${queries[$SLURM_ARRAY_TASK_ID]}/mean_coverage.txt

echo $(date +"[%b %d %H:%M:%S] Done")