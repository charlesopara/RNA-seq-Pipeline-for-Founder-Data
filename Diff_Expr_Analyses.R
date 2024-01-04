# Load required packages
library(tximport)
library(tidyverse)
library(DESeq2)
library("BiocParallel")
register(MulticoreParam(5))

# Import sample data 
samples <- read.delim("/path/to/samples.txt")
sample_table <- data.frame(
  sample = c(samples$sample),
  strain = c(samples$strain),
  sex = c(samples$sex),
  diet = c(samples$diet)
)

# Specify design formulas 
# Here we set the design formula to to allow for strain-specific condition effects.
# i.e. to test if the log2 fold change attributable to a given (strain) is different based on other factors (sex and diet) 
model <- ~ strain + strain:sex + strain:diet

# ------------------------------------------------------------------
# Tximport step
# Set the path to the directory containing the RSEM transcript abundance files
dir <- "/path/to/Gene_results"

# Get the list of RSEM gene abundance files
file_list <- list.files(dir, pattern = "\\.genes.results$", full.names = TRUE)

# Import RSEM transcript abundance data using tximport
txi <- tximport(file_list, type = "rsem", txIn = FALSE, txOut = FALSE)

# DESeq2 normalization step 
# Trimming and normalization of dataset
nonzero_lengths <- apply(txi$length > 0, 1, all)
txi_no_zero_length <- list(abundance=txi$abundance[nonzero_lengths,],
                           counts=txi$counts[nonzero_lengths,],
                           length=txi$length[nonzero_lengths,],
                           countsFromAbundance=txi$countsFromAbundance)

# Creating dds object 
dds <- DESeqDataSetFromTximport(txi_no_zero_length, colData = sample_table, design = model)

# Differential expression analyses results
dds <- DESeq(dds, parallel=TRUE)

# Transformations: variance stabilizing transformations (VST) and regularized logarithm (rlog)
# The point of this transformations is to remove the dependence of the variance on the mean, 
# ... particularly the high variance of the logarithm of count data when the mean is low. 
# First, we estimate size factors;
dds <- estimateSizeFactors(dds)
# .. then we perform the normalization;
vsd <- vst(dds, blind=FALSE) # by setting blind = FALSE, the transformation would be ..
# .. blind to the sample information specified by the design formula

# Write our dataframe
write.csv(assay(vsd), file = "vsd.csv")



### *** Same process for Isoform data ...
# .. the only difference being when importing the data .
# Tximport step
# Set the path to the directory containing the RSEM transcript abundance files
dir <- "/path/to/Isoform_results"

# Get the list of RSEM gene abundance files
file_list <- list.files(dir, pattern = "\\.isoforms.results$", full.names = TRUE)

# Import RSEM transcript abundance data using tximport
txi <- tximport(file_list, type = "rsem", txIn = TRUE, txOut = TRUE)
