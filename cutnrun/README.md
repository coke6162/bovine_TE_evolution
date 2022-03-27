All bash scripts were written to be run using SLURM on the HPC cluster at the University of Colorado Boulder. Some scripts are written to be run in parallel as [job arrays](https://slurm.schedmd.com/job_array.html).

These scripts assume all samples are named as described sample_names.txt (column 2). For simplicity all input and output files are written to the same directory.

A typical CUT&RUN workflow looks like this:
1. [bbduk.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/bbduk.sbatch)
2. [fastqc.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/fastqc.sbatch)
3. [multiqc.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/multiqc.sbatch)
4. [bwa_mem.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/bwa_mem.sbatch)
5. [merge_bams_histone_tf.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/merge_bams_histone_tf.sbatch) and [merge_bams_IgG.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/merge_bams_IgG.sbatch)
6. [subset_bam_by_length.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/subset_bam_by_length.sbatch)
7. [macs2_SE.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/macs2_SE.sbatch) and [macs2_PE.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/macs2_PE.sbatch)
8. [merge_peak_files.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/merge_peak_files.sbatch)
9. [bdg_to_bigwig.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/bdg_to_bigwig.sbatch)
10. [merge_peak_files_by_pulldown.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/merge_peak_files_by_pulldown.sbatch)
11. [compute_bam_matrix.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/cutnrun/compute_bam_matrix.sbatch)
12. [deseq2_H3K27ac.R](), [deseq2_POLR2A.R](), [deseq2_STAT1.R](), [deseq2_pSTAT1.R]()

Required packages:
* BBMap v38.05 (https://jgi.doe.gov/data-and-tools/bbtools/)
* FastQC v0.11.8 (https://github.com/s-andrews/FastQC)
* MultiQC v1.7 (https://github.com/ewels/MultiQC)
* BWA v0.7.15 (https://github.com/lh3/bwa)
* Samtools v1.10 (http://www.htslib.org/)
* bedtools v2.28.0 (http://bedtools.readthedocs.io/en/latest/)
* deepTools v3.5.1 (https://deeptools.readthedocs.io/en/develop/index.html)
* MACS v2.1.1 (https://pypi.org/project/MACS2/)
* DESeq2 v1.26.0 (https://bioconductor.org/packages/release/bioc/html/DESeq2.html)

For a list of all R packages used in this analysis, see session_info.txt.

Note that the soft masked bosTau9 assembly and RefSeq gene annotation files may be downloaded through UCSC:
* bosTau9 - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/bosTau9.fa.gz
* bosTau9.chrom.sizes - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/bosTau9.chrom.sizes
* bosTau9.ncbiRefSeq.gtf - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/genes/bosTau9.ncbiRefSeq.gtf