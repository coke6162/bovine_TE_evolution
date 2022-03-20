#!/bin/bash

# Script for aligning trimmed reads to the reference genome using bwa mem
# bwa index located in a subdirectory named "index" (not supplied)
# all bwa index files share the same "bosTau9" prefix

# Example usage:
# sbatch --array 0-34 bwa.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=4:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J bwa
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=4
nonChrM=$(cat ${genomeChrFile} | awk '{print $1}' | grep -v chrM | tr '\n' ' ')

# Load bwa and samtools
module load bwa/0.7.15 samtools/1.10

# Define query files
# Removes suffix to generate a unique identifier for each pair of files
queries=($(ls *_trimmed.fastq.gz | sed 's/_1_trimmed.fastq.gz//g' | sed 's/_2_trimmed.fastq.gz//g' | uniq))

# Define tmpDir var
tmpDir=tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Make temporary directory
pwd; hostname; date

echo "Making temporary directories..."

mkdir -p ${tmpDir}

# Align trimmed reads to the reference genome
echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Aligning to assembly...")

bwa mem \
-t ${numThreads} \
index/bosTau9 \
${queries[$SLURM_ARRAY_TASK_ID]}_1_trimmed.fastq.gz \
${queries[$SLURM_ARRAY_TASK_ID]}_2_trimmed.fastq.gz \
| samtools view -@ ${numThreads} -Sb -q 10 -F 4 \
| samtools sort -@ ${numThreads} -T ${tmpDir} \
> ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam.tmp

# Filter out chrM reads & sort
echo $(date +"[%b %d %H:%M:%S] Removing chrM reads and sorting...")

samtools view -b ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam.tmp ${nonChrM} \
| samtools sort -@ ${numThreads} -T ${tmpDir} - \
> ${queries[$SLURM_ARRAY_TASK_ID]}_filtered.sorted.bam

# Index filtered sorted bam files
echo $(date +"[%b %d %H:%M:%S] Indexing filtered, sorted bams...")

samtools index ${queries[$SLURM_ARRAY_TASK_ID]}_filtered.sorted.bam \
> ${queries[$SLURM_ARRAY_TASK_ID]}_filtered.sorted.bam.bai

# Remove temporary files
echo $(date +"[%b %d %H:%M:%S] Removing temporary files...")

rm -r ${tmpDir}
rm ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam.tmp

echo $(date +"[%b %d %H:%M:%S] Done")