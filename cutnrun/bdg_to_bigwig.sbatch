#!/bin/bash

# Script for converting macs2 bedgraphs to bigwigs
# bosTau9.chrom.sizes available through UCSC (see README.md)

# Example usage:
# sbatch --array 0-27 bdg_to_bigwig.sbatch

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=1:00:00
#SBATCH --mem=2GB

# Job name and output
#SBATCH -J bdg_to_bw
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Define query files
queries=($(ls *_PE_treat_pileup.bdg | xargs -n 1 basename | sed 's/_PE_treat_pileup.bdg//g'))

# Sort bedgraph
pwd; hostname; date

echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Sorting bedgraph...")

sort -k1,1 -k2,2n ${queries[$SLURM_ARRAY_TASK_ID]}_PE_treat_pileup.bdg \
> ${queries[$SLURM_ARRAY_TASK_ID]}.bdg.tmp

# Convert sorted bedgraph to bigwig
echo $(date +"[%b %d %H:%M:%S] Converting sorted bedgraph to bigwig...")

/Shares/CL_Shared/programs/ucsc/bedGraphToBigWig \
${queries[$SLURM_ARRAY_TASK_ID]}.bdg.tmp \
bosTau9.chrom.sizes \
${queries[$SLURM_ARRAY_TASK_ID]}.bw

# Remove sorted bedgraph
echo $(date +"[%b %d %H:%M:%S] Removing sorted bedgraph...")

rm ${queries[$SLURM_ARRAY_TASK_ID]}.bdg.tmp

echo $(date +"[%b %d %H:%M:%S] Done")