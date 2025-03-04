setwd("C:/Users/bat20/OneDrive - Brigham Young University/BYU/2024/Fall/Lab/BreastCancer")
#########################################################
#             Loading the Functions                     #
#########################################################

library(tidyverse)
library(tidymodels)
source("functions/readFiles.R")
source("functions/collectMerged.R")

#########################################################
#             Preparing the Data                        #
#########################################################

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
   
   collectMerged(filename = filename,
                 classColumn = classColumn,
                 classPositive = classPositive,
                 classNegative = classNegative,
                 colStart = colStart,
                 geneData = geneData)
}

#########################################################
#             Finding the Common Genes                  #
#########################################################

geneNames = readFiles(list.files("merged"), getNames = TRUE)
geneSet = Reduce(intersect, geneNames)
write_lines(geneSet, "variables/genes.txt")

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
cat("\n Performing PCA")
pca = prcomp(combined, scale. = FALSE)

geneLoadings = names(sort(abs(pca$rotation[,1]), decreasing = TRUE))

reducedGeneSet = head(geneLoadings, n = 1000)

writeLines(reducedGeneSet, "variables/lessGenes.txt")

rm(dataSets, filename, colStart, classColumn, classPositive,
   classNegative, geneData, geneNames,geneSet, i, combined, 
   pca, geneLoadings, reducedGeneSet, collectMerged, readFiles,
   GSE20271, GSE23720, GSE45255, GSE76275, GSE96058H, 
   GSE163882, GSE115577, METABRIC, GSE19615,
   GSE21653, GSE31448, GSE20194, GSE25055, GSE25065,
   GSE58644, GSE62944, GSE81538, GSE123845, GSE96058N)



