#!/bin/bash

# Script for running MELT MakeVCF

# Change 'outDir' and 'meiZip' according to TE family, i.e. BovB or MER41BT
# 'ARS-UCD1.2_Btau5.0.1Y.fa' available at https://sites.ualberta.ca/~stothard/1000_bull_genomes/

# Example usage:
# workingDir=insertion/BOVA2 \
# meiZip=BOVA2_MELT.zip \
# sbatch MELT_Insertion_MakeVCF.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=12:00:00
#SBATCH --mem=32GB

# Job name and output
#SBATCH -J MakeVCF
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

# Set constant variables
numThreads=1

# Load modules
module load bowtie/2.2.9 samtools/1.10

# Define path variables
tmpDir=${workingDir}/java_tmp/${SLURM_JOB_ID}

# Make directories
pwd; hostname; date

echo "Making temporary directory..."

mkdir -p ${tmpDir}

# Run MELT
echo $(date +"[%b %d %H:%M:%S] Running MELT MakeVCF...")

java \
-Xmx32G -Djava.io.tmpdir=${tmpDir} -XX:ParallelGCThreads=${numThreads} \
-jar /Shares/CL_Shared/programs/MELTv2.1.5/MELT.jar MakeVCF \
-genotypingdir ${workingDir}/${queries[$SLURM_ARRAY_TASK_ID]} \
-p ${workingDir}/${queries[$SLURM_ARRAY_TASK_ID]} \
-o ${workingDir}/${queries[$SLURM_ARRAY_TASK_ID]} \
-w ${workingDir}/${queries[$SLURM_ARRAY_TASK_ID]} \
-t ${meiZip} \
-h ARS-UCD1.2_Btau5.0.1Y.fa

echo $(date +"[%b %d %H:%M:%S] Done")