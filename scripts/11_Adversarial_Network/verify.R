# read in models and predict on data ###########################################

if(!exists("Encoder") || !exists("standardEncoder") || !exists("standardDecoder")) {
    standardEncoder = load_model("models/10_Standard_Auto_Encoder/encoder.keras")
    standardDecoder = load_model("models/10_Standard_Auto_Encoder/decoder.keras")
    Encoder = load_model("models/11_Adversarial_Network/encoder.keras")
}

standardEmbed = standardEncoder |> predict(standardMat, verbose = 0)
trainEmbed = Encoder |> predict(trainMat, verbose = 0)
valEmbed = Encoder |> predict(valMat, verbose = 0)
testEmbed = Encoder |> predict(testMat, verbose = 0)

standardAfter = standardDecoder |> predict(standardEmbed, verbose = 0)
trainAfter = standardDecoder |> predict(trainEmbed, verbose = 0)
valAfter = standardDecoder |> predict(valEmbed, verbose = 0)
testAfter = standardDecoder |> predict(testEmbed, verbose = 0)

# show the metrics of the data sets ############################################

cat("\n")
cat("| Data Set | Max | Min | Mean | Median | SD |\n")
cat("|:---:|:---:|:---:|:---:|:---:|:---:|\n")

catMetrics(trainMat, "train", "before")
catMetrics(valMat, "val", "before")
catMetrics(testMat, "test", "before")
catMetrics(standardMat, "standard", "before")

catMetrics(trainEmbed, "train", "embedded")
catMetrics(valEmbed, "val", "embedded")
catMetrics(testEmbed, "test", "embedded")
catMetrics(standardEmbed, "standard", "embedded")

catMetrics(trainAfter, "train", "after")
catMetrics(valAfter, "val", "after")
catMetrics(testAfter, "test", "after")
catMetrics(standardAfter, "standard", "after")

cat("\n")

# make the data tibbles with classes again #####################################

standard = tibblerize(standard, standardClasses)
train = tibblerize(train, trainClasses)
val = tibblerize(val, valClasses)
test = tibblerize(test, testClasses)

standardEmbed = tibblerize(standardEmbed, standardClasses)
trainEmbed = tibblerize(trainEmbed, trainClasses)
valEmbed = tibblerize(valEmbed, valClasses)
testEmbed = tibblerize(testEmbed, testClasses)

standardAfter = tibblerize(standardAfter, standardClasses)
trainAfter = tibblerize(trainAfter, trainClasses)
valAfter = tibblerize(valAfter, valClasses)
testAfter = tibblerize(testAfter, testClasses)

# do PCA of all combinations before, embedded, and after #######################

plotPCA(c("standard", "train"),
        title = "Train Before",
        folder = plots,
        filename = "trainBefore")
plotPCA(c("standard", "val"),
        title = "Val Before",
        folder = plots,
        filename = "valBefore")
plotPCA(c("standard", "test"),
        title = "Test Before",
        folder = plots,
        filename = "testBefore")

plotPCA(c("standardEmbed", "trainEmbed"),
        title = "Train Embedded",
        folder = plots,
        filename = "trainEmbed")
plotPCA(c("standardEmbed", "valEmbed"),
        title = "Val Embedded",
        folder = plots,
        filename = "valEmbed")
plotPCA(c("standardEmbed", "testEmbed"),
        title = "Test Embedded",
        folder = plots,
        filename = "testEmbed")

plotPCA(c("standardAfter", "trainAfter"),
        title = "Train After",
        folder = plots,
        filename = "trainAfter")
plotPCA(c("standardAfter", "valAfter"),
        title = "Val After",
        folder = plots,
        filename = "valAfter")
plotPCA(c("standardAfter", "testAfter"),
        title = "Test After",
        folder = plots,
        filename = "testAfter")

# bake recipes #################################################################

set.seed(42)

formula = Class ~ .

beforeRecipe = recipe(formula, data = standard) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = standard)
embedRecipe = recipe(formula, data = standardEmbed) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = standardEmbed)
afterRecipe = recipe(formula, data = standardAfter) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = standardAfter)

cat("\n")

bakeFiles(c("standard", "train", "val", "test"), 
          beforeRecipe,
          subfolder)
bakeFiles(c("standardEmbed", "trainEmbed", "valEmbed", "testEmbed"), 
          embedRecipe,
          subfolder)
bakeFiles(c("standardAfter", "trainAfter", "valAfter", "testAfter"), 
          afterRecipe,
          subfolder)

cat("\n")

saveRDS(beforeRecipe, paste0(recipes, "before.rds"))
saveRDS(embedRecipe, paste0(recipes, "embed.rds"))
saveRDS(afterRecipe, paste0(recipes, "after.rds"))

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

beforeModelFit = beforeModel |> fit(formula, data = standard)
embedModelFit = embedModel |> fit(formula, data = standardEmbed)
afterModelFit = afterModel |> fit(formula, data = standardAfter)

saveRDS(beforeModelFit, paste0(models, "before.rds"))
saveRDS(embedModelFit, paste0(models, "embed.rds"))
saveRDS(afterModelFit, paste0(models, "after.rds"))

# predict on the data ##########################################################

suppressWarnings({
    mdMetrics(beforeModelFit,
              train,
              setName = "Train Before",
              num = 1)
    mdMetrics(beforeModelFit,
              val,
              setName = "Val Before",
              num = 2)
    mdMetrics(beforeModelFit,
              test,
              setName = "Test Before",
              num = 3)
    
    mdMetrics(embedModelFit,
              trainEmbed,
              setName = "Train Embed",
              num = 4)
    mdMetrics(embedModelFit,
              valEmbed,
              setName = "Val Embed",
              num = 5)
    mdMetrics(embedModelFit,
              testEmbed,
              setName = "Test Embed",
              num = 6)
    
    mdMetrics(afterModelFit,
              trainAfter,
              setName = "Train After",
              num = 7)
    mdMetrics(afterModelFit,
              valAfter,
              setName = "Val After",
              num = 8)
    mdMetrics(afterModelFit,
              testAfter,
              setName = "Test After",
              num = 9)
})

rocCurve(beforeModelFit,
         train,
         filename = "trainBeforeROC",
         folder = plots,
         title = "Train Before",
         num = 1)
rocCurve(beforeModelFit,
         val,
         filename = "valBeforeROC",
         folder = plots,
         title = "Val Before",
         num = 2)
rocCurve(beforeModelFit,
         test,
         filename = "testBeforeROC",
         folder = plots,
         title = "Test Before",
         num = 3)

rocCurve(embedModelFit,
         trainEmbed,
         filename = "trainEmbedROC",
         folder = plots,
         title = "Train Embed",
         num = 4)
rocCurve(embedModelFit,
         valEmbed,
         filename = "valEmbedROC",
         folder = plots,
         title = "Val Embed",
         num = 5)
rocCurve(embedModelFit,
         testEmbed,
         filename = "testEmbedROC",
         folder = plots,
         title = "Test Embed",
         num = 6)

rocCurve(afterModelFit,
         trainAfter,
         filename = "trainAfterROC",
         folder = plots,
         title = "Train After",
         num = 7)
rocCurve(afterModelFit,
         valAfter,
         filename = "valAfterROC",
         folder = plots,
         title = "Val After",
         num = 8)
rocCurve(afterModelFit,
         testAfter,
         filename = "testAfterROC",
         folder = plots,
         title = "Test After",
         num = 9)

