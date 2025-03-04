---
geometry: "margin=1in"
---

# Adversarial Network

- This contains the contents obtained form the [Adversarial Network Script](../scripts/17_Adversarial_Network)

# Optimization Data

| Encoder Layers | Discriminator Layers | Discriminator Units | Function | Discriminator Function | Optimizer | Dropout | Batch Size | Epochs | Val Max | Standard Max | Rel SD Val | Rel SD Standard | Val Accuracy |
|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:---:|
| 2 | 4 | 32 | elu | elu | adam | FALSE | 16 | 100 | 0.049 | 13044.8 | 100 |
| 2 | 4 | 32 | elu | elu | adam | FALSE | 32 | 100 | 0.030 | 23838.76 | 100 |
| 2 | 4 | 32 | elu | elu | adam | FALSE | 48 | 100 | 0.036 | 24941.88 | 99.5 |
| 2 | 4 | 32 | elu | elu | adam | FALSE | 64 | 100 | 0.048 | 10426.83 | 99.1 |
| 2 | 4 | 32 | elu | elu | adam | FALSE | 128 | 100 | 0.04 | 26039.08 | 99.5 |
| 2 | 3 | 32 | elu | elu | adam | FALSE | 64 | 100 | 0.05 | 13425.99 | 100 |
| 2 | 3 | 64 | elu | elu | adam | FALSE | 64 | 100 | 0.038 | 20622.38 | 100 |
| 2 | 4 | 64 | elu | elu | adam | FALSE | 64 | 100 | 0.043 | 13677.62 | 100 |
| 3 | 3 | 32 | elu | elu | adam | FALSE | 64 | 96 | 0.051 | 7886.641 | 46.7 |
| 3 | 3 | 32 | elu | elu | adam | FALSE | 64 | 200 | 0.053 | 4244.374 | 95.8 |
| 4 | 3 | 32 | elu | elu | adam | FALSE | 64 | 200 | 0.062 | 458.098 | 78.5 |
| 4 | 4 | 32 | elu | elu | adam | FALSE | 64 | 100 | 0.122 | 495.909 | 96.7 |
| 5 | 4 | 32 | elu | elu | adam | FALSE | 64 | 100 | 0.088 | 112.122 | 87.4 |
| 5 | 5 | 32 | elu | elu | adam | FALSE | 64 | 200 | 0.138 | 17.097 | 98.1 |
| 6 | 5 | 32 | elu | elu | adam | FALSE | 64 | 200 | 0.049 | 268.46 | 99.1 |
| 5 | 3 | 32 | elu | elu | adam | FALSE | 64 | 200 | 0.051 | 439.732 | 55.1 
| 6 | 4 | 32 | elu | elu | adam | FALSE | 64 | 200 | 0.056 | 80.943 | 88.3 |
| 3 | 2 | 32 | elu | elu | adam | FALSE | 64 | 200 | 0.045 | 6614.648 | 5.6 |
| 5 | 4 | 48 | elu | elu | adam | FALSE | 64 | 200 | 0.044 | 94.202 | 99.5 |
| 5 | 3 | 64 | elu | elu | adam | FALSE | 64 | 200 | 0.076 | 38.41 | 98.6 |
| 5 | 4 | 64 | elu | relu | adam | FALSE | 64 | 300 | 0.573 | 3.63 | 100 |
| 5 | 4 | 32 | elu | relu | adam | FALSE | 64 | 200 | 0.092 | 32.612 | 97.7 |
| 5 | 4 | 48 | elu | elu | adam | FALSE | 64 | 200 | 0.088 | 50.68 | 95.8 |
| 5 | 4 | 32 | elu | elu | adam | FALSE | 64 | 200 | 0.143 | 17.353 | 79.4 |
| 7 | 5 | 48 | elu | elu | adam | FALSE | 64 | 250 | 0.204 | 7.021 | 31.3 |
<!-- Now add Normalization -->
| 5 | 4 | 32 | elu | elu | adam | FALSE | 64 | 30 | 0.11 | 295670.8 | 0 |
| 5 | 3 | 32 | elu | elu | adam | FALSE | 64 | 30 | 0.166 | 12291966 | 0.5 |
| 3 | 3 | 32 | elu | elu | adam | FALSE | 64 | 30 | 0.14 | 334173.9 | 0 |
| 6 | 3 | 32 | elu | elu | adam | FALSE | 64 | 100 | 0.037 | 920406.8 | 0 |
<!-- With the updated algorithm to use fit() -->
| 5 | 4 | 32 | elu | elu | adam | FALSE | 64 | 300 | 0.106 | 17.269 | 99.1 |
<!-- norm -->
| 5 | 4 | 32 | elu | elu | adam | FALSE | 64 | 300 | 0.506 | 4.568 | 100 |
<!-- stopped shuffling myself -->
| 5 | 4 | 32 | elu | elu | adam | FALSE | 64 | 300 | 0.577 | 8.563 | 99.1 |
<!-- lr=0.0001 -->
| 5 | 4 | 32 | elu | elu | adam | FALSE | 64 | 300 | 0.069 | 71.4 | 98.1 |
| 6 | 4 | 32 | elu | elu | adam | FALSE | 64 | 300 | 0.099 | 67.326 | 99.1 |
| 6 | 4 | 32 | elu | elu | adam | FALSE | 64 | 500 | 0.051 | 114.735 | 99.5 |
| 7 | 4 | 32 | elu | elu | adam | FALSE | 64 | 500 | 0.056 | 193.471 | 39.7 |
| 7 | 5 | 32 | elu | elu | adam | FALSE | 64 | 500 | 0.159 | 45.534 | 70.1 |
<!-- lr = 0.0002 -->
| 7 | 5 | 32 | elu | elu | adam | FALSE | 64 | 500 | 0.153 | 25.306 | 39.3 |
| 7 | 5 | 64 | elu | elu | adam | FALSE | 64 | 500 | 0.109 | 84.613 | 64 |
| 6 | 3 | 64 | elu | elu | adam | FALSE | 64 | 500 | 0.097 | 20.518 | 97.2 |
| 7 | 5 | 32 | elu | elu | adam | FALSE | 64 | 312 | 0.073 | 115.092 | 50 |
| 7 | 5 | 32 | elu | elu | adam | FALSE | 64 | 1000 | 0.135 | 27.735 | 22.9 |

