---
geometry: "margin=1in"
---


# Data Preparation Workflow
1. [Loading Libraries](#part-1)
2. [Preparing the Data](#part-2)
3. [Finding Common Genes](#part-3)
4. [Finding the Reduced Gene Set](#part-4)

## Loading libraries {#part-1}
<!--{-->

- I load several libraries that I use in my analysis
    - `tidyverse`
    - `tidymodels`
- I also load several functions that I will use
    - `readFiles`
    - `collectMerged`

```R
library(tidyverse)
library(tidymodels)
source("functions/readFiles.R")
source("functions/collectMerged.R")
```
<!--}-->


## Preparing the data {#part-2}
<!--{-->

- I make a list holding the different arguments that are needed to get the data merged:
    - The filename
    - The start of the column that holds the patient ID
    - The column that has the class variable we are interested in (ER status in this case)
    - The positive instance of the class
    - The negative instance of the class
    - And whether there is data about the chromosome number or gene-type
- I gathered all of that info previously, and comment on some of it in [Update 1](./01_DataSets.md)
    - I gathered this by analyzing the column names for each meta data individually, and using `group_by` to see what instances existed in each column
- I use the `collectMerged()` [function](../functions/collectMerged.R), filling in the arguments about the column that holds the class variable and the values for positive and negative results, to get the metadata and data merged into one tibble.
    - This tibble has only the `Class` (a factor of 0 or 1) and the gene levels for each of the genes


```R
dataSets = list(
   filename = c("GSE115577", "GSE123845", 
                "GSE163882", "GSE19615", "GSE20194", 
                "GSE20271", "GSE21653", "GSE23720", 
                "GSE25055", "GSE25065", "GSE31448", 
                "GSE45255", "GSE58644", "GSE62944", 
                "GSE76275", "GSE81538", "GSE96058H", 
                "GSE96058N", "METABRIC"),
   colStart = c("GSM", "OB", "BA", "GSM", "GSM",
                "GSM", "GSM", "GSM", "GSM", "GSM", "GSM",
                "GSM", "GSM", "TCGA", "GSM", "GSM", "GSM",
                "GSM", "MB"),
   classColumn = c("er_ihc", "er_status_diagnosis",
                   "estrogen_receptor_status", "er", "er_status",
                   "er_status", "er_ihc", "er_ihc", "er_status_ihc",
                   "er_status_ihc", "er_ihc", "er_status",
                   "er", "er_status_by_ihc", "er", "er_consensus",
                   "er_status", "er_status", "ER_IHC"),
   classPositive = list(ii = 1, iii = 1, iv = "P",
                        v = "pos", vi = "P", vii = "P",
                        viii = 1, ix = "positive", x = "P",
                        xi = "P", xii = c("1","positive"), xiii = "ER+",
                        xiv = 1, xv = "Positive", xvi = "Positive",
                        xvii = 0, xviii = 1, xix = 1,
                        xx = "Positve"),
   classNegative = list(ii = 0, iii = 0, iv = "N",
                        v = "neg", vi = "N", vii = "N",
                        viii = 0, ix = "negative", x = "N",
                        xi = "N", xii = c("0","negative"), xiii = "ER-",
                        xiv = 0, xv = "Negative", xvi = "Negative",
                        xvii = c(2,3), xviii = 1, xix = 0,
                        xx = "Negative"),
   geneData = c(FALSE, FALSE, FALSE, TRUE, TRUE,
                TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
                TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
                TRUE, TRUE)
)

for(i in 1:length(dataSets$filename)) {
   
   filename = dataSets$filename[i]
   colStart = dataSets$colStart[i]
   classColumn = dataSets$classColumn[i]
   classPositive = dataSets$classPositive[[i]]
   classNegative = dataSets$classNegative[[i]]
   geneData = dataSets$geneData[i]
   
   cat("  Collecting ", filename, ":", sep = "")
   cat("\n    Start:\t", colStart,
       "\n    Column:\t", classColumn,
       "\n    Positive:\t", classPositive,
       "\n    Negative:\t", classNegative,
       "\n    geneData:\t", geneData, "\n\n", sep = "")
   collectMerged(filename = filename,
                 classColumn = classColumn,
                 classPositive = classPositive,
                 classNegative = classNegative,
                 colStart = colStart,
                 geneData = geneData)
}
```

<!--}-->


## Finding the common genes {#part-3}
<!--{-->

- I use the `readFiles()` [function](../functions/readFiles.R) to read in all of the merged data sets.
- At the same time, this function creates a list of all the names of the different genes in the data set.
- I use the `Reduce()` function, passing as parameters the `intersect` function and the list of genes in each data set from the `readFiles()` function to get the [list of genes](../variables/geneSet.txt) that are in common across all the data sets.

```R
geneNames = readFiles(files = list.files("merged"), getNames = TRUE)
geneSet = Reduce(intersect, geneNames)
write_lines(geneSet, "variables/geneSet.txt")
```
<!--}-->

## Finding the Reduced Gene Set {#part-4}
<!--{-->

- For later work, I want to use a reduced subset of the gene set in order for computation to be quicker.
- To find that subset, I did a PCA on the combined set of "training" data sets (see the next update for info on this)
- I found the loadings for each gene, found the top 1000 genes with the top loadings, and used that as my reduced subset of genes

```R
combined = bind_rows(METABRIC |> select(geneSet),
                     GSE19615 |> select(geneSet),
                     GSE21653 |> select(geneSet),
                     GSE31448 |> select(geneSet),
                     GSE20194 |> select(geneSet),
                     GSE25055 |> select(geneSet),
                     GSE25065 |> select(geneSet),
                     GSE58644 |> select(geneSet),
                     GSE62944 |> select(geneSet),
                     GSE81538 |> select(geneSet),
                     GSE123845 |> select(geneSet),
                     GSE96058N |> select(geneSet)
           )

pca = prcomp(combined, scale. = FALSE)

geneLoadings = names(sort(abs(pca$rotation[,1]), decreasing = TRUE))

reducedGeneSet = head(geneLoadings, n = 1000)

writeLines(reducedGeneSet, "variables/lessGenes.txt")

```

<!--}-->
