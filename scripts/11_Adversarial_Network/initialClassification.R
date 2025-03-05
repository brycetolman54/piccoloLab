# define the formula for later use
formula = Class ~ .

# craft the recipe
recipe = recipe(formula, data = METABRIC) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = METABRIC)

# craft recipe for novel data separately
recipeNovel = recipe(formula, data = GSE62944) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = GSE62944)

# bake the novel by itself first
newGSE62944 = GSE62944

# bake the data
bakeFiles(dataSets, recipe)
bakeFiles("newGSE62944", recipeNovel)

cat("\n")

# set seed again
set.seed(42)

# create, fit, and save the model
model = rand_forest(trees = 25,
                    mode = "classification",
                    engine = "ranger")
fitModel = model |> fit(formula, data = METABRIC)

# predict on the test data
dataSetVars = mget(dataSets)
suppressWarnings({
    mdOut = mdMetrics(fitModel,
                      dataSetVars[[2]],
                      setName = dataSets[2],
                      num = 1,
                      mdOutput = FALSE,
                      output = TRUE)
    mdOut2 = mdMetrics(fitModel,
                       newGSE62944,
                       setName = "newGSE62944",
                       num = 2,
                       mdOutput = FALSE,
                       output = TRUE)
})
rcOut = rocCurve(fitModel,
                 dataSetVars[[2]],
                 filename = dataSets[2],
                 folder = plots,
                 title = "Initial Classification",
                 subtitle = paste0("METABRIC predicting on ", dataSets[2]),
                 num = 1,
                 plot = FALSE,
                 output = TRUE)
rcOut2 = rocCurve(fitModel,
                  newGSE62944,
                  filename = "newGSE62944",
                  folder = plots,
                  title = "Initial Classification Each Recipe",
                  subtitle = "METABRIC predicting on newGSE62944",
                  num = 2,
                  plot = FALSE,
                  output = TRUE)

# print out some information
cat("  Stats:\n")
cat("    Accuracy:\t", round((mdOut$metrics |> dplyr::filter(.metric == "accuracy"))$.estimate, 3), "\n")
cat("    ROC AUC:\t", round(rcOut$auc$.estimate, 3), "\n")
cat("\n")

cat("  Stats Each Recipe:\n")
cat("    Accuracy:\t", round((mdOut2$metrics |> dplyr::filter(.metric == "accuracy"))$.estimate, 3), "\n")
cat("    ROC AUC:\t", round(rcOut2$auc$.estimate, 3), "\n")

# do PCA of the standard and novel (shaped by its own recipe)
plotPCA(c("METABRIC", "newGSE62944"),
        title = "Separate Range PCA Plot",
        mdOutput = FALSE,
        folder = plots,
        filename = "rangeEach")
cat("\n")

