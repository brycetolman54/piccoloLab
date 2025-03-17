# craft the recipe
recipe = recipe(formula, data = Standard) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = Standard)

# craft recipe for novel data separately
recipeNovel = recipe(formula, data = novel) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = novel)

# bake the data
bakeFiles(c("Standard", novelName), recipe)
bakeFiles(newNovelName, recipeNovel)

cat("\n")

# set seed again
set.seed(42)

# create, fit, and save the model
model = rand_forest(trees = 25,
                    mode = "classification",
                    engine = "ranger")
fitModel = model |> fit(formula, data = Standard)

# predict on the test data
suppressWarnings({
    mdOut = mdMetrics(fitModel,
                      get(novelName),
                      setName = novelName,
                      num = 1,
                      mdOutput = FALSE,
                      output = TRUE)
    mdOut2 = mdMetrics(fitModel,
                       get(newNovelName),
                       setName = newNovelName,
                       num = 2,
                       mdOutput = FALSE,
                       output = TRUE)
})

cat("| Plot Type | Standard Recipe | Novel Recipe |\n")
cat("|:---:|:---:|:---:|\n| ROC | ")

rcOut = rocCurve(fitModel,
                 get(novelName),
                 filename = novelName,
                 folder = plots,
                 title = "Initial Classification",
                 subtitle = paste0("METABRIC predicting on ", novelName),
                 num = 1,
                 plot = FALSE,
                 output = TRUE)
cat("\b\b | ")
rcOut2 = rocCurve(fitModel,
                  get(newNovelName),
                  filename = newNovelName,
                  folder = plots,
                  title = "Initial Classification Each Recipe",
                  subtitle = paste0("METABRIC predicting on ", newNovelName),
                  num = 2,
                  plot = FALSE,
                  output = TRUE)
cat("\b\b |\n| PCA | ")

# do PCA of the standard and novel
plotPCA(c("Standard", novelName),
        title = "Same Range Recipe PCA Plot",
        folder = plots,
        filename = paste0(novelName, "PCA"))
cat("\b | ")
plotPCA(c("Standard", newNovelName),
        title = "Separate Range Recipe PCA Plot",
        folder = plots,
        filename = paste0("rangeEach", novelName, "PCA"))
cat("\b |")

# print out some information
cat("\n\n  Stats:\n")
cat("    - Accuracy:\t", round((mdOut$metrics |> dplyr::filter(.metric == "accuracy"))$.estimate, 3), "\n")
cat("    - ROC AUC:\t", round(rcOut$auc$.estimate, 3), "\n")
cat("\n")

cat("  Stats Each Recipe:\n")
cat("    - Accuracy:\t", round((mdOut2$metrics |> dplyr::filter(.metric == "accuracy"))$.estimate, 3), "\n")
cat("    - ROC AUC:\t", round(rcOut2$auc$.estimate, 3), "\n")
cat("\n")

cat("\n")

