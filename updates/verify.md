---
geometry: "margin=1in"
---

# Data Metrics

| Data Set | Max | Min | Mean | Median | SD |
|:---:|:---:|:---:|:---:|:---:|:---:|
| train [before] | 175503.8 | 0 | 1889.474 | 1182.106 | 3273.683 |
| val [before] | 301461.9 | 0 | 1863.059 | 1191.859 | 3494.898 |
| test [before] | 136651.2 | 0 | 1886.504 | 1203.146 | 3063.193 |
| standard [before] | 5.824 | -7.312 | 0.002 | 0.038 | 0.997 |
| train [embedded] | 7.191 | -15.518 | -0.077 | 0.055 | 2.031 |
| val [embedded] | 23.02 | -17.997 | -0.223 | 0.012 | 2.961 |
| test [embedded] | 19.108 | -33.699 | -0.234 | 0.066 | 3.126 |
| standard [embedded] | 8.372 | -17.114 | -0.121 | -0.021 | 2.131 |
| train [after] | 3.131 | -7.069 | 0.016 | 0.073 | 0.763 |
| val [after] | 8.763 | -10.404 | -0.054 | 0.037 | 1.069 |
| test [after] | 9.739 | -18.482 | -0.089 | 0.032 | 1.124 |
| standard [after] | 4.522 | -6.133 | 0.001 | 0.056 | 0.796 |

# Prediction Metrics

#### Train Before Confusion Matrix {#matrix-1}

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  0  |  0  |
|           -           |  382  |  114  |

#### Train Before Metrics {#metrics-1}

- Accuracy:     0.23
- Precision:    NA
- Recall:       0
- Specificity:  1

#### Val Before Confusion Matrix {#matrix-2}

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  0  |  0  |
|           -           |  163  |  51  |

#### Val Before Metrics {#metrics-2}

- Accuracy:     0.238
- Precision:    NA
- Recall:       0
- Specificity:  1

#### Test Before Confusion Matrix {#matrix-3}

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  0  |  0  |
|           -           |  240  |  65  |

#### Test Before Metrics {#metrics-3}

- Accuracy:     0.213
- Precision:    NA
- Recall:       0
- Specificity:  1

#### Train Embed Confusion Matrix {#matrix-4}

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  317  |  87  |
|           -           |  65  |  27  |

#### Train Embed Metrics {#metrics-4}

- Accuracy:     0.694
- Precision:    0.785
- Recall:       0.83
- Specificity:  0.237

#### Val Embed Confusion Matrix {#matrix-5}

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  119  |  35  |
|           -           |  44  |  16  |

#### Val Embed Metrics {#metrics-5}

- Accuracy:     0.631
- Precision:    0.773
- Recall:       0.73
- Specificity:  0.314

#### Test Embed Confusion Matrix {#matrix-6}

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  203  |  47  |
|           -           |  37  |  18  |

#### Test Embed Metrics {#metrics-6}

- Accuracy:     0.725
- Precision:    0.812
- Recall:       0.846
- Specificity:  0.277

#### Train After Confusion Matrix {#matrix-7}

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  306  |  87  |
|           -           |  76  |  27  |

#### Train After Metrics {#metrics-7}

- Accuracy:     0.671
- Precision:    0.779
- Recall:       0.801
- Specificity:  0.237

#### Val After Confusion Matrix {#matrix-8}

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  119  |  35  |
|           -           |  44  |  16  |

#### Val After Metrics {#metrics-8}

- Accuracy:     0.631
- Precision:    0.773
- Recall:       0.73
- Specificity:  0.314

#### Test After Confusion Matrix {#matrix-9}

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  197  |  48  |
|           -           |  43  |  17  |

#### Test After Metrics {#metrics-9}

- Accuracy:     0.702
- Precision:    0.804
- Recall:       0.821
- Specificity:  0.262



# Plots

![The area under the ROC Curve is 0.491](../plots/11_Adversarial_Network/verify/trainBeforeROC.jpg){#plot-1 width=100%}

![The area under the ROC Curve is 0.503](../plots/11_Adversarial_Network/verify/valBeforeROC.jpg){#plot-2 width=100%}

![The area under the ROC Curve is 0.504](../plots/11_Adversarial_Network/verify/testBeforeROC.jpg){#plot-3 width=100%}

![The area under the ROC Curve is 0.554](../plots/11_Adversarial_Network/verify/trainEmbedROC.jpg){#plot-4 width=100%}

![The area under the ROC Curve is 0.564](../plots/11_Adversarial_Network/verify/valEmbedROC.jpg){#plot-5 width=100%}

![The area under the ROC Curve is 0.566](../plots/11_Adversarial_Network/verify/testEmbedROC.jpg){#plot-6 width=100%}

![The area under the ROC Curve is 0.57](../plots/11_Adversarial_Network/verify/trainAfterROC.jpg){#plot-7 width=100%}

![The area under the ROC Curve is 0.559](../plots/11_Adversarial_Network/verify/valAfterROC.jpg){#plot-8 width=100%}

![The area under the ROC Curve is 0.551](../plots/11_Adversarial_Network/verify/testAfterROC.jpg){#plot-9 width=100%}



![Two dimensional PCA plot of standard, train](../plots/11_Adversarial_Network/verify/trainBefore.jpg){width=100%}
![Two dimensional PCA plot of standard, val](../plots/11_Adversarial_Network/verify/valBefore.jpg){width=100%}
![Two dimensional PCA plot of standard, test](../plots/11_Adversarial_Network/verify/testBefore.jpg){width=100%}
![Two dimensional PCA plot of standardEmbed, trainEmbed](../plots/11_Adversarial_Network/verify/trainEmbed.jpg){width=100%}
![Two dimensional PCA plot of standardEmbed, valEmbed](../plots/11_Adversarial_Network/verify/valEmbed.jpg){width=100%}
![Two dimensional PCA plot of standardEmbed, testEmbed](../plots/11_Adversarial_Network/verify/testEmbed.jpg){width=100%}
 ![Two dimensional PCA plot of standardOut, trainOut](../plots/11_Adversarial_Network/verify/trainAfter.jpg){width=100%}
![Two dimensional PCA plot of standardOut, valOut](../plots/11_Adversarial_Network/verify/valAfter.jpg){width=100%}
![Two dimensional PCA plot of standardOut, testOut](../plots/11_Adversarial_Network/verify/testAfter.jpg){width=100%}

