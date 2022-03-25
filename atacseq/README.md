All bash scripts were written to be run using SLURM on the HPC cluster at the University of Colorado Boulder. Some scripts are written to be run in parallel as [job arrays](https://slurm.schedmd.com/job_array.html).

These scripts assume all samples are named as described sample_names.txt (column 2). For simplicity all input and output files are written to the same directory.

A typical ATAC-seq workflow looks like this:
1. bbduk.sbatch
2. fastqc.sbatch
3. multiqc.sbatch
4. bowtie2.sbatch
5. sambamba_markdup.sbatch
6. macs2_PE.sbatch
7. bdg_to_bigwig.sbatch

Required packages:
* bbmap/38.05
* fastqc/0.11.8
* multiqc/1.7
* bowtie2/2.2.9
* samtools/1.10
* sambamba/0.6.9
* MACS/2.1.1

Note that the soft masked bosTau9 assembly and RefSeq gene annotation files may be downloaded through UCSC:
* bosTau9 - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/bosTau9.fa.gz
* bosTau9.chrom.sizes - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/bosTau9.chrom.sizes