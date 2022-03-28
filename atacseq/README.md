All bash scripts were written to be run using SLURM on the HPC cluster at the University of Colorado Boulder. Some scripts are written to be run in parallel as [job arrays](https://slurm.schedmd.com/job_array.html).

Accession numbers and corresponding sample names are provided in sample_names.txt. These scripts assume that all samples are named as described in sample_names.txt. For simplicity all input and output files are written to the same directory.

A typical ATAC-seq workflow looks like this:
1. [bbduk.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/atacseq/bbduk.sbatch)
2. [fastqc.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/atacseq/fastqc.sbatch)
3. [multiqc.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/atacseq/multiqc.sbatch)
4. [bowtie2.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/atacseq/bowtie2.sbatch)
5. [sambamba_markdup.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/atacseq/sambamba_markdup.sbatch)
6. [macs2_PE.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/atacseq/macs2_PE.sbatch)
7. [bdg_to_bigwig.sbatch](https://github.com/coke6162/bovine_TE_evolution/blob/main/atacseq/bdg_to_bigwig.sbatch)

Required packages:
* BBMap v38.05 (https://jgi.doe.gov/data-and-tools/bbtools/)
* FastQC v0.11.8 (https://github.com/s-andrews/FastQC)
* MultiQC v1.7 (https://github.com/ewels/MultiQC)
* Bowtie2 v2.2.9 (http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
* Samtools v1.10 (http://www.htslib.org/)
* Sambamba v0.6.9 (https://lomereiter.github.io/sambamba/)
* MACS v2.1.1 (https://pypi.org/project/MACS2/)

Note that the soft masked bosTau9 assembly and RefSeq gene annotation files may be downloaded through UCSC:
* bosTau9 - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/bosTau9.fa.gz
* bosTau9.chrom.sizes - http://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/bosTau9.chrom.sizes