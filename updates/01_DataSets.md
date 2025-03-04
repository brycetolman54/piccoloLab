---
geometry: "margin=1in"
---

# Breast Cancer Project Data sets

<!--
https://docs.google.com/document/d/1xDCy5HCs2n-AlsM0vLBPpHYs3Qjya4OPvTwTLIUR8to/edit?tab=t.0
-->

- The *GSE25055* is the data set used for training the model
- The Size column tells what the size of the data set is after dropping any `NA` values in the `Class` column
- The count column tells how many samples there were before I removed all `NA` or `indeterminate` values

|  Data set   |  Count  |   Size  |              Collection Platform               |  Class Counts (+/-)  |
|  :--------  |  :----  |  :----  |  :-------------------------------------------  |  :----------------:  |
|  METABRIC   |  1,980  |  1,937  |  Illumina Human HT-12 v3 Expression Beadchips  |      1498 / 439      |
| - - - - - - - | - - - - | - - - - | - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - -|
|  GSE19615   |   115   |   111   |  Affymetrix Human Genome U133 Plus 2.0 Array   |        66 / 45       |
|  GSE21653   |   266   |   263   |  Affymetrix Human Genome U133 Plus 2.0 Array   |       150 / 113      |
|  GSE31448   |   357   |   349   |  Affymetrix Human Genome U133 Plus 2.0 Array   |       188 / 161      |
| - - - - - - - | - - - - | - - - - | - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - -|
|  GSE20194   |   251   |   251   |      Affymetrix Human Genome U133A Array       |       155 / 96       |
|  GSE25055   |   295   |   291   |      Affymetrix Human Genome U133A Array       |       166 / 125      |
|  GSE25065   |   184   |   183   |      Affymetrix Human Genome U133A Array       |       117 / 66       |
| - - - - - - - | - - - - | - - - - | - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - -|
|  GSE58644   |   321   |   320   |       Affymetrix Human Gene 1.0 ST Array       |       250 / 70       |
| - - - - - - - | - - - - | - - - - | - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - -|
|  GSE62944   |  1,065  |  1,015  |            Illumina Genome Analyzer            |       785 / 230      |
| - - - - - - - | - - - - | - - - - | - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - -|
|  GSE81538   |   405   |   397   |              Illumina HiSeq 2000               |       315 / 82       |
|  GSE123845  |   136   |   136   |              Illumina HiSeq 2000               |        58 / 78       |
| - - - - - - - | - - - - | - - - - | - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - -|
|  GSE96058N  |   304   |   290   |              Illumina NextSeq 500              |       263 / 27       |
|   = = = =   |   = =   |   = =   |    = = = = = = = = = = = = = = = = = = = =     |   = = = = = = = =    |
|  GSE20271   |   156   |   156   |  Affymetrix Human Genome U133 Plus 2.0 Array   |        92 / 64       |
|  GSE23720   |   197   |   197   |  Affymetrix Human Genome U133 Plus 2.0 Array   |       131 / 66       |
| - - - - - - - | - - - - | - - - - | - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - -|
|  GSE45255   |   135   |   133   |      Affymetrix Human Genome U133A Array       |        86 / 47       |
|  GSE76275   |   265   |   265   |      Affymetrix Human Genome U133A Array       |        49 / 216      |
| - - - - - - - | - - - - | - - - - | - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - -|
|  GSE96058H  |  2,969  |  2,783  |              Illumina HiSeq 2000               |     2,569 / 214      |
| - - - - - - - | - - - - | - - - - | - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - -|
|  GSE163882  |   221   |   221   |              Illumina NextSeq 500              |       104 / 117      |
| - - - - - - - | - - - - | - - - - | - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - -|
|  GSE115577  |  1,110  |  1,103  |  Custom Affymetrix Human Transcriptome Array   |       877 / 226      |

### Notes on the data sets
- The last eight data sets will not be used until after we have developed a model or prediction. They will be our blind test sets.
- For data sets with an `er_consensus` column, I counted 0 as negative, 1 as nothing, and 2/3 as positive
- For data sets with `pos-low` as a value for `er_status`, I counted `neg` as negative, `pos` as positive, and `pos-low` as nothing
- I could not use the *ICGC* data set, as it had no `ER Status` column
- *GSE58644* is the only one of its platform with an `ER Status` column
- *METABRIC* and *GSE62944* are the only ones of their respective platforms
- There are no datasets with `ER Status` columns of the **Affymetrix Human Genome U95 Version 2 Array** collection platform
- There are no datasets with `ER Status` columns of the **Affymetrix Human Genome U133A 2.0 Array** collection platform
- *GSE31448* had both `0` and `negative`, and also `1` and `positive`. I chose to count both `0` and `negative` as Class Negative, and `1` and `positive` as Class Positive

### Different Data sets

- Some of the data sets I did not get from OSF. Those would be the following:
    - <i>GSE163882</i>: Illumina NextSeq 500 (n=221)
        - I left the `BA` columns as the sample ID and had to do the merge between meta and data manually
        - There was no column with chromosome number in this data as with the other sets I have worked with.
            - I thought this not a problem as I have to find which genes all sets have and the other sets I am working with only have the genes on chromosomes that we care about.
    - <i>GSE123845</i>: Illumina HiSeq 2500 (n=136)
        - I left the `OB` columns as the sample ID and had to do the merge manually
        - There were three waves of samples. I made sure to have one and only one sample from each person
            - Since some did not have a first or a second or a third, I chose to just use one of the three for each person, without regard to which time stamp it came from
            - I removed the extra samples from the meta data, not the gene expression data. The duplicates in the gene expression data were removed when merged
        - Since there were no `Ensembl_Gene_ID` values, I used [**this site**](https://biit.cs.ut.ee/gprofiler/convert) to find them given the names in the meta data
            - I had to `drop_na()` some values
            - Also, some of the genes were matched to multiple names. This issue was resolved when I did the `left_join` to get the `Ensembl_Gene_ID` values in the data table
        - I curated the columns in the meta data myself
            - I did this in Excel, as I found that easier
    - <i>GSE115577</i>: Custom Affymetrix Human Transcriptome Array (n=1110, n=1099)
        - I used the same website as for <i>GSE123845 </i> to get the `Ensembl_Gene_ID` values for each gene from the given numbers
            - As above, when I got these gene names, there were some duplicates. I just kept the first of any duplicates.
        - I also dropped a lot of genes because they had expression values of `NA`. 
            - This did not drastically reduce the overlapping genes between this set and the rest (we lost about 180 genes)

# Which Genes to Use

- Looking only at GSE25055 right now:
    - Restricting our genes to only those on chromosomes 1 through 22 and X/Y:
        - We go from `n = 13,744` to `n = 11,952`
    - Restricting our genes to only protein coding genes:
        - We go from `n = 11,952` to `n = 11,809`
    - It looks like we should be good to remove those sets of genes and stick only with protein coding genes on chromosomes 1 through 22 and X/Y
- Looking at METABRIC (a sufficiently different data set):
    - Restricting based on the chromosome:
        - We go from `n = 21,423` to `n = 18,611`
    - Restricting based on coding:
        - We go from `n = 18,611` to `n = 17,977`
- When I intersected all genes from all of the data sets above (n = 15), I got a total of 10,544 genes to use.
    - This is using only the genes on chromosomes 1 through 22 and X/Y, and those which are protein encoding. 
    - These genes are found [here](../variables/genes.txt)

- I then combined all the data in the training sets, selecting only the genes found above.
- I did a PCA analysis on these using `prcomp`
- I took the first principal component and looked at its loadings with `pca$rotation`
- I sorted them by loading value and extracted the top 1000 genes to use as a reduced subset of genes for training a deep learning model
    - I will try to only use 100, but have 1000 there just in case
    - That file is found [here](../variables/lessGenes.txt)
