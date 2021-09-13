#!/bin/bash

# Script for running featureCounts

# Example usage:
# sbatch featureCounts.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --time=12:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J featureCounts
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

# Define constant variables
numThreads=8

# Load module
module load subread/1.6.2

# Run featureCounts, outputting a single table containing count information for all samples
# Note: this does not include any normalization
pwd; hostname; date

echo "Starting featureCounts gene-level summarization..."

featureCounts \
-T ${numThreads} \
-p -O -s 2 -t exon -g gene_id \
-a bosTau9.ncbiRefSeq.gtf \
-o raw_gene_counts.txt \
$(cat bam_order.txt)

echo $(date +"[%b %d %H:%M:%S] Done")