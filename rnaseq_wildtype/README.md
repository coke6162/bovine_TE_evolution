All bash scripts were written to be run using SLURM on the HPC cluster at the University of Colorado Boulder. Some scripts are written to be run in parallel as [job arrays](https://slurm.schedmd.com/job_array.html).

These scripts assume all samples are named as described sample_names.txt (column 2). For simplicity all input and output files are written to the same directory.

A typical RNAseq workflow looks like this:
1. bbduk.sbatch
2. fastqc.sbatch
3. multiqc.sbatch
4. hisat2.sbatch
5. bam_to_bigwig.sbatch
6. merge_bams.sbatch
7. featureCounts.sbatch
8. deseq2.R (one supplied for each of six datasets)

Required packages:
* bbmap/38.05
* fastqc/0.11.8
* multiqc/1.7
* hisat2/2.1.0
* samtools/1.10
* deeptools/3.5.1
* subread/1.6.2
* deseq2/1.26.0

For a list of all R packages used in this analysis, see session_info.txt.

Note that the soft masked bosTau9 assembly and RefSeq gene annotation files may be downloaded through UCSC:
* bosTau9 - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/genes/bosTau9.fa.gz
* bosTau9.ncbiRefSeq.gtf - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/genes/bosTau9.ncbiRefSeq.gtf