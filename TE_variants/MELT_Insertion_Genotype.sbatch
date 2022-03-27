#!/bin/bash

# Script for running MELT Genotype

# Change 'outDir' and 'meiZip' according to TE family, i.e. BovB or MER41BT
# 'ARS-UCD1.2_Btau5.0.1Y.fa' available at https://sites.ualberta.ca/~stothard/1000_bull_genomes/

# Example usage:
# workingDir=insertion/BOVA2 \
# meiZip=BOVA2_MELT.zip \
# sbatch --array 0-37 MELT_Insertion_Genotype.sbatch

# General settings
#SBATCH -p long
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=48-0:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J Genotype
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=1

# Load modules
module load bowtie/2.2.9 samtools/1.10

# Define path variables
tmpDir=${workingDir}/java_tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Define query files
queries=($(ls ${bamDir}/*.bam | xargs -n 1 basename))

# Make directories
pwd; hostname; date

echo "Making temporary directory..."

mkdir -p ${tmpDir}

# Run MELT
echo $(date +"[%b %d %H:%M:%S] Running MELT Genotype...")

java \
-Xmx8G -Djava.io.tmpdir=${tmpDir} -XX:ParallelGCThreads=${numThreads} \
-jar /Shares/CL_Shared/programs/MELTv2.1.5/MELT.jar Genotype \
-bamfile ${bamDir}/${queries[$SLURM_ARRAY_TASK_ID]} \
-p ${workingDir} \
-w ${workingDir} \
-t ${meiZip} \
-h ARS-UCD1.2_Btau5.0.1Y.fa

echo $(date +"[%b %d %H:%M:%S] Done")