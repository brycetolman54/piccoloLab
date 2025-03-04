---
geometry: "margin=1in"
---

# More CPF Testing

- This update contains the results from the [CPF Normalize Script](../scripts/02_CPF_Normalize.R)
- It is very similar to the [CPF Range Script](../scripts/01_CPF_Range.R), so I will not be walking through the code, but rather showing the results of it.
- The only difference is I am using standardization rather than forcing my data into a specific range.
- I am just using one data set from each platform as my test data sets
    - <i>GSE25055</i> -> Training Set
        - See the [**Confusion Matrix**](#matrix-1), [**Metrics**](#metrics-1), and [**ROC Curve**](#plot-1) for the test set of this data below.
    - <i>GSE25065</i> -> Affymetrix Human Genome U133A Array
        - See the [**Confusion Matrix**](#matrix-2), [**Metrics**](#metrics-2), and [**ROC Curve**](#plot-2) for this data set below.
    - <i>GSE21653</i> -> Affymetrix Human Genome U133 Plus 2.0 Array
        - See the [**Confusion Matrix**](#matrix-3), [**Metrics**](#metrics-3), and [**ROC Curve**](#plot-3) for the test set of this data below.
    - <i>GSE58644</i> -> Affymetrix Human Gene 1.0 ST Array
        - See the [**Confusion Matrix**](#matrix-4), [**Metrics**](#metrics-4), and [**ROC Curve**](#plot-4) for the test set of this data below.
    - <i>GSE62944</i> -> Illumina Genome Analyzer
        - See the [**Confusion Matrix**](#matrix-5), [**Metrics**](#metrics-5), and [**ROC Curve**](#plot-5) for the test set of this data below.
    - <i>GSE81538</i> -> Illumina HiSeq 2000
        - See the [**Confusion Matrix**](#matrix-6), [**Metrics**](#metrics-6), and [**ROC Curve**](#plot-6) for the test set of this data below.
    - <i>METABRIC</i> -> Illumina Human HT-12 v3 Expression Beadchips
        - See the [**Confusion Matrix**](#matrix-7), [**Metrics**](#metrics-7), and [**ROC Curve**](#plot-7) for the test set of this data below.
    - <i>GSE96058N</i> -> Illumina NextSeq 500
        - See the [**Confusion Matrix**](#matrix-8), [**Metrics**](#metrics-8), and [**ROC Curve**](#plot-8) for the test set of this data below.


# Results

#### test Confusion Matrix {#matrix-1} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  31  |  4  |
|           -           |  1  |  37  |

#### test Metrics {#metrics-1} 

- Accuracy:     0.932 
- Precision:    0.886 
- Recall:       0.969 
- Specificity:  0.902 

#### GSE25065 Confusion Matrix {#matrix-2} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  97  |  17  |
|           -           |  20  |  49  |

#### GSE25065 Metrics {#metrics-2} 

- Accuracy:     0.798 
- Precision:    0.851 
- Recall:       0.829 
- Specificity:  0.742 

#### GSE21653 Confusion Matrix {#matrix-3} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  112  |  44  |
|           -           |  38  |  69  |

#### GSE21653 Metrics {#metrics-3} 

- Accuracy:     0.688 
- Precision:    0.718 
- Recall:       0.747 
- Specificity:  0.611 

#### GSE58644 Confusion Matrix {#matrix-4} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  234  |  54  |
|           -           |  16  |  16  |

#### GSE58644 Metrics {#metrics-4} 

- Accuracy:     0.781 
- Precision:    0.812 
- Recall:       0.936 
- Specificity:  0.229 

#### GSE62944 Confusion Matrix {#matrix-5} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  0  |  0  |
|           -           |  785  |  230  |

#### GSE62944 Metrics {#metrics-5} 

- Accuracy:     0.227 
- Precision:    NA 
- Recall:       0 
- Specificity:  1 

#### GSE81538 Confusion Matrix {#matrix-6} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  7  |  1  |
|           -           |  75  |  314  |

#### GSE81538 Metrics {#metrics-6} 

- Accuracy:     0.809 
- Precision:    0.875 
- Recall:       0.085 
- Specificity:  0.997 

#### METABRIC Confusion Matrix {#matrix-7} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  985  |  253  |
|           -           |  513  |  186  |

#### METABRIC Metrics {#metrics-7} 

- Accuracy:     0.605 
- Precision:    0.796 
- Recall:       0.658 
- Specificity:  0.424 

#### GSE96058N Confusion Matrix {#matrix-8} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  1  |  1  |
|           -           |  262  |  26  |

#### GSE96058N Metrics {#metrics-8} 

- Accuracy:     0.093 
- Precision:    0.5 
- Recall:       0.004 
- Specificity:  0.963 

# Figures

![CPF Normal Standardization](../plots/02_CPF_Normalize/test.jpg){#plot-1 width=100%}

![CPF Normal Standardization](../plots/02_CPF_Normalize/GSE25065.jpg){#plot-2 width=100%}

![CPF Normal Standardization](../plots/02_CPF_Normalize/GSE21653.jpg){#plot-3 width=100%}

![CPF Normal Standardization](../plots/02_CPF_Normalize/GSE58644.jpg){#plot-4 width=100%}

![CPF Normal Standardization](../plots/02_CPF_Normalize/GSE62944.jpg){#plot-5 width=100%}

![CPF Normal Standardization](../plots/02_CPF_Normalize/GSE81538.jpg){#plot-6 width=100%}

![CPF Normal Standardization](../plots/02_CPF_Normalize/METABRIC.jpg){#plot-7 width=100%}

![CPF Normal Standardization](../plots/02_CPF_Normalize/GSE96058N.jpg){#plot-8 width=100%}


