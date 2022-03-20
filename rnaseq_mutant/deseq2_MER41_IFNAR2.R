# Load required packages
# Credit for function: https://gist.github.com/smithdanielle/9913897
check.packages <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}
packages <- c("dplyr", "DESeq2", "ashr")
check.packages(packages)

# Set input directory
# This should be the directory that hosts your count table
workingDir <- "/Users/path/to/working/directory"

# Write session info
writeLines(capture.output(sessionInfo()), file.path(workingDir, "session_info.txt"))

# Read in full counts table
countdata <- read.csv(file.path(workingDir, "raw_gene_counts.txt"), sep = "", header = TRUE, skip = 1)
head(countdata)

# Set first column (geneid) to be the rownames
rownames(countdata) <- countdata[,1]
head(countdata)

# Remove the first six columns (geneid, chr, start, end, strand, length)
countdata <- countdata[ ,-c(1:6)]
head(countdata)

# Remove suffix and path (if necessary) from column names
colnames(countdata) <- gsub("\\.sorted.uniq.bam$", "", colnames(countdata))
colnames(countdata) <- gsub("\\X.Users.path.to.working.directory.", "", colnames(countdata))
colnames(countdata)

# Extract only columns containing "ctrl" or "IFNAR2" - necessary if running from a larger counts table
countdata <- select(countdata, contains("ctrl") | contains("IFNAR2"))
colnames(countdata)

# Convert countdata table into a matrix - necessary for running DESeq2.
countdata <- as.matrix(countdata)
head(countdata)

# Assign untreated vs treat samples
# This assumes that columns are in the same order as that specified in bam_order.txt
(treatment <- factor(c(rep(c(rep("UT", 2), rep("IFNG", 2)), 4))))

# Assign WT vs KO samples
# This assumes that columns are in the same order as that specified in bam_order.txt
(genotype <- factor(c(rep("WT", 8), rep ("KO", 8))))

# Create a "coldata" table containing the sample names with their appropriate condition
(coldata <- data.frame(row.names = colnames(countdata), treatment, genotype))
coldata

# Construct the DESeqDataSet
dds <- DESeqDataSetFromMatrix(countData = countdata, colData = coldata, design = ~ genotype)

# Set the reference level
dds$condition <- relevel(dds$condition, "UT")
dds$genotype <- relevel(dds$genotype, "WT")

# Remove genes with zero counts
nrow(dds)
dds <- dds[rowSums(counts(dds)) > 1,]
nrow(dds)

# Run DESeq2
design(dds) <- ~ genotype + condition + genotype:condition
dds <- DESeq(dds)
resultsNames(dds)

# Get differential expression results & sort by ascending padj
# Note that this extracts results comparing expression between KO IFNG vs WT IFNG
res <- results(dds, contrast = list(c("genotype_KO_vs_WT", "genotypeKO.conditionbIFNG")))
head(res)

# Get differential expression results again, this time shrinking by ashr for visualization
res_LFC <- lfcShrink(dds, contrast = list(c("genotype_KO_vs_WT", "genotypeKO.conditionbIFNG")), type="ashr")
head(res_LFC)

# Extract normalized counts
dds <- as.data.frame(counts(dds, normalized = TRUE))
colnames(dds)

# Merge unshrinked and shrinked results table with normalized counts tables
resdata <- merge(as.data.frame(res), as.data.frame(dds), by = "row.names", sort = FALSE)
names(resdata)[1] <- "gene"
head(resdata)
resdata_LFC <- merge(as.data.frame(res_LFC), as.data.frame(dds), by = "row.names", sort = FALSE)
names(resdata_LFC)[1] <- "gene"
head(resdata_LFC)

# Read in refseq tss bed file & get coordinates for genes in all results tables
all_gene_tss <- read.table(file.path(workingDir, "bosTau9.refseq.genes.tss.bed"), sep="\t", header = FALSE)
colnames(all_gene_tss) <- c("chr", "start", "end", "gene_id", "gene", "strand")
bed <- right_join(all_gene_tss, resdata, by = "gene") %>% select(1:6)
bed_LFC <- right_join(all_gene_tss, resdata, by = "gene") %>% select(1:6)

# Write DESeq2 output txt files
write.table(resdata, file.path(workingDir, "MDBK_MER41_IFNAR2_IFNG_vs_WT_IFNG.txt"), quote = FALSE, row.names = FALSE, sep = "\t")
write.table(resdata_LFC, file.path(workingDir, "MDBK_MER41_IFNAR2_IFNG_vs_WT_IFNG_LFC_shrinkage_ashr.txt"), quote = FALSE, row.names = FALSE, sep = "\t")

# Write bed output files
write.table(bed, file.path(workingDir, "MDBK_MER41_IFNAR2_IFNG_vs_WT_IFNG_tss.bed"), quote = FALSE, col.names = FALSE, row.names = FALSE, sep = "\t")
write.table(bed_LFC, file.path(workingDir, "MDBK_MER41_IFNAR2_IFNG_vs_WT_IFNG_LFC_shrinkage_ashrtss.bed"), quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")