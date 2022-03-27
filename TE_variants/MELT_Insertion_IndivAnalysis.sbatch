#!/bin/bash

# Script for running MELT IndivAnalysis

# This script was written to be compatible with run_MELT_Insertion_IndivAnalysis.sbatch
# Use run_MELT_Insertion_IndivAnalysis.sbatch to parallelize by defining array by bam files
# 'ARS-UCD1.2_Btau5.0.1Y.fa' available at https://sites.ualberta.ca/~stothard/1000_bull_genomes/

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=24:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J IndivAnalysis
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=1

# Load modules
module load bowtie/2.2.9 samtools/1.10

# Define path variables
tmpDir=java_tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Make directories
pwd; hostname; date

echo "Making temporary directory..."

mkdir -p ${tmpDir}
mkdir -p ${outDir}

# Run MELT
echo $(date +"[%b %d %H:%M:%S] Running MELT IndivAnalysis...")

java \
-Xmx8G -Djava.io.tmpdir=${tmpDir} -XX:ParallelGCThreads=${numThreads} \
-jar /Shares/CL_Shared/programs/MELTv2.1.5/MELT.jar IndivAnalysis \
-bamfile ${bamFile} \
-w ${outDir} \
-h ARS-UCD1.2_Btau5.0.1Y.fa \
-t ${meiZip} \
-c ${coverage} \
-r 150

echo $(date +"[%b %d %H:%M:%S] Done")