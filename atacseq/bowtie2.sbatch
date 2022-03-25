#!/bin/bash

# Script for running bowtie2
# bowtie2 index located in a subdirectory named "index" (not supplied)
# "bosTau9.main" index was prepared from bosTau9.fa including only chromosomal scaffolds

# Example usage:
# sbatch --array=0-3 bowtie2.sbatch

## General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=24:00:00
#SBATCH --mem=8G

# Job name and output
#SBATCH -J bowtie2
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=4

# Load bowtie2 and samtools
module load bowtie/2.2.9 samtools/1.10

# Define query files
queries=($(ls *.fastq.gz | xargs -n 1 basename | sed 's/_1_trimmed.fastq.gz//g' | sed 's/_2_trimmed.fastq.gz//g' | uniq))

# Align trimmed reads to the reference genome
pwd; hostname; date

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Aligning to assembly..."

bowtie2 \
--end-to-end --very-sensitive -X 1000 --fr --threads ${numThreads} \
-x index/bosTau9.main \
-1 ${queries[$SLURM_ARRAY_TASK_ID]}_1_trimmed.fastq.gz \
-2 ${queries[$SLURM_ARRAY_TASK_ID]}_2_trimmed.fastq.gz \
| samtools view -@ ${numThreads} -Sb -q 10 -F 4 \
| samtools sort -@ ${numThreads} \
> ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam

# Index sorted bam files
echo $(date +"[%b %d %H:%M:%S] Indexing sorted bams..."

samtools index ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam \
> ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam.bai

echo $(date +"[%b %d %H:%M:%S] Done")