All bash scripts were written to be run using SLURM on the HPC cluster at the University of Colorado Boulder. Some scripts are written to be run in parallel as [job arrays](https://slurm.schedmd.com/job_array.html).

These scripts assume all samples are named as described in sample_names.txt. For simplicity most input and output files are written to the same directory.

For a typical WGS alignment for MELT analysis, run the scripts in the following order:
1. [fasterq-dump.sbatch]()
2. [bwa_mem.sbatch]()
3. [picard_SortSam.sbatch]()
4. [picard_MergeSam.sbatch]()
5. [picard_MarkDuplicates.sbatch]()
6. [qualimap_bamqc.sbatch]()

Sample coverage estimates are required to run MELT-Split to identify TE-derived insertions. These can be located in the qualimap output and aggregated into a single 'MELT_samples.txt' (example included) that can be used to parallelize MELT. Also note that MELT requires custom MEI.zip files that can be generated using BuildTransposonZIP. Alternatively, we have included the custom MEI.zip files that we used in the GitHub. To identify TE-derived insertion polymorphisms (present in samples & absent in reference) with MELT-Split, run the scripts in the following order:
1. MELT_Insertion_Preprocess.sbatch
2. MELT_Insertion_IndivAnalysis.sbatch (via run_MELT_Insertion_IndivAnalysis.sbatch)
3. MELT_Insertion_GroupAnalysis.sbatch
4. MELT_Insertion_MakeVCF.sbatch

To identify TE-derived deletion polymorphisms (absent in samples & present in reference) using MELT Deletion, run the scripts in the following order:
1. MELT_Deletion_Genotype.sbatch
2. MELT_Deletion_Merge.sbatch

Required packages:
* SRA Toolkit v2.10.5 (https://github.com/ncbi/sra-tools)
* BWA v0.7.15 (https://github.com/lh3/bwa)
* Samtools v1.10 (http://www.htslib.org/)
* Picard v2.6.0 (https://broadinstitute.github.io/picard/)
* QualiMap v2.2.1 (http://qualimap.conesalab.org/)
* Bowtie2 v2.2.9 (http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
* MELT v2.1.5 (https://melt.igs.umaryland.edu/index.php)

Reads were aligned to the to the bosTau9 reference assembly with the bosTau5 Y chromosome (ARS-UCD1.2_Btau5.0.1Y) assembly, which is available for download at https://sites.ualberta.ca/~stothard/1000_bull_genomes/. MEI.zip files were generated using bosTau9 TE annotation, which is available for download at https://hgdownload.soe.ucsc.edu/goldenPath/bosTau9/bigZips/. 