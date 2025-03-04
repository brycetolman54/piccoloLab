setwd("C:/Users/bat20/OneDrive - Brigham Young University/BYU/2024/Fall/Lab/BreastCancer")
#########################################################
#             Loading the Functions                     #
#########################################################

source("functions/readFiles.R")
source("functions/bakeFiles.R")
source("functions/mdMetrics.R")
source("functions/rocCurve.R")
library(tidymodels)
library(tidyverse)

#########################################################
#             Reading in the Data                       #
#########################################################

dataSets = c("GSE25065",
             "GSE21653",
             "GSE58644",
             "GSE62944",
             "GSE81538",
             "METABRIC",
             "GSE96058N")

genes = readLines("variables/genes.txt")

readFiles("GSE25055", columns = c("Class", genes))
readFiles(dataSets, columns = c("Class", genes))

dataSets = c("test", dataSets)

#########################################################
#             Preparing the Recipe                      #
#########################################################

set.seed(42)
split = initial_split(GSE25055, prop = 0.75)
train = training(split)
test = testing(split)

formula = Class ~ .

subFolder = "05_CPF_Normalize_Each/"
if(!dir.exists(paste0("baked/", subFolder))) dir.create(paste0("baked/", subFolder))
if(!dir.exists(paste0("plots/", subFolder))) dir.create(paste0("plots/", subFolder))
if(!dir.exists(paste0("recipes/", subFolder))) dir.create(paste0("recipes/", subFolder))

recipe = recipe(formula, data = train) |>
    step_normalize(all_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = train)

train = bake(recipe, new_data = NULL)
write_tsv(train, paste0("baked/", subFolder, "train.tsv"))
saveRDS(recipe, paste0("recipes/", subFolder, "train.rds"))

dataSetVariables = mget(dataSets)

i = 1
for(dataSet in dataSetVariables) {
   cat("  Recipe for ", dataSets[i], "\t(", i, "/", length(dataSets), ")\n")
   recipe = recipe(formula, data = dataSet) |>
      step_normalize(all_predictors()) |>
      step_mutate(Class = as.factor(Class)) |>
      prep(training = dataSet)
   eval(expr(!!sym(dataSets[i]) <<- bake(recipe, new_data = NULL)))
   eval(expr(write_tsv(!!sym(dataSets[i]), paste0("baked/", subFolder, dataSets[i], ".tsv"))))
   saveRDS(recipe, paste0("recipes/", subFolder, dataSets[i], ".rds"))
   cat("\b    Done\n")
   i = i + 1
}

#########################################################
#             Preparing the Model                       #
#########################################################

set.seed(42)
model = rand_forest(trees = 25,
                    mode = "classification",
                    engine = "ranger")

fitModel = model |>
            fit(formula, data = train)

saveRDS(fitModel, "models/05_CPF_Normalize_Each.rds")

#########################################################
#             Obtaining Results                         #
#########################################################

dataSetVariables = mget(dataSets)

i = 1
for(dataSet in dataSetVariables) {
    setName = dataSets[i]
    mdMetrics(fitModel,
              dataSet,
              setName = setName,
              num = i)
    i = i + 1
}

i = 1
for(dataSet in dataSetVariables) {
    setName = dataSets[i]
    rocCurve(fitModel,
             dataSet,
             filename = setName,
             folder = paste0("plots/", subFolder),
             mdText = "CPF Normal Standardization Each",
             title = paste0("GSE25055 prediciting on ", setName),
             num = i,
             plot = FALSE)
    i = i + 1
}

rm(i,
   genes,
   dataSet,
   dataSets,
   dataSetVariables,
   setName,
   subFolder,
   readFiles,
   bakeFiles,
   mdMetrics,
   rocCurve,
   model,
   formula,
   split)



