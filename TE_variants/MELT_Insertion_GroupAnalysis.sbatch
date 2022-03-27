#!/bin/bash

# Script for running MELT GroupAnalysis

# Change 'outDir' and 'meiZip' according to TE family, i.e. BovB or MER41BT
# 'ARS-UCD1.2_Btau5.0.1Y.fa' available at https://sites.ualberta.ca/~stothard/1000_bull_genomes/
# 'bosTau9.ncbiRefSeq.bed' generated from bosTau9.ncbiRefSeq.gtf (https://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/genes/bosTau9.ncbiRefSeq.gtf.gz)
# 'bosTau9.ncbiRefSeq.bed' is available on GitHub for reference

# Example usage:
# workingDir=insertion/BOVA2 \
# meiZip=BOVA2_MELT.zip \
# sbatch MELT_Insertion_GroupAnalysis.sbatch

# General settings
#SBATCH -p long
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=7-0:00:00
#SBATCH --mem=64GB

# Job name and output
#SBATCH -J GroupAnalysis
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

# Set constant variables
numThreads=1

# Load modules
module load bowtie/2.2.9 samtools/1.10

# Define path variables
tmpDir=java_tmp/${SLURM_JOB_ID}

# Make directories
pwd; hostname; date

echo "Making temporary directory..."

mkdir -p ${tmpDir}

# Run MELT
echo $(date +"[%b %d %H:%M:%S] Running MELT GroupAnalysis...")

java \
-Xmx64G -Djava.io.tmpdir=${tmpDir} -XX:ParallelGCThreads=${numThreads} \
-jar /Shares/CL_Shared/programs/MELTv2.1.5/MELT.jar GroupAnalysis \
-discoverydir ${workingDir} \
-w ${workingDir} \
-t ${meiZip} \
-h ARS-UCD1.2_Btau5.0.1Y.fa \
-n bosTau9.ncbiRefSeq.bed \
-r 150

echo $(date +"[%b %d %H:%M:%S] Done")