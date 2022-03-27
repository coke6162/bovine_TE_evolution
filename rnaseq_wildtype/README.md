All bash scripts were written to be run using SLURM on the HPC cluster at the University of Colorado Boulder. Some scripts are written to be run in parallel as [job arrays](https://slurm.schedmd.com/job_array.html).

These scripts assume all samples are named as described sample_names.txt (column 2). For simplicity all input and output files are written to the same directory.

A typical RNAseq workflow looks like this:
1. [bbduk.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_wildtype/bbduk.sbatch)
2. [fastqc.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_wildtype/fastqc.sbatch)
3. [multiqc.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_wildtype/multiqc.sbatch)
4. [hisat2.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_wildtype/hisat2.sbatch)
5. [bam_to_bigwig.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_wildtype/bam_to_bigwig.sbatch)
6. [merge_bams.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_wildtype/merge_bams.sbatch)
7. [featureCounts.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_wildtype/featureCounts.sbatch)
8. deseq2.R (one supplied for each of six datasets)

Required packages:
* BBMap v38.05 (https://jgi.doe.gov/data-and-tools/bbtools/)
* FastQC v0.11.8 (https://github.com/s-andrews/FastQC)
* MultiQC v1.7 (https://github.com/ewels/MultiQC)
* HISAT2 v2.1.0 (https://github.com/DaehwanKimLab/hisat2)
* Samtools v1.10 (http://www.htslib.org/)
* deepTools v3.5.1 (https://deeptools.readthedocs.io/en/develop/index.html)
* Subread v1.6.2 (http://subread.sourceforge.net/)
* DESeq2 v1.26.0 (https://bioconductor.org/packages/release/bioc/html/DESeq2.html)

For a list of all R packages used in this analysis, see session_info.txt.

Note that the soft masked bosTau9 assembly and RefSeq gene annotation files may be downloaded through UCSC:
* bosTau9 - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/genes/bosTau9.fa.gz
* bosTau9.ncbiRefSeq.gtf - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/genes/bosTau9.ncbiRefSeq.gtf