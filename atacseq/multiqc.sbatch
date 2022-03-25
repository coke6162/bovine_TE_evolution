#!/bin/bash

# Script for aggregating fastqc reports using multiqc
# If multiqc cannot locate your files, include '--bind <filesystem>'
# For example, if your files are on /Users, use 'singularity exec ${multiqc} --bind /Users'
# Alternatively, install multiqc through pip and remove line 34

# Example usage:
# sbatch multiqc.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=1:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J multiqc
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

# Load modules
module load singularity/3.1.1

# Define key variables
multiqc=/scratch/Shares/public/singularity/multiqc-1.7.img

# Aggregate fastqc reports using multiqc
pwd; hostname; date

echo $(date +"[%b %d %H:%M:%S] Running MultiQC...")

singularity exec ${multiqc} \
multiqc \
fastqc_out/*.zip

echo $(date +"[%b %d %H:%M:%S] Done")