All bash scripts were written to be run using SLURM on the HPC cluster at the University of Colorado Boulder. Some scripts are written to be run in parallel as [job arrays](https://slurm.schedmd.com/job_array.html).

These scripts assume all samples are named as described sample_names.txt (column 2). For simplicity all input and output files are written to the same directory.

A typical CUT&RUN workflow looks like this:
1. bbduk.sbatch
2. fastqc.sbatch
3. multiqc.sbatch
4. bwa_mem.sbatch
5. merge_bams_histone_tf.sbatch
6. merge_bams_IgG.sbatch
7. subset_bam_by_length.sbatch
8. macs2_SE.sbatch
9. macs2_PE.sbatch
10. merge_peak_files.sbatch
11. bdg_to_bigwig.sbatch
12. merge_peak_files_by_pulldown.sbatch
13. compute_bam_matrix.sbatch
14. deseq2.R (one supplied for each of four pulldowns)

Required packages:
* bbmap/38.05
* fastqc/0.11.8
* multiqc/1.7
* bwa/0.7.15
* samtools/1.10
* bedtools/2.28.0
* deeptools/3.5.1
* MACS/2.1.1
* deseq2/1.26.0

For a list of all R packages used in this analysis, see session_info.txt.

Note that the soft masked bosTau9 assembly and RefSeq gene annotation files may be downloaded through UCSC:
* bosTau9 - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/bosTau9.fa.gz
* bosTau9.chrom.sizes - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/bosTau9.chrom.sizes
* bosTau9.ncbiRefSeq.gtf - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/genes/bosTau9.ncbiRefSeq.gtf