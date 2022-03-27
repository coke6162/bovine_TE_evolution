#!/bin/bash

# Script for running MELT Deletion-Genotype

# Change 'outDir' and 'meiBed' according to TE family, i.e. BovB or MER41BT
# 'ARS-UCD1.2_Btau5.0.1Y.fa' available at https://sites.ualberta.ca/~stothard/1000_bull_genomes/
# BOVA2.bed can be found by unzipping 'BOVA2_MELT.zip'

# Example usage:
# outDir=deletion/BOVA2 \
# meiBed=BOVA2.bed \
# sbatch --array 0-37 MELT_Deletion_1_Genotype.sbatch

# General settings
#SBATCH -p long
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=7-0:00:00
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
tmpDir=${outDir}/java_tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Define query files
queries=($(ls ${inDir}/*_merged_marked.bam | xargs -n 1 basename | sed 's/_merged_marked.bam//g' | uniq))

# Make directories
pwd; hostname; date

echo "Making temporary and output directories..."

mkdir -p ${tmpDir}
mkdir -p ${outDir}

# Run MELT
echo $(date +"[%b %d %H:%M:%S] Running MELT Deletion-Genotype...")

java \
-Xmx8G -Djava.io.tmpdir=${tmpDir} -XX:ParallelGCThreads=${numThreads} \
-jar /Shares/CL_Shared/programs/MELTv2.1.5/MELT.jar Deletion-Genotype \
-bamfile ${queries[$SLURM_ARRAY_TASK_ID]}_merged_marked.bam \
-w ${outDir} \
-bed ${meiBed} \
-h ARS-UCD1.2_Btau5.0.1Y.fa

# Rename file
echo $(date +"[%b %d %H:%M:%S] Renaming output file...")

mv ${outDir}/${queries[$SLURM_ARRAY_TASK_ID]}_merged_marked.del.tsv ${outDir}/${queries[$SLURM_ARRAY_TASK_ID]}.del.tsv

# Append output to txt file
echo $(date +"[%b %d %H:%M:%S] Appending to list of outputs for Deletion-Genotype...")

ls ${outDir}/${queries[$SLURM_ARRAY_TASK_ID]}.del.tsv >> ${outDir}/list.of.outputs.txt

echo $(date +"[%b %d %H:%M:%S] Done")