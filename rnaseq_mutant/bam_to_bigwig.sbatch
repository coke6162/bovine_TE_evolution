#!/bin/bash

# Script for running deeptools bamCoverage (v3.5.1)

# Example usage:
# sbatch --array 0-21 bam_to_bigwig_deeptools_bamCoverage.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --time=4:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J bam_to_bigwig
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Define constant variables
numThreads=4

# Define query files
queries=($(ls *.sorted.uniq.bam | sed 's/.sorted.uniq.bam//g'))

# Define temporary directory
tmpDir=tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Make temporary directories
pwd; hostname; date

echo "Making temporary directories..."

mkdir -p ${tmpDir}

# Define temporary directory for deeptools
TMPDIR="${tmpDir}"
export TMPDIR

# Generate bigwig from forward strand data
echo $(date +"[%b %d %H:%M:%S] Converting bam into forward strand bigwig...")

echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}

bamCoverage \
--bam ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.uniq.bam \
--outFileName ${queries[$SLURM_ARRAY_TASK_ID]}_fwd.bw \
--binSize 1 \
--numberOfProcessors ${numThreads} \
--normalizeUsing CPM \
--filterRNAstrand forward \
--ignoreForNormalization chrX chrM

# Generate bigwig from reverse strand data
echo $(date +"[%b %d %H:%M:%S] Converting bam into reverse strand bigwig...")

bamCoverage \
--bam ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.uniq.bam \
--outFileName ${queries[$SLURM_ARRAY_TASK_ID]}_rev.bw \
--binSize 1 \
--numberOfProcessors ${numThreads} \
--normalizeUsing CPM \
--filterRNAstrand reverse \
--ignoreForNormalization chrX chrM

echo $(date +"[%b %d %H:%M:%S] Done")