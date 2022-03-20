#!/bin/bash

# Script for merging IgG bam files (by treatment)

# Example usage:
# sbatch merge_bams_IgG.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --time=1:00:00
#SBATCH --mem=4GB

# Job name and output
#SBATCH -J merge
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

# Set constant variables
numThreads=2

# Load modules
module load samtools/1.10

# Define tmpDir variable
tmpDir=tmp/${SLURM_ARRAY_JOB_ID}

# Make temporary directory
pwd; hostname; date

echo "Making temporary directories..."

mkdir -p ${tmpDir}

# Write a temporary file referencing bams to merge (one per line)
echo $(date +"[%b %d %H:%M:%S] Writing temporary bamlist file...")

ls *IgG*UT*_filtered.sorted.bam > MDBK_IgG_UT_bamlist.txt.tmp
ls *IgG*IFNG*_filtered.sorted.bam > MDBK_IgG_IFNG_4h_bamlist.txt.tmp

# Merge bam files
echo $(date +"[%b %d %H:%M:%S] Merging bam files...")

for i in $(ls *_bamlist.txt.tmp)
do
	name=`ls ${i} | sed 's/_bamlist.txt.tmp//'`
	samtools merge -@ ${numThreads} -b ${i} > ${name}_merged_filtered.bam.tmp
done

# Sort merged bam files
echo $(date +"[%b %d %H:%M:%S] Sorting merged bam files...")

for i in *_merged_filtered.bam.tmp
do
	samtools sort -@ ${numThreads} -T ${tmpDir} ${i} > ${i%.tmp}
done

# Index merged bam files
echo $(date +"[%b %d %H:%M:%S] Indexing merged bam files...")

for i in *_merged_filtered.bam
do
	samtools index -@ ${numThreads} ${i} > ${i}.bai
done

# Remove temporary files
echo $(date +"[%b %d %H:%M:%S] Removing temporary files...")

rm MDBK_IgG_*_bamlist.txt.tmp
rm MDBK_IgG_*_merged_filtered.bam.tmp
rm -r ${tmpDir}/

echo $(date +"[%b %d %H:%M:%S] Done")