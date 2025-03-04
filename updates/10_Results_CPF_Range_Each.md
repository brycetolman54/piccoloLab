---
geometry: "margin=1in"
---

# More CPF Testing

- This update contains the results from the [CPF Range Each Script](../scripts/06_CPF_Range_Each.R)
- It is very similar to the [CPF Normalize Each Script](../script/05_CPF_Normalize_Each.R), so I will not be walking through the code, but rather showing the results of it.
- The only difference is I am using range normalization rather than standardization.
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
|           +           |  98  |  19  |
|           -           |  19  |  47  |

#### GSE25065 Metrics {#metrics-2} 

- Accuracy:     0.792 
- Precision:    0.838 
- Recall:       0.838 
- Specificity:  0.712 

#### GSE21653 Confusion Matrix {#matrix-3} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  142  |  43  |
|           -           |  8  |  70  |

#### GSE21653 Metrics {#metrics-3} 

- Accuracy:     0.806 
- Precision:    0.768 
- Recall:       0.947 
- Specificity:  0.619 

#### GSE58644 Confusion Matrix {#matrix-4} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  234  |  18  |
|           -           |  16  |  52  |

#### GSE58644 Metrics {#metrics-4} 

- Accuracy:     0.894 
- Precision:    0.929 
- Recall:       0.936 
- Specificity:  0.743 

#### GSE62944 Confusion Matrix {#matrix-5} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  709  |  122  |
|           -           |  76  |  108  |

#### GSE62944 Metrics {#metrics-5} 

- Accuracy:     0.805 
- Precision:    0.853 
- Recall:       0.903 
- Specificity:  0.47 

#### GSE81538 Confusion Matrix {#matrix-6} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  14  |  262  |
|           -           |  68  |  53  |

#### GSE81538 Metrics {#metrics-6} 

- Accuracy:     0.169 
- Precision:    0.051 
- Recall:       0.171 
- Specificity:  0.168 

#### METABRIC Confusion Matrix {#matrix-7} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  1446  |  165  |
|           -           |  52  |  274  |

#### METABRIC Metrics {#metrics-7} 

- Accuracy:     0.888 
- Precision:    0.898 
- Recall:       0.965 
- Specificity:  0.624 

#### GSE96058N Confusion Matrix {#matrix-8} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  177  |  1  |
|           -           |  86  |  26  |

#### GSE96058N Metrics {#metrics-8} 

- Accuracy:     0.7 
- Precision:    0.994 
- Recall:       0.673 
- Specificity:  0.963 

# Figures

![CPF Range Standardization Each](../plots/06_CPF_Range_Each/test.jpg){#plot-1 width=100%}

![CPF Range Standardization Each](../plots/06_CPF_Range_Each/GSE25065.jpg){#plot-2 width=100%}

![CPF Range Standardization Each](../plots/06_CPF_Range_Each/GSE21653.jpg){#plot-3 width=100%}

![CPF Range Standardization Each](../plots/06_CPF_Range_Each/GSE58644.jpg){#plot-4 width=100%}

![CPF Range Standardization Each](../plots/06_CPF_Range_Each/GSE62944.jpg){#plot-5 width=100%}

![CPF Range Standardization Each](../plots/06_CPF_Range_Each/GSE81538.jpg){#plot-6 width=100%}

![CPF Range Standardization Each](../plots/06_CPF_Range_Each/METABRIC.jpg){#plot-7 width=100%}

![CPF Range Standardization Each](../plots/06_CPF_Range_Each/GSE96058N.jpg){#plot-8 width=100%}
