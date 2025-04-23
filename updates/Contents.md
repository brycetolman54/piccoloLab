# Contents

0. [My Data Prep Workflow](./00_Workflow_DataPrep.md)
    - This contains the step-by-step instructions to replicate the things that I have done
1. [Data Sets](./01_DataSets.md)
    - This contains a description of the data sets we are working from, chosen from the Compendium created by Ifeanyichukwu Nwosu
    - It also contains specific notes about the data sets and things I did in merging the data
2. [Statistical Models Notes](./02_Notes_10_22.md)
    - This contains some of my notes as I read about the statistical methods used to correct for batch effects
3. [Machine Learning Model Notes](./03_Notes_10_29.md)
    - This contains some of my notes as I read about the machine learning methods used to integrate data sets/remove batch effects and noise.
    - It also contains many of my thoughts about the algorithm I want to create and issues I see with it.
    - Furthermore, it contains a description of my understanding of our project and its purpose.
4. [More Machine Learning Model Notes](./04_Notes_11_3.md)
    - This contains more of my notes, taken while reading even more about the subject of integrating data sets using machine learning models.
5. [Cross-Platform Testing with step_range()](./05_Workflow_CPF_Range.md)
    - This contains my workflow and results for testing how forcing data into a range affects prediction accuracy between data sets
6. [Cross-Platform Testing with step_normalize()](./06_Results_CPF_Normalize.md)
    - This contains my results for testing how standardizing data affects prediction accuracy between data sets.
7. [Cross-Platform Testing with No Normalization](./07_Results_CPF_None.md)
    - This contains my results for testing how not standardizing data affects the prediction accuracy across data sets.
8. [Cross-Platform Testing with Reduced Genes](./08_Results_CPF_Reduced.md)
    - This contains my results for testing how reducing the number of genes affects the prediction accuracy across data sets.
9. [Cross-Platform Testing with Normalization for each data set](./09_Workflow_CPF_Normalize_Each.md)
    - This contains my workflow and results for testing how normalizing each data set individually affects the prediction accuracy across data sets.
10. [Cross-Platform Testing with Range standardization for each data set](./10_Workflow_CPF_Range_Each.md)
    - This contains my results for testing how range standardizing each data set individually affects the prediction accuracy across data sets.
11. [Cross-Platform Testing with Platform as a feature](./11_CPF_Combined_Platform.md)
    - This contains my workflow and results for testing how using platform as a feature affects the accuracy of prediction across data sets.
    - I test also how having a combined data set affects the prediction accuracy on novel data.
12. [Cross-Platform Testing with a Combined Data set](./12_Results_CPF_Combined.md)
    - This contains my results for testing how training on a training set made of subsets of data from multiple different platforms affects testing on those different platforms, without including platform as a feature.
13. [Comparison of Data sets](./13_Workflow_Comparison.md)
    - This contains my workflow for comparing <i>GSE25055</i> and <i>GSE62944</i> on the gene expression and variance.
14. [Update on CPF Testing](./14_Notes_12_30.md)
    - This contains some notes from working with embedding space and combining those
    - This also contains an update with what I have seen with the different methods for CPF normalization techniques, my results from the work up to this point.
15. [Model Plan](./15_Model_Plan.md)
    - This contains the plan for how to make and train and test my model.
    - This contains a detailed outline of each of the components of my model and what they are for, and the code for each
16. [Standard Auto-Encoder](./16_Standard_Auto_Encoder.md)
    - This contains the walk through of my code that I use to generate the Standard Auto-Encoder for my model
17. [Adversarial Network](./17_Adversarial_Network.md)
    - This contains the walk through of my code that I use to create an adversarial network in order to conform my novel data set to the Standard
18. [Modifying Network (Part 1)](./18_Modifying_Network_Part_1.md)
    - This contains the data obtained as I work to modify my network to obtain optimal results
19. [Transferring Work](./19_Transferring_Work.md)
    - This contains the update about what I have done with the project and what I have seen that may be of use for further work
