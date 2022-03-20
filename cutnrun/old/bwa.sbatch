#!/bin/bash

# Script for aligning with bwa

# Note that this script assumes the mitochondrial genome is represented in the reference as 'chrM'

# Example usage:
# sbatch --array 0-34 bwa.sbatch

## General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=8:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J bwa
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Set constant variables
numThreads=4
nonChrM=$(cat ${genomeChrFile} | awk '{print $1}' | grep -v chrM | tr '\n' ' ')

# Define key variables
bwaIndex=/Shares/CL_Shared/db/genomes/bosTau9/index/bwa/bosTau9.fa
genomeChrFile=/Shares/CL_Shared/db/genomes/bosTau9/fa/bosTau9.chrom.sizes

# Define query files
queries=($(ls *.fastq.gz | xargs -n 1 basename | sed 's/_1_trimmed.fastq.gz//g' | sed 's/_2_trimmed.fastq.gz//g' | uniq))

# Load modules
module load bwa 
module load samtools/1.10

# Define temporary directory
tmpDir=samtools_tmp/${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}

# Print time and date
pwd; hostname; date

# Print program versions
echo "bwa version: "$(bwa)
echo "samtools version: "$(samtools --version)

# Make temporary directory
mkdir -p ${tmpDir}

# Align reads to the reference genome
echo $(date +"[%b %d %H:%M:%S] Aligning reads to the genome...")

echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo "Aligning to assembly: "${bwaIndex}

bwa mem \
-t ${numThreads} \
${bwaIndex} \
${queries[$SLURM_ARRAY_TASK_ID]}_1_trimmed.fastq.gz \
${queries[$SLURM_ARRAY_TASK_ID]}_2_trimmed.fastq.gz \
> ${queries[$SLURM_ARRAY_TASK_ID]}.sam

# Convert sam files to bam files, filtering out low quality (<10) and unmapped (through '-F 4' option)
echo $(date +"[%b %d %H:%M:%S] Converting sam to unfiltered bam & sorting")

samtools view -@ ${numThreads} -Sb -q 10 -F 4 ${queries[$SLURM_ARRAY_TASK_ID]}.sam \
| samtools sort -@ ${numThreads} -T ${tmpDir} - \
> ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.tmp.bam

# Index unfiltered sorted bam files
echo $(date +"[%b %d %H:%M:%S] Indexing unfiltered, sorted bams...")

samtools index \
${queries[$SLURM_ARRAY_TASK_ID]}.sorted.tmp.bam \
> ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.tmp.bam.bai

# Filter out chrM reads & sort
echo $(date +"[%b %d %H:%M:%S] Removing chrM reads and sorting...")

samtools view -@ ${numThreads} -b ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.tmp.bam ${nonChrM} \
| samtools sort -@ ${numThreads} -T ${tmpDir} - \
> ${queries[$SLURM_ARRAY_TASK_ID]}_filtered.sorted.bam

# Index filtered sorted bam files
echo $(date +"[%b %d %H:%M:%S] Indexing filtered, sorted bams...")

samtools index ${queries[$SLURM_ARRAY_TASK_ID]}_filtered.sorted.bam \
> ${queries[$SLURM_ARRAY_TASK_ID]}_filtered.sorted.bam.bai

# Determine percentage of total reads that mapped to mitochondrial genes
echo $(date +"[%b %d %H:%M:%S] Calculating percentage of total reads mapping to mitochondrial genome...")

chrMreads=`samtools view -c ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.tmp.bam chrM`
totalReads=`samtools view -c ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.tmp.bam`
fractionMreads=`echo "100 * ${chrMreads} / ${totalReads}" | bc -l`
touch ${queries[$SLURM_ARRAY_TASK_ID]}_chrMreadsFraction.txt
echo ${queries[$SLURM_ARRAY_TASK_ID]} >> ${queries[$SLURM_ARRAY_TASK_ID]}_chrMreadsFraction.txt
echo ${totalReads} 'total mapped reads' >> ${queries[$SLURM_ARRAY_TASK_ID]}_chrMreadsFraction.txt
echo ${chrMreads} 'mitochondrial reads' >> ${queries[$SLURM_ARRAY_TASK_ID]}_chrMreadsFraction.txt
echo ${fractionMreads} 'percentage of mitochondrial reads from total mapped reads' >> ${queries[$SLURM_ARRAY_TASK_ID]}_chrMreadsFraction.txt

# Remove intermediate files
echo $(date +"[%b %d %H:%M:%S] Removing intermediate files...")

rm ${queries[$SLURM_ARRAY_TASK_ID]}.sam
rm ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.tmp.bam
rm ${queries[$SLURM_ARRAY_TASK_ID]}.sorted.tmp.bam.bai
rm -r ${tmpDir}

echo $(date +"[%b %d %H:%M:%S] Done")