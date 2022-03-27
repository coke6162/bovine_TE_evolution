#!/bin/bash

# Script for spawning jobs to run MELT IndivAnalysis

# This script spawns one MELT IndivAnalysis job per bam file
# This script depends on MELT_samples.txt
# The first column contains bam names (without paths)
# The second column contains corresponding coverage values
# Change 'outDir' and 'meiZip' according to TE family, i.e. BovB or MER41BT

# Example usage:
# outDir=insertion/BOVA2 \
# meiZip=BOVA2_MELT.zip \
# sbatch --array 0-37 run_MELT_IndivAnalysis.sbatch

## General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=0:05:00
#SBATCH --mem=1GB

# Job name and output
#SBATCH -J run_IndivAnalysis
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Define query files
queries=($(cat MELT_samples.txt | awk '{print $1}'))

# Define coverage
coverage=$(grep "${queries[$SLURM_ARRAY_TASK_ID]}" MELT_samples.txt | awk '{print $2}')

# Spawn jobs
echo $(date +"[%b %d %H:%M:%S] Spawning jobs...")

outDir=${outDir} \
meiZip=${meiZip} \
bamFile=${queries[$SLURM_ARRAY_TASK_ID]} \
coverage=${coverage} \
sbatch MELT_IndivAnalysis.sbatch

echo $(date +"[%b %d %H:%M:%S] Done")