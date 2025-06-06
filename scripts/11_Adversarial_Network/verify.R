# read in models and predict on data ###########################################

standardEncoder = load_model("models/10_Standard_Auto_Encoder/encoder.keras")
standardDecoder = load_model("models/10_Standard_Auto_Encoder/decoder.keras")
Encoder = load_model(paste0(models, "encoder_", novelName, ".keras"))

standardEmbed = standardEncoder |> predict(standardMat, verbose = 0)
trainEmbed = Encoder |> predict(trainMat, verbose = 0)
valEmbed = Encoder |> predict(valMat, verbose = 0)
testEmbed = Encoder |> predict(testMat, verbose = 0)

standardAfter = standardDecoder |> predict(standardEmbed, verbose = 0)
trainAfter = standardDecoder |> predict(trainEmbed, verbose = 0)
valAfter = standardDecoder |> predict(valEmbed, verbose = 0)
testAfter = standardDecoder |> predict(testEmbed, verbose = 0)

dataList = list(standardMat, trainMat, valMat, testMat,
                standardEmbed, trainEmbed, valEmbed, testEmbed,
                standardAfter, trainAfter, valAfter, testAfter)
typeNames = c("before", "embed", "after")
dataNames = c("standard", "train", "val", "test")

# show the metrics of the data sets ############################################

cat("\n")
cat("| Data Set | Max | Min | Mean | Median | SD |\n")
cat("|:---:|:---:|:---:|:---:|:---:|:---:|\n")

for(i in 1:12) {
    catMetrics(dataList[[i]],
               dataNames[((i - 1) %% 4) + 1],
               typeNames[ceiling(i / 4)])
}

cat("\n")

# make the data tibbles with classes again #####################################

standardBefore = tibblerize(standard, standardClasses)
trainBefore = tibblerize(train, trainClasses)
valBefore = tibblerize(val, valClasses)
testBefore = tibblerize(test, testClasses)

standardEmbed = tibblerize(standardEmbed, standardClasses)
trainEmbed = tibblerize(trainEmbed, trainClasses)
valEmbed = tibblerize(valEmbed, valClasses)
testEmbed = tibblerize(testEmbed, testClasses)

standardAfter = tibblerize(standardAfter, standardClasses)
trainAfter = tibblerize(trainAfter, trainClasses)
valAfter = tibblerize(valAfter, valClasses)
testAfter = tibblerize(testAfter, testClasses)

# do PCA of all combinations before, embedded, and after #######################

dataSets = c("trainBefore", "valBefore", "testBefore",
             "trainEmbed", "valEmbed", "testEmbed",
             "trainAfter", "valAfter", "testAfter")
standards = c("standardBefore", "standardEmbed", "standardAfter")

for(i in 1:9) {
    plotPCA(c(standards[ceiling(i / 3)], dataSets[i]),
            title = dataSets[i],
            folder = plots,
            filename = paste0(dataSets[i], "PCA"))
}

# bake recipes #################################################################

set.seed(42)

beforeRecipe = recipe(formula, data = standardBefore) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = standardBefore)
embedRecipe = recipe(formula, data = standardEmbed) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = standardEmbed)
afterRecipe = recipe(formula, data = standardAfter) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = standardAfter)

cat("\n")

recipes = list(beforeRecipe, embedRecipe, afterRecipe)

for(i in 1:3) {
    bakeFiles(standards[i],
              recipes[[i]])
}
for (i in 1:9) {
    bakeFiles(dataSets[i], 
              recipes[[ceiling(i / 3)]])
}

cat("\n")

# train the models #############################################################

set.seed(42)

beforeModel = rand_forest(trees = 25,
                    mode = "classification",
                    engine = "ranger")
embedModel = rand_forest(trees = 25,
                          mode = "classification",
                          engine = "ranger")
afterModel = rand_forest(trees = 25,
                          mode = "classification",
                          engine = "ranger")

beforeModelFit = beforeModel |> fit(formula, data = standardBefore)
embedModelFit = embedModel |> fit(formula, data = standardEmbed)
afterModelFit = afterModel |> fit(formula, data = standardAfter)

# predict on the data ##########################################################

dataList = list(trainBefore, valBefore, testBefore,
              trainEmbed, valEmbed, testEmbed,
              trainAfter, valAfter, testAfter)
models = list(beforeModelFit, embedModelFit, afterModelFit)

suppressWarnings({
    for(i in 1:9) {
        mdMetrics(models[[ceiling(i / 3)]],
                  dataList[[i]],
                  setName = dataSets[i])
    }
})
for(i in 1:9) {
    rocCurve(models[[ceiling(i / 3)]],
             dataList[[i]],
             filename = paste0(dataSets[i], "ROC"),
             folder = plots,
             title = paste0("Standard predicting on ", dataSets[i]))
}