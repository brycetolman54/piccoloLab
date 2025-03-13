---
geometry: "margin=0.5in"
---

![Two dimensional PCA plot of beforeGSE25055, beforeGSE62944](../plots/11_Adversarial_Network/distinguish/beforePCA.jpg){width=100%}

![Two dimensional PCA plot of embedGSE25055, embedGSE62944](../plots/11_Adversarial_Network/distinguish/embedPCA.jpg){width=100%}

![Two dimensional PCA plot of afterGSE25055, afterGSE62944](../plots/11_Adversarial_Network/distinguish/afterPCA.jpg){width=100%}

#### Before Conformation Confusion Matrix {#matrix-1} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  10  |  36  |
|           -           |  775  |  194  |

#### Before Conformation Metrics {#metrics-1} 

- Accuracy:     0.201 
- Precision:    0.217 
- Recall:       0.013 
- Specificity:  0.843 

#### During Conformation Confusion Matrix {#matrix-2} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  726  |  202  |
|           -           |  59  |  28  |

#### During Conformation Metrics {#metrics-2} 

- Accuracy:     0.743 
- Precision:    0.782 
- Recall:       0.925 
- Specificity:  0.122 

#### After Conformation Confusion Matrix {#matrix-3} 

|   Predicted/Actual    |   +   |   -   |
| :-------------------: | :---: | :---: |
|           +           |  680  |  190  |
|           -           |  105  |  40  |

#### After Conformation Metrics {#metrics-3} 

- Accuracy:     0.709 
- Precision:    0.782 
- Recall:       0.866 
- Specificity:  0.174 

![The area under the ROC Curve is 0.387](../plots/11_Adversarial_Network/distinguish/beforeROC.jpg){#plot-1 width=100%}

![The area under the ROC Curve is 0.499](../plots/11_Adversarial_Network/distinguish/embedROC.jpg){#plot-2 width=100%}

![The area under the ROC Curve is 0.551](../plots/11_Adversarial_Network/distinguish/afterROC.jpg){#plot-1 width=100%}
