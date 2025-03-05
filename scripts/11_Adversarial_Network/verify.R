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
               typeNames[ceiling(5 / 4)])
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

dataList = c("trainBefore", "valBefore", "testBefore",
             "trainEmbed", "valEmbed", "testEmbed",
             "trainAfter", "valAfter", "testAfter")
standards = c("standardBefore", "standardEmbed", "standardAfter")

for(i in 1:9) {
    plotPCA(c(standards[((i - 1) %% 3) + 1], dataList[i]),
            title = dataList[i],
            folder = plots,
            filename = dataList[i])
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

bakeFiles(before[1:4], 
          beforeRecipe,
          subfolder)
bakeFiles(embed[1:4], 
          embedRecipe,
          subfolder)
bakeFiles(after[1:4], 
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

beforeModelFit = beforeModel |> fit(formula, data = standardBefore)
embedModelFit = embedModel |> fit(formula, data = standardEmbed)
afterModelFit = afterModel |> fit(formula, data = standardAfter)

saveRDS(beforeModelFit, paste0(models, "before.rds"))
saveRDS(embedModelFit, paste0(models, "embed.rds"))
saveRDS(afterModelFit, paste0(models, "after.rds"))

# predict on the data ##########################################################

before = list(trainBefore, valBefore, after, beforeModelFit)
embed = list(trainEmbed, valEmbed, testEmbed, embedModelFit)
after = list(trainAfter, valAfter, testAfter, afterModelFit)

suppressWarnings({
    for(i in 1:3) {
        name = paste0(names[i + 1], " Before")
        mdMetrics(before[[4]],
                  before[[i]],
                  setName = name,
                  num = i)
        rocCurve(before[[4]],
                 before[[i]],
                 filename = paste0(name, "ROC"),
                 folder = plots,
                 title = name,
                 num = i)
    }
})

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

