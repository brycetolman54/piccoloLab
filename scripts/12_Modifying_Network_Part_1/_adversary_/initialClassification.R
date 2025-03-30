# craft the recipe
recipe = recipe(formula, data = standarD) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = standarD)

# craft recipe for novel data separately
recipeNovel = recipe(formula, data = get(newNovelName)) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = get(newNovelName))

# bake the data
bakeFiles(c("standarD", "novel"), recipe)
bakeFiles(newNovelName, recipeNovel)

cat("\n")

# set seed again
set.seed(42)

# create, fit, and save the model
model = rand_forest(trees = 25,
                    mode = "classification",
                    engine = "ranger")
fitModel = model |> fit(formula, data = standarD)

# predict on the test data
suppressWarnings({
    mdOut = mdMetrics(fitModel,
                      novel,
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
                 novel,
                 filename = paste0(novelName, extraName),
                 folder = plots,
                 title = "Initial Classification",
                 subtitle = paste0("Standard predicting on ", novelName),
                 num = 1,
                 plot = FALSE,
                 output = TRUE)
cat("\b\b | ")
rcOut2 = rocCurve(fitModel,
                  get(newNovelName),
                  filename = paste0(newNovelName, extraName),
                  folder = plots,
                  title = "Initial Classification Each Recipe",
                  subtitle = paste0("Standard predicting on ", newNovelName),
                  num = 2,
                  plot = FALSE,
                  output = TRUE)
cat("\b\b |\n| PCA | ")

# do PCA of the standard and novel
plotPCA(c("standarD", "novel"),
        title = "Same Range Recipe PCA Plot",
        folder = plots,
        filename = paste0(novelName, extraName, "PCA"))
cat("\b | ")
plotPCA(c("standarD", newNovelName),
        title = "Separate Range Recipe PCA Plot",
        folder = plots,
        filename = paste0("rangeEach", novelName, extraName, "PCA"))
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

