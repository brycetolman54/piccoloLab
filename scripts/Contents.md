# Contents

0. [Gathering Data](./00_Gathering_Data.R)
    - This is the script containing the code for [Update 0](../updates/00_Workflow_DataPrep.md)
    - The purpose of this code is to get the data sets ready for further processing.
1. [Cross-Platform Testing with Range](./01_CPF_Range.R)
    - This is the script containing code for [Update 5](../updates/05_Workflow_CPF_Range.md)
    - The purpose of this code is to test how well a machine learning model trained on one set of data from one platform performs on a set of data obtained from a different platform.
2. [More CPF Testing with Standardization](./02_CPF_Normalize.R)
    - This is the script containing code for [Update 6](../updates/06_Results_CPF_Normalize.md)
    - The purpose of this code is similar to that above, but using the `step_normalize()` technique in the recipe rather than the `step_range()` technique.
3. [More CPF Testing with No Standardization](./03_CPF_None.R)
    - This is the script containing code for [Update 7](../updates/07_Results_CPF_None.md)
    - The purpose of this code is similar to those above, but not using any standardization. This serves as a sort of baseline for future comparison.
4. [More CPF Testing with Reduced Data](./04_CPF_Reduced.R)
    - This is the script containing code for [Update 8](../updates/08_Results_CPF_Reduced.md)
    - The purpose of this code is similar to those above, but only using a reduced number of genes in the analysis.
5. [More CPF Testing with Normalizing Each data set](./05_CPF_Normalize_Each.R)
    - This is the script containing code for [Update 9](../updates/09_Workflow_CPF_Normalize_Each.md)
    - The purpose of this code is similar to those above, but standardizing each data set individually rather than based on the `train` data set
6. [More CPF Testing with Ranging Each data set](./06_CPF_Range_Each.R)
    - This is the script containing code for [Update 10](../updates/10_Results_CPF_Range_Each.md)
    - The purpose of this code is similar to those above, but standardizing each data set with a range individually rather than based on the `train` data set
7. [More CPF Testing with Platform as a Feature on a combine data set](./07_CPF_Combined_Platform.R)
    - This is the script containing code for [Update 11](../updates/11_Workflow_CPF_Combined_Platform.md)
    - The purpose of this code is to test how including the platform used for collection as a feature will affect the prediction on novel, diverse data sets.
8. [More CPF Testing with a combine training data set](./08_CPF_Combined.R)
    - This is the script containing code for [Update 12](../updates/12_Results_CPF_Combined.md)
    - The purpose of this code is to test how including data from different platforms affects the prediction accuracy on novel data sets from different platforms.
9. [Data set comparison](./09_Comparison.R)
    - This the script containing code for [Update 13](../updates/13_Comparison.md)
    - The purpose of this code is to compare the gene expression and variance of data sets from different platforms (RNA seq vs. Affymetrix)
10. [Standard Auto-Encoder](./10_Standard_Auto_Encoder.R)
    - This contains the script that I use to create the Standard Auto-Encoder for the model
    - This is part one of my plan
11. [Adversarial Network](./11_Adversarial_Network)
    - This contains the scripts that I use to conform my novel data set to the standard
    - This is part two of my plan
12. [Modifying the Network](./12_Modifying_Network_Part_1)
    - This contains the scripts that I use to test different variations of the models I started in scripts 10 and 11
    - This is a continuation of parts 1 and 2 of my plan
