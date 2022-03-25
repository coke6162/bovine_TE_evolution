#!/bin/bash

# Script for running sambamba markdup

# Example usage:
# sbatch --array=0-3 sambamba_markdup.sbatch

## General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=12:00:00
#SBATCH --mem=4G

# Job name and output
#SBATCH -J markdup
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=4

# Load modules
module load samtools/1.10 sambamba/0.6.9

# Define query files
queries=($(ls *.sorted.bam | xargs -n 1 basename | sed 's/.sorted.bam//g'))

# Make temporary directories
pwd; hostname; date

echo "Making temporary directories..."

mkdir -p tmp/${queries[$SLURM_ARRAY_TASK_ID]}

# Filter out reads mapping to mitochondrial genes
echo $(date +"[%b %d %H:%M:%S] Removing fragments mapping to mitochondrial DNA")

echo "Processing sample: "${queries[$SLURM_ARRAY_TASK_ID]}

samtools view -@ ${numThreads} ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam \
| egrep -v chrM \
| samtools view -bT bosTau9.main.fa -o ${queries[$SLURM_ARRAY_TASK_ID]}.filtered.bam.tmp

# Sort filtered bam files
echo $(date +"[%b %d %H:%M:%S] Sorting filtered bam files with sambamba")

sambamba sort \
--natural-sort --nthreads=${numThreads} --memory-limit=4G \
--tmpdir=tmp/${queries[$SLURM_ARRAY_TASK_ID]} \
--out=${queries[$SLURM_ARRAY_TASK_ID]}.filtered.sorted.bam.tmp \
${queries[$SLURM_ARRAY_TASK_ID]}.filtered.bam.tmp

# Remove duplicates with sambamba
echo $(date +"[%b %d %H:%M:%S] Removing duplicates with sambamba")

sambamba markdup \
--remove-duplicates --nthreads=${numThreads} --overflow-list-size=600000 --hash-table-size=4194304 \
--tmpdir=tmp/${queries[$SLURM_ARRAY_TASK_ID]} \
${queries[$SLURM_ARRAY_TASK_ID]}.filtered.sorted.bam.tmp \
${queries[$SLURM_ARRAY_TASK_ID]}.filtered.dedup.bam.tmp

# Sort dedup'd bams
echo $(date +"[%b %d %H:%M:%S] Sorting dedup'd bams")

samtools sort -@ ${numThreads} ${queries[$SLURM_ARRAY_TASK_ID]}.filtered.dedup.bam.tmp \
-o ${queries[$SLURM_ARRAY_TASK_ID]}.filtered.dedup.sorted.bam

# Index sorted dedup'd bams
echo $(date +"[%b %d %H:%M:%S] Indexing sorted dedup'd bams")

samtools index -@ {numThreads} \
${queries[$SLURM_ARRAY_TASK_ID]}.filtered.dedup.sorted.bam

# Remove temporary files and directories
echo $(date +"[%b %d %H:%M:%S] Removing temporary files & directories")

rm ${queries[$SLURM_ARRAY_TASK_ID]}*.bam.tmp

echo $(date +"[%b %d %H:%M:%S] Done")