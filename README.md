# Bovine TE Evolution

## Scripts and files used in:
Add citation & biorxiv here

## GEO links:
Add GEO link

## UCSC sessions:
Add UCSC sessions

## Programs used:
List of programs used for all analyses. Add versions and URLs later.
* GIGGLE
* bedtools
* fasterq-dump
* FastQC
* MultiQC
* BBDuk/BBMap
* HISAT2
* BWA
* bowtie2
* samtools
* deepTools
* MACS2
* Subread/featureCounts
* DESeq2
* MEME Suite
* Singularity
* RepeatMasker
* vsearch
* MUSCLE
* Jalview
* Intervene
* Coolbox
* gProfiler
* BLAST
* BLAT
* MELT
* Qualimap
* Samplot

## Public databases:
* UCSC (https://genome.ucsc.edu/)
* JASPAR (http://jaspar.genereg.net/)

## Genome-wide profiling of IFNG response
1. Transcriptomic response to IFNG in immortalized and primary bovine cells
Identification of ISGs in wildtype:
* +IFNG 4h MDBK
* +IFNG 4h BL3.1
* +IFNG 2h monocyte
* +IFNG 2h leukocyte
* +LPS 7h bone marrow derived macrophages
* +MB 24h alveolar macrophages

GO analysis
Expression bar charts

2. Epigenomic response to IFNG in MDBK
Analysis of ATAC-seq and CUT&RUN in MDBK
Defining IFN-inducible, IFN-downregulated, and nonresponsive H3K27ac peaks
Motif analysis
Deeptools heatmaps 
Coolbox screenshots

3. Nearest neighbor analysis using RNA-seq and CUT&RUN in MDBK
Define peak sets + ISG set
Plotting

## Identifying IFNG-inducible TEs
1. Overlapping H3K27ac with repeat annotation (class level)
ATAC summit centering
Intersecting with TE annotation

2. Testing for family-level TE enrichment
Giggle analysis

3. Element-level TE anlaysis
MER41_BT and Bov-A2 epigenomic deeptools heatmaps
MER41_BT and Bov-A2 motif deeptools heatmaps

4. Nearest neighbor analysis
Define ATAC summit centered peak sets + ISG set
Intersecting with TE annotation

## CRISPR deletion of MER41_BT.IL2RB
WT expression bar charts
KO RNA-seq analysis pipeline, including DESeq2 script
KO expression bar charts
KO distance plot

## CRISPR deletion of MER41_BT.IFNAR2
WT expression bar charts
KO RNA-seq analysis pipeline, including DESeq2 script
KO expression bar charts
KO distance plot

## Evolutionary history of MER41 in cetartiodactyla
List of assemblies
RepeatMasker
RepeatMasker output -> bubble plot
TEorthology
MER41 clustering/phylogeny/PCA

## Identifying TE polymorphisms in publicly available whole genome sequencing
List publicly available data
WGS analysis, up through MELT insertion and MELT deletion
Filter MELT variants
Number of filtered variants by family for MELT insertion & deletion separately 
Aggregate filtered MELT insertions + deletions
Insertion + deletion PCA
Proportion of genotype calls vs genotype bar chart, by TE family
Number of variants vs number of individuals histogram, by TE family
Nearest neighbor/GO analysis
Samplot