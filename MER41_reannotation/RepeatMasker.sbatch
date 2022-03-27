#!/bin/bash

# Script for running RepeatMasker
# 'RMRBSeqs.fasta' prepared from RMRBSeqs.embl using buildRMLibFromEMBL.pl util
# RMRBSeqs.embl and buildRMLibFromEMBL.pl included in RepeatMasker installation

# Example usage:
# bash run_RepeatMasker.sh

# General settings
#SBATCH -p long
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --time=10-0:00:00
#SBATCH --mem=150GB

# Job name and output
#SBATCH -J RepeatMasker
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Define constant variable
numThreads=20

## IMPORTANT: "-pa" (see below, line 65) should NOT be set to the same number of cores (line 15)
## Instead, set it equal to the number of cores divided by 4
## If you do not do this RepeatMasker will use four times more resources than requested
numBatchJobs=$(echo $((${numThreads}/4)))

# Define query
# This should be each subdirectory name located within ${workingDir}
queries=($(ls -d ${workingDir}/* | xargs -n 1 basename))

# Define input fasta
refFastaFile=$(ls ${workingDir}/${queries[$SLURM_ARRAY_TASK_ID]}/*.fa)

# Move to assembly directory
pwd; hostname; date

echo "Reference fasta file: "${refFastaFile}
echo "Library file: RMRBSeqs.fasta"
echo "Assembly directory: "${workingDir}/${queries[$SLURM_ARRAY_TASK_ID]}

echo "Moving to assembly directory..."

cd ${workingDir}/${queries[$SLURM_ARRAY_TASK_ID]}

# Run RepeatMasker
echo $(date +"[%b %d %H:%M:%S] Starting RepeatMasker...")

RepeatMasker \
-e rmblast \
-dir ${workingDir}/${queries[$SLURM_ARRAY_TASK_ID]} \
-lib RMRBSeqs.fasta \
-pa ${numBatchJobs} \
-s -gccalc \
${refFastaFile}

# Make required directories
echo $(date +"[%b %d %H:%M:%S] Making required directories...")

mkdir -p eachRep/

# Convert RepeatMaster .fa.out to .bed
echo $(date +"[%b %d %H:%M:%S] Converting RepeatMaster .fa.out to .bed...")

awk '(NR>3){OFS="\t"; print $5, $6, $7, $10, $11, $13, $9}' ${refFastaFile%.fa}.fa.out \
	> ${refFastaFile}_repeats.bed

# Remove simple and tRNA repeats from .bed
echo $(date +"[%b %d %H:%M:%S] Removing simple and tRNA repeats...")

grep -v ")n" ${refFastaFile}_repeats.bed \
	| grep -v "tRNA" - \
	> ${refFastaFile}_repeats_filtered.bed

# Create a file that contains all unique TE family names
echo $(date +"[%b %d %H:%M:%S] Create a txt file containing all unique TE family names from filtered bed...")

awk '{print $4}' ${refFastaFile}_repeats_filtered.bed \
	| sort \
	| uniq \
	> repeat_names_filtered.txt

# Extract repeats, writing one bed file per family to the "eachRep" subdir
echo $(date +"[%b %d %H:%M:%S] Extracting repeats...")

awk 'NR==FNR{ids[$1]; next} $4 in ids{print > ("eachRep/"$4".bed")}' \
	repeat_names_filtered.txt \
	${refFastaFile}_repeats_filtered.bed

echo $(date +"[%b %d %H:%M:%S] Done")