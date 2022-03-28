All bash scripts were written to be run using SLURM on the HPC cluster at the University of Colorado Boulder. Some scripts are written to be run in parallel as [job arrays](https://slurm.schedmd.com/job_array.html).

Accession numbers and corresponding sample names are provided in sample_names.txt. These scripts assume that all samples are named as described in sample_names.txt. For simplicity all input and output files are written to the same directory.

Note: the following samples were treated as controls for the DESeq2 analysis: "Cas12_ctrl" and "MER41_IFNAR2_KO1". The following samples were treated as clonal deletions/knockouts for IFNAR2: "MER41_IFNAR2_KO2" and "MER41_IFNAR2_KO3". The following samples were treated as clonal deletions/knockouts for LOC510185/IL2RB: "MER41_IL2RB_KO1", "MER41_IL2RB_KO2", "MER41_IL2RB_KO3". Although labeled as "MER41_IFNAR2_KO1", these samples do not harbor the MER41_BT.IFNAR2 deletion and are therefore used as independent biological replicates in addition to the "Cas12_ctrl" samples.

A typical RNAseq workflow looks like this:
1. [bbduk.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_mutant/bbduk.sbatch)
2. [fastqc.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_mutant/fastqc.sbatch)
3. [multiqc.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_mutant/multiqc.sbatch)
4. [hisat2.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_mutant/hisat2.sbatch)
5. [bam_to_bigwig.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_mutant/bam_to_bigwig.sbatch)
6. [featureCounts.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_mutant/featureCounts.sbatch)
7. [deseq2_MER41_IL2RB.R](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_mutant/deseq2_MER41_IL2RB.R) and [deseq2_MER41_IFNAR2.R](https://github.com/coke6162/bovine_TE_evolution/blob/main/rnaseq_mutant/deseq2_MER41_IFNAR2.R)

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