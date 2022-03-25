#!/bin/bash

# Script for running macs2

# Example usage:
# sbatch --array=0-3 macs2_PE.sbatch

## General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=12:00:00
#SBATCH --mem=16G

# Job name and output
#SBATCH -J markdup
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Module load macs2
module load python/2.7.14/MACS/2.1.1

# Define query files
queries=($(ls *.filtered.dedup.sorted.bam | xargs -n 1 basename | sed 's/.filtered.dedup.sorted.bam//g'))

# Call peaks with macs2
pwd; hostname; date

echo "Calling peaks with macs2"

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}

macs2 callpeak \
--treatment ${queries[$SLURM_ARRAY_TASK_ID]} \
--name ${queries[$SLURM_ARRAY_TASK_ID]}.filtered.dedup.sorted.bam \
--outdir ./ \
--gsize 2.63e9 --SPMR -B --keep-dup all --format BAMPE --call-summits

echo $(date +"[%b %d %H:%M:%S] Done")