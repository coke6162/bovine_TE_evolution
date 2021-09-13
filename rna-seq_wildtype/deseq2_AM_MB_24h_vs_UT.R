# Load required packages
# Credit for function: https://gist.github.com/smithdanielle/9913897
check.packages <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}
packages <- c("dplyr", "DESeq2", "apeglm")
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

# Extract only columns containing "AM" - necessary if running from a larger counts table
countdata <- select(countdata, contains("AM"))
colnames(countdata)

# Remove AM_UT_Animal1 - does not cluster with other samples
countdata <- select(countdata, -contains("AM_UT_Animal1"))
colnames(countdata)

# Convert countdata table into a matrix - necessary for running DESeq2.
countdata <- as.matrix(countdata)
head(countdata)

# Assign control vs treat samples
(treatment <- factor(c(rep("UT", 3), rep("MB_24h", 4))))

# Create a "coldata" table containing the sample names with their appropriate condition
(coldata <- data.frame(row.names = colnames(countdata), treatment))
coldata

# Construct a DESeqDataSet
dds <- DESeqDataSetFromMatrix(countData = countdata, colData = coldata, design = ~ treatment)

# Set the reference level
dds$treatment <- relevel(dds$treatment, ref = "UT")

# Remove genes with zero counts
nrow(dds)
dds <- dds[rowSums(counts(dds)) > 1,]
nrow(dds)

# Run DESeq2
dds <- DESeq(dds)
resultsNames(dds)

# Get differential expression results & sort by ascending padj
res <- results(dds, contrast=c("treatment", "MB_24h", "UT"))
head(res)

# Get differential expression results, this time shrinking by apeglm for visualization
resLFC <- lfcShrink(dds, coef="treatment_MB_24h_vs_UT", type="apeglm")
head(resLFC)

# Extract normalized counts
dds <- as.data.frame(counts(dds, normalized = TRUE))
colnames(dds)

# Merge unshrinked and shrinked results table with normalized counts tables
resdata <- merge(as.data.frame(res), as.data.frame(dds), by = "row.names", sort = FALSE)
names(resdata)[1] <- "gene"
head(resdata)
resdataLFC <- merge(as.data.frame(resLFC), as.data.frame(dds), by = "row.names", sort = FALSE)
names(resdataLFC)[1] <- "gene"
head(resdataLFC)

# Subset for genes w/ padj >= 0.90, baseMean >= 100, and abs(log2FC) <= 0.05
resdata_baseMean100_padj0.90_log2FC0.05 <- filter(resdata, baseMean >= 100, padj >= 0.90, abs(log2FoldChange) <= 0.05)

# Read in refseq tss bed file & get coordinates for genes in all results tables
all_gene_tss <- read.table(file.path(workingDir, "bosTau9.refseq.genes.tss.bed"), sep="\t", header = FALSE)
colnames(all_gene_tss) <- c("chr", "start", "end", "gene_id", "gene", "strand")
bed <- right_join(all_gene_tss, resdata, by = "gene") %>% select(1:6)
bed_constitutive_baseMean100_padj0.90_log2FC0.05 <- right_join(all_gene_tss, resdata_baseMean100_padj0.90_log2FC0.05, by = "gene") %>% select(1:6)

# Write DESeq2 output txt files
write.table(resdata, file.path(workingDir, "AM_MB_24h_vs_UT.txt"), quote = FALSE, row.names = FALSE, sep = "\t")
write.table(resdataLFC, file.path(workingDir, "AM_MB_24h_vs_UT_LFC_shrinkage_apeglm.txt"), quote = FALSE, row.names = FALSE, sep = "\t")
write.table(resdata_baseMean100_padj0.90_log2FC0.05, file.path(workingDir, "AM_MB_24h_vs_UT_constitutive_baseMean100_padj0.90_log2FC0.05.txt"), quote = FALSE, row.names = FALSE, sep = "\t")

# Write bed output files
write.table(bed, file.path(workingDir, "AM_MB_24h_vs_UT_tss.bed"), quote = FALSE, col.names = FALSE, row.names = FALSE, sep = "\t")
write.table(bed_constitutive_baseMean100_padj0.90_log2FC0.05, file.path(workingDir, "AM_MB_24h_vs_UT_constitutive_baseMean100_padj0.90_log2FC0.05_tss.bed"), quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")