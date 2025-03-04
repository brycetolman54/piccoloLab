- [X] Read up on deep learning and combining data from different platforms

- [X] Learn about things like Combat

- [X] Look at adversarial networks and the like, look at supervised learning for combining data sets

- [X] Download updates from Dr. Piccolo to have them in the repo

- [X] Try doing your previous work (with training on GSE25055) but do a `step_range()` and see how that does on things like METABRIC and RNA Seq
    - [X] Don't add platform to this data
    - [X] Document this work

- [X] Do your previous work again, but get it in a script (just a normalize recipe)

- [X] Do the same thing but with no step function to normalize the data in any way

- [X] Make a recipe for each individual data set (the range one or the normalization one) to see how that works

- [X] Do Cross validation on an RNA Seq data set to make sure it can classify correctly (maybe test on itself, on another RNA seq, and on an affymetrix)

- [X] Train a model with the platform as one of the features
    - [X] Document your work
    - [X] Combine data from all models (take part as the training set and part as the test set)
    - [X] We want a similar balance of 0/1 class in the train as we have in the whole data set, figure out how to do that.

- [X] Do PCA on the data to visualize it in two dimensions
    - [X] Write a function to do PCA down to two dimensions and plot the result, since I think I will be wanting to do that a lot

- [X] Fix the PCA to find the genes to include rather than the PCA components

- [X]] Combine all Plots in a table to show the results (not PCA plots, the ROC Curves)
    - [X] Find a way to do this in markdown

- [X] Update the ROC Curve function to show the area on the graph

- [X] Create a histogram for <i>GSE62944</i> that shows variance per gene
- [X] Create a histogram for <i>GSE62944</i> that shows average expression per gene
    - [X]] Find a number of bins that works to show this well (maybe have two plot, one where you restrict the range a lot)
- [X] Create a scatter plot showing gene expression for <i>GSE62944</i> on x and <i>GSE25055</i> on y

- [X] Update the ROC plot function with description and title
- [X] Run everything again and pdoc it

- [X] Check that normalize and range are actually doing something
- [X] Have an update that is about what you are doing with that (explain in some notes section about it where you explain your results, reference your script, you need to save the recipe and model, and what you found, talk about your results with the different processes you did in the roc curves document, talk about justification for your idea, i.e. other normalization stinks and you can't normalize the test data, and explain your idea to make a "recipe" model at the end of combination [and concerns here])
- [X] Do histograms for ranged/normalized data to see it (do this in the update above I guess)
- [X] Do some PCA of those data sets too (also in the update above)

- [X] Fix the 00 script to get the right thing for all data sets
- [X] Rerun all scripts (with new gene sets)

- [X] Look at the other data sets and maybe add them to our sets
- [X] Maybe add the other <i>GSE96058</i> as well

- [X] Find the reduced subset of genes before rerunning 4

- [ ] Start making your model
    - [X] Draw up your steps/plan before anything else (make a modelPlan.md or something similar)
    - [X] Update your drawing of the model to make it look better and include the final Autoencoder "Recipe"
    - [X] Train with 100 genes or so first like you did previously
    - [X] Implement the First Autoencoder
        - [X] Test out what it is like with 2 dimensions compared to PCA
        - [X] Optimize the number of layers, activation function, number of dimensions kept, to get the lowest MSE (DONT DO ANYTHING WITH TEST DATA UNTIL THE END)
        - [ ] Maybe rerun multiple times with a different seed to be able to compare the test to the validation set (by a t-test) to see if they are really different
    - [ ] Implement the Discriminator
    - [ ] Look at classification (like you said to in your plan)
    - [ ] Document your work
    - [ ] Do PCA of METABRIC, then reduce to two dimensions to compare (qualitatively...)
    - [ ] Keep track of your optimizations in case you need them for the paper

- [X] Do PCA of transformed standard (after Decoder) to compare to before
- [X] Look at the stats of the transformed data (like you did before making the AutoEncoder)



- [ ] Conform GSE25655
- [ ] Train tree on that, predict on GSE62944
- [ ] After conforming both, add label of data set and see if the model can distinguish them
- [ ] Randomly select 10 genes instead of using the PCA ones from lessGenes and see if you get similar results
