#!/bin/bash

# Script for running MELT Deletion-Merge

# Change 'outDir' and 'meiBed' according to TE family, i.e. BovB or MER41BT
# 'ARS-UCD1.2_Btau5.0.1Y.fa' available at https://sites.ualberta.ca/~stothard/1000_bull_genomes/
# BOVA2.bed can be found by unzipping 'BOVA2_MELT.zip'

# Example usage:
# outDir=deletion/BOVA2 \
# meiBed=BOVA2.bed \
# sbatch MELT_Deletion_2_Merge.sbatch

# General settings
#SBATCH -p long
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=4-0:00:00
#SBATCH --mem=30GB

# Job name and output
#SBATCH -J Merge
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

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

# Run MELT
echo $(date +"[%b %d %H:%M:%S] Running MELT Deletion (Step 2: Merge)...")

java \
-Xmx30G -Djava.io.tmpdir=${tmpDir} -XX:ParallelGCThreads=${numThreads} \
-jar /Shares/CL_Shared/programs/MELTv2.1.5/MELT.jar Deletion-Merge \
-mergelist ${workingDir}/list.of.outputs.txt \
-bed ${meiBed} \
-h ARS-UCD1.2_Btau5.0.1Y.fa \
-o ${workingDir}/${queries[$SLURM_ARRAY_TASK_ID]}

echo $(date +"[%b %d %H:%M:%S] Done")