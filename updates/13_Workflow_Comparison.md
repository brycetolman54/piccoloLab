---
geometry: "margin=1in"
---

# Data set comparison

- This goes along with the [Comparison Script](../scripts/09_Comparison.R)
- The purpose of this is to compare the gene expression across data sets and to analyze the variance and average expression of RNA seq data
1. [Loading the Functions and libraries](#part-1)
2. [Preparing the data](#part-2)
3. [Plotting the data](#part-3)
4. [Results](#part-4)

## Loading the Functions and Libraries {#part-1}
<!--{-->

- I load the following functions
    - `readFiles()`
- I also load the following libraries
    - `tidyverse`

```R
source("functions/readFiles.R")
library(tidyverse)
```

<!--}-->

## Preparing the data {#part-2}
<!--{-->

- I read in the <i>genes</i> variable of common genes
- I read in the files:
    - <i>GSE25055</i> -> Affymetrix data
    - <i>GSE62944</i> -> RNA Seq data
- I get the average expression of each gene for each set
- I get the variance of each gene for <i>GSE62944</i>
- I combine the averages into one data set for later plotting

```R
genes = readLines("variables/genes.txt")
readFiles(c("GSE25055", "GSE62944"), columns = genes)

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
```

<!--}-->

## Plotting the data {#part-3}
<!--{-->

- I create a histogram for the following:
    - The variance of each gene for both <i>GSE25055</i> and <i>GSE62944</i>
    - The average expression of each gene for both <i>GSE25055</i> and <i>GSE62944</i>
- Then I create a scatter plot with the expression of <i>GSE62944</i> versus <i>GSE25055</i>
- Finally, I create a scatter plot with the variance of <i>GSE62944</i> versus <i>GSE25055</i>
- Notes about the plots:
    - For the variance and expression histograms, I limited the X axis to make it easier to see the majority of the bins in finer detail (there were some distant outliers)
    - The ranges I used were:
        - <i>GSE25055</i> Average Gene Expression: x(-1, 2.5)
        - <i>GSE25055</i> Variance: x(0, 0.25)
        - <i>GSE62944</i> Average Gene Expression: x(0, 100), y(0, 280)
        - <i>GSE62944</i> Variance: x(0, 750), y(0, 250)
    - For the scatter plots, I set the ranges to be the same (though the y axis is set for <i>GSE25055</i>)

```R
folder = "plots/09_Comparison/"
if(!dir.exists(folder)) dir.create(folder)

plot1 = var1T |>
    ggplot(aes(x = V1)) +
    geom_histogram(bins = 1000) +
    theme_bw() + 
    labs(title = "GSE25055 Gene Variance",
         x = "Variance",
         y = "Count") +
    xlim(0,0.25)
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
         y = "Count") +
    xlim(-1,2.5)
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
         y = "Count") +
    xlim(0,750) +
    ylim(0,250)
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
         y = "Count") +
    xlim(0,100) +
    ylim(0,280)
ggsave(paste0(folder, "GSE62944_Average.jpg"),
       plot4,
       width = 6,
       height = 6,
       unit = "in")

plot5 = ave |>
    ggplot(aes(x = GSE62944, y = GSE25055)) +
    geom_point(alpha = 0.3, size = 0.5) +
    theme_bw() + 
    labs(title = "Average Gene Expression") +
    xlim(0,100) +
    ylim(-1,2.5)
ggsave(paste0(folder, "AverageExpression.jpg"),
       plot5,
       width = 6,
       height = 6,
       unit = "in")

plot6 = var |>
    ggplot(aes(x = GSE62944, y = GSE25055)) +
    geom_point(alpha = 0.3, size = 0.5) +
    theme_bw() + 
    labs(title = "Gene Variance") +
    xlim(0,750) +
    ylim(0,0.25)
ggsave(paste0(folder, "Variance.jpg"),
       plot6,
       width = 6,
       height = 6,
       unit = "in")
```

<!--}-->

## Results {#part-4}
<!--{-->

![Histogram of Average Gene Expression of GSE25055](../plots/09_Comparison/GSE25055_Average.jpg){width=100%}

![Histogram of Average Gene Expression of GSE62944](../plots/09_Comparison/GSE62944_Average.jpg){width=100%}

![Histogram of Gene Variance of GSE25055](../plots/09_Comparison/GSE25055_Variance.jpg){width=100%}

![Histogram of Gene Variance of GSE62944](../plots/09_Comparison/GSE62944_Variance.jpg){width=100%}

![Scatter plot of Average Gene Expression](../plots/09_Comparison/AverageExpression.jpg){width=100%}

![Scatter plot of Gene Variance](../plots/09_Comparison/Variance.jpg){width=100%}

<!--}-->

