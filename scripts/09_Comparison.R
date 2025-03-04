setwd("C:/Users/bat20/OneDrive - Brigham Young University/BYU/2024/Fall/Lab/BreastCancer")
#########################################################
#             Loading the Functions                     #
#########################################################

source("functions/readFiles.R")
source("functions/plotPCA.R")
library(tidyverse)

#########################################################
#             Preparing the Data                        #
#########################################################

dataFolders = c("01_CPF_Range/",
                "02_CPF_Normalize/",
                "03_CPF_None/",
                "05_CPF_Normalize_Each/",
                "06_CPF_Range_Each/"
                )
plotFolders = c("Range/",
                "Normalize/",
                "None/",
                "Normalize_Each/",
                "Range_Each/"
                )

genes = readLines("variables/genes.txt")

for(i in 1:length(dataFolders)) {
    
    cat("Processing data for", "(", i, ")", str_extract(plotFolders[i], ".*(?=/)"), "\n")
    
    readFiles(c("train", "GSE62944"), folder = paste0("baked/", dataFolders[i]), columns = c("Class",genes))
    
    GSE25055 = train
    
    ave1 = GSE25055 |> summarise(across(everything(), mean))
    ave2 = GSE62944 |> summarise(across(everything(), mean))
    var1 = GSE25055 |> summarise(across(everything(), var))
    var2 = GSE62944 |> summarise(across(everything(), var))
    
    ave = bind_rows(ave1, ave2) |>
            t() |>
            as_tibble() |>
            rename(GSE25055 = V1, GSE62944 = V2)
    var = bind_rows(var1, var2) |>
            t() |>
            as_tibble() |>
            rename(GSE25055 = V1, GSE62944 = V2)
    ave1T = ave1 |>
            t() |>
            as_tibble()
    var1T = var1 |>
            t() |>
            as_tibble()
    ave2T = ave2 |>
            t() |>
            as_tibble()
    var2T = var2 |>
            t() |>
            as_tibble()
    
    #########################################################
    #              Plotting the Data                        #
    #########################################################
    
    cat("  Plotting data for", str_extract(plotFolders[i], ".*(?=/)"), "\n")
    
    folder = paste0("plots/09_Comparison/", plotFolders[i])
    if(!dir.exists(folder)) dir.create(folder)
    
    plotPCA(c("GSE25055", "GSE62944"), title = paste0("PCA of ", str_extract(plotFolders[i], ".*(?=/)"), " data"), mdOutput = FALSE, folder = folder, filename = "PCA_Plot")
    
    plot1 = var1T |>
        ggplot(aes(x = V1)) +
        geom_histogram(bins = 1000) +
        theme_bw() + 
        labs(title = "GSE25055 Gene Variance",
             x = "Variance",
             y = "Count")
    ggsave(paste0(folder, "GSE25055_Variance.jpg"),
           plot1,
           width = 6,
           height = 6,
           unit = "in")
    
    plot2 = ave1T |>
        ggplot(aes(x = V1)) +
        geom_histogram(bins = 1000) +
        theme_bw() + 
        labs(title = "GSE25055 Gene Expression",
             x = "Average Expression",
             y = "Count")
    ggsave(paste0(folder, "GSE25055_Average.jpg"),
           plot2,
           width = 6,
           height = 6,
           unit = "in")
    
    plot3 = var2T |>
        ggplot(aes(x = V1)) +
        geom_histogram(bins = 1000) +
        theme_bw() + 
        labs(title = "GSE62944 Gene Variance",
             x = "Variance",
             y = "Count")
    ggsave(paste0(folder, "GSE62944_Variance.jpg"),
           plot3,
           width = 6,
           height = 6,
           unit = "in")
    
    plot4 = ave2T |>
        ggplot(aes(x = V1)) +
        geom_histogram(bins = 1000) +
        theme_bw() + 
        labs(title = "GSE62944 Gene Expression",
             x = "Average Expression",
             y = "Count")
    ggsave(paste0(folder, "GSE62944_Average.jpg"),
           plot4,
           width = 6,
           height = 6,
           unit = "in")
    
    plot5 = ave |>
        ggplot(aes(x = GSE62944, y = GSE25055)) +
        geom_point(alpha = 0.3, size = 0.5) +
        theme_bw() + 
        labs(title = "Average Gene Expression")
    ggsave(paste0(folder, "AverageExpression.jpg"),
           plot5,
           width = 6,
           height = 6,
           unit = "in")
    
    plot6 = var |>
        ggplot(aes(x = GSE62944, y = GSE25055)) +
        geom_point(alpha = 0.3, size = 0.5) +
        theme_bw() + 
        labs(title = "Gene Variance")
    ggsave(paste0(folder, "Variance.jpg"),
           plot6,
           width = 6,
           height = 6,
           unit = "in")

    rm(ave1,
       ave2,
       var1,
       var2,
       ave,
       var,
       ave1T,
       ave2T,
       var1T,
       var2T,
       folder,
       plot1,
       plot2,
       plot3,
       plot4,
       plot5,
       plot6)
}

rm(genes,
   dataFolders,
   plotFolders,
   i,
   GSE25055,
   GSE62944,
   train,
   readFiles)
