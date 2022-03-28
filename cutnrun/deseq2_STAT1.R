# Load required packages
# Credit for function: https://gist.github.com/smithdanielle/9913897
check.packages <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}
packages <- c("dplyr", "DESeq2")
check.packages(packages)

# Set input directory
# This should be the directory that hosts your count table
workingDir <- "/Users/path/to/working/directory"

# Write session info
writeLines(capture.output(sessionInfo()), file.path(workingDir, "session_info.txt"))

# Read in full counts table
countdata <- read.csv(file.path(workingDir, "bamCounts_STAT1_merged_d100.tab"), sep = "\t", header = FALSE)
head(countdata)

# Set the fourth column to be the rownames
rownames(countdata) <- countdata[,4]
head(countdata)

# Remove the first four columns
countdata <- countdata[ ,5:ncol(countdata)]
head(countdata)

# Rename columns
colnames(countdata) <- c("UT_R1", "UT_R2", "IFNG_2h_R1", "IFNG_2h_R2")
head(countdata)

# Convert countdata table into a matrix
countdata <- as.matrix(countdata)

# Assign control vs treat samples
colnames(countdata)
(treatment <- factor(c(rep("UT", 2), rep("IFNG_2h", 2))))

# Create a "coldata" table containing the sample names with their appropriate condition
coldata <- data.frame(row.names = colnames(countdata), treatment, replicate)
coldata

# Construct a DESeqDataSet
dds <- DESeqDataSetFromMatrix(countData = countdata, colData = coldata, design = ~ treatment)

# Set the reference level
dds$treatment <- relevel(dds$treatment, ref = "UT")

# Remove regions with zero counts
nrow(dds)
dds <- dds[rowSums(counts(dds)) > 1,]
nrow(dds)

# Run DESeq2
dds <- DESeq(dds)
resultsNames(dds)

# Get differential enrichment results
res <- results(dds, contrast = c("treatment", "IFNG_2h", "UT"))

# Extract normalized counts
dds <- as.data.frame(counts(dds, normalized = TRUE))
colnames(dds)

# Merge results tables with normalized counts tables
resdata <- merge(as.data.frame(res), as.data.frame(dds), by = "row.names", sort = FALSE)
names(resdata)[1] <- "Region"
head(resdata)

# Extract regions with padj value less than 0.05
resdata_padj <- subset(resdata, padj <= 0.05)

# Extract nonresponsive regions 
resdata_baseMean100_padj0.90_log2FC0.05 <- filter(resdata, baseMean >= 100, padj >= 0.90, abs(log2FoldChange) <= 0.05)

# Read in bed file
all_mergedpeaks <- read.table(file.path(inDir, "all_STAT1_merged_mergedpeaks.bed"), sep="\t", header = FALSE)
colnames(all_mergedpeaks) <- c("Chr", "Start", "End", "Region")
head(all_mergedpeaks)

# Get coordinates for regions
bed <- right_join(all_mergedpeaks, resdata, by = "Region") %>% select(1:4, 6, 9, 10)
bed_padj <- right_join(all_mergedpeaks, resdata_padj, by = "Region") %>% select(1:4, 6, 9, 10)
bed_constitutive_baseMean100_padj0.90_log2FC0.05 <- right_join(all_mergedpeaks, resdata_baseMean100_padj0.90_log2FC0.05, by = "Region") %>% select(1:4, 6, 9, 10)

# Write DESeq2 output txt files
write.table(resdata, file.path(workingDir, "STAT1_IFNG_2h_vs_UT.txt"), quote = FALSE, row.names = FALSE, sep = "\t")
write.table(resdata_padj, file.path(workingDir, "STAT1_IFNG_2h_vs_UT_padj.txt"), quote = FALSE, row.names = FALSE, sep = "\t")
write.table(resdata_baseMean100_padj0.90_log2FC0.05, file.path(workingDir, "STAT1_IFNG_2h_vs_UT_constitutive_baseMean100_padj0.90_log2FC0.05.txt"), quote = FALSE, row.names = FALSE, sep = "\t")

# Write bed output files
write.table(bed, file.path(workingDir, "STAT1_IFNG_2h_vs_UT.bed"), quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
write.table(bed_padj, file.path(workingDir, "STAT1_IFNG_2h_vs_UT_padj.bed"), quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
write.table(bed_constitutive_baseMean100_padj0.90_log2FC0.05, file.path(workingDir, "STAT1_IFNG_2h_vs_UT_constitutive_baseMean100_padj0.90_log2FC0.05.bed"), quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")