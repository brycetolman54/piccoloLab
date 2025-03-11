# load libraries
library(tidymodels)
source("functions/readFiles.R")
source("functions/bakeFiles.R")
source("functions/rocCurve.R")
source("functions/mdMetrics.R")
source("functions/plotPCA.R")

# make a function
tibblerize = function(data, classes) {
    data = as_tibble(data, .name_repair = ~paste0("col_", seq_len(ncol(data))))
    data = bind_cols(data, classes)
    return(data)
}

# load the Encoders and Decoder
decoder = load_model("models/10_Standard_Auto_Encoder/decoder.keras")
encoderGSE25055 = load_model("models/11_Adversarial_Network/encoder_GSE25055.keras")
encoderGSE62944 = load_model("models/11_Adversarial_Network/encoder_GSE62944.keras")

# load the data
genes = readLines("variables/lessGenes.txt")[1:100]
if(!exists("GSE25055") || !exists("GSE62944")) {
    readFiles(c("GSE25055", "GSE62944"), columns = c("Class", genes))
}
cat("\n")

# set some variables
formula = Class ~ .

classesGSE25055 = GSE25055 |> select(Class)
classesGSE62944 = GSE62944 |> select(Class)

# get the data sets

matGSE25055 = as.matrix(GSE25055 |> select(-Class))
matGSE62944 = as.matrix(GSE62944 |> select(-Class))

beforeGSE25055 = GSE25055
beforeGSE62944 = GSE62944

embedMatGSE25055 = encoderGSE25055 |> predict(matGSE25055, verbose = 0)
embedMatGSE62944 = encoderGSE62944 |> predict(matGSE62944, verbose = 0)

afterMatGSE25055 = decoder |> predict(embedMatGSE25055, verbose = 0)
afterMatGSE62944 = decoder |> predict(embedMatGSE62944, verbose = 0)

embedGSE25055 = tibblerize(embedMatGSE25055, classesGSE25055)
embedGSE62944 = tibblerize(embedMatGSE62944, classesGSE62944)

afterGSE25055 = tibblerize(afterMatGSE25055, classesGSE25055)
afterGSE62944 = tibblerize(afterMatGSE62944, classesGSE62944)

# make recipes
beforeRecipe = recipe(formula, data = beforeGSE25055) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = beforeGSE25055)

embedRecipe = recipe(formula, data = embedGSE25055) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = embedGSE25055)

afterRecipe = recipe(formula, data = afterGSE25055) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = afterGSE25055)

# make the models
before = rand_forest(trees = 25,
                          mode = "classification",
                          engine = "ranger")
embed = rand_forest(trees = 25,
                         mode = "classification",
                         engine = "ranger")
after = rand_forest(trees = 25,
                         mode = "classification",
                         engine = "ranger")

# bake the data
bakeFiles(c("beforeGSE25055", "beforeGSE62944"), beforeRecipe)
bakeFiles(c("embedGSE25055", "embedGSE62944"), embedRecipe)
bakeFiles(c("afterGSE25055", "afterGSE62944"), afterRecipe)
cat("\n")

# train the models
beforeFit = before |> fit(formula, data = beforeGSE25055)
embedFit = embed |> fit(formula, data = embedGSE25055)
afterFit = after |> fit(formula, data = afterGSE25055)

# do the pca
plotPCA(c("beforeGSE25055", "beforeGSE62944"),
        title = "Before Conformation",
        folder = "plots/11_Adversarial_Network/distinguish/",
        filename = "beforePCA")
plotPCA(c("embedGSE25055", "embedGSE62944"),
        title = "During Conformation",
        folder = "plots/11_Adversarial_Network/distinguish/",
        filename = "embedPCA")
plotPCA(c("afterGSE25055", "afterGSE62944"),
        title = "After Conformation",
        folder = "plots/11_Adversarial_Network/distinguish/",
        filename = "afterPCA")
cat("\n")

# get the metrics
suppressWarnings({
    mdMetrics(beforeFit,
              beforeGSE62944,
              setName = "Before Conformation",
              num = 1)
    mdMetrics(embedFit,
              embedGSE62944,
              setName = "During Conformation",
              num = 2)
    mdMetrics(afterFit,
              afterGSE62944,
              setName = "After Conformation",
              num = 3)
})

# do the ROC
rocCurve(beforeFit,
         beforeGSE62944,
         filename = "beforeROC",
         folder = "plots/11_Adversarial_Network/distinguish/",
         title = "Before Conformation",
         subtitle = "GSE25055 predicting on GSE62944",
         num = 1)
rocCurve(embedFit,
         embedGSE62944,
         filename = "embedROC",
         folder = "plots/11_Adversarial_Network/distinguish/",
         title = "During Conformation",
         subtitle = "GSE25055 predicting on GSE62944",
         num = 2)
rocCurve(afterFit,
         afterGSE62944,
         filename = "afterROC",
         folder = "plots/11_Adversarial_Network/distinguish/",
         title = "After Conformation",
         subtitle = "GSE25055 predicting on GSE62944",
         num = 1)

suppressWarnings({
    rm(
        bakeFiles,
        beforeGSE25055,
        beforeGSE62944,
        classesGSE25055,
        classesGSE62944,
        decoder,
        embedMatGSE25055,
        encoderGSE62944,
        encoderGSE25055,
        formula,
        genes,
        # GSE25055,
        # GSE62944,
        matGSE25055,
        matGSE62944,
        mdMetrics,
        plotPCA,
        readFiles,
        rocCurve,
        tibblerize
    )
})




