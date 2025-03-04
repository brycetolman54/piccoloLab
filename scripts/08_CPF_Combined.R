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
#             Preparing the Data                        #
#########################################################

dataSets = c("GSE25055",
             "GSE31448",
             "GSE58644",
             "GSE62944",
             "GSE81538",
             "METABRIC",
             "GSE96058N")
testSets = c("GSE25065",
             "GSE21653")

genes = readLines("variables/genes.txt")

readFiles(dataSets, columns = c("Class", genes))
readFiles(testSets, columns = c("Class", genes))

dataSetVariables = mget(dataSets)
testSetVariables = mget(testSets)

#########################################################
#             Preparing the Recipe                      #
#########################################################

set.seed(42)
split = initial_split(GSE25055, prop = 150/nrow(GSE25055), strata = Class)
train = training(split)
GSE25055 = suppressMessages(anti_join(GSE25055, train))
i = 1
for(dataSet in dataSetVariables) {
   split = initial_split(dataSet, prop = 150/nrow(dataSet), strata = Class)
   train = bind_rows(train, training(split))
   suppressMessages(eval(expr(!!sym(dataSets[i]) <<- anti_join(dataSet, train))))
   i = i + 1
}

testSets = c(dataSets, testSets)

formula = Class ~ .

subFolder = "08_CPF_Combined/"
if(!dir.exists(paste0("baked/", subFolder))) dir.create(paste0("baked/", subFolder))
if(!dir.exists(paste0("plots/", subFolder))) dir.create(paste0("plots/", subFolder))

recipe = recipe(formula, data = train) |>
    step_normalize(all_numeric_predictors()) |>
    step_mutate(Class = as.factor(Class)) |>
    prep(training = train)

train = bake(recipe, new_data = NULL)
write_tsv(train, paste0("baked/", subFolder, "train.tsv"))

bakeFiles(testSets, recipe, subFolder)

saveRDS(recipe, "recipes/08_CPF_Combined.rds")

#########################################################
#             Preparing the Model                       #
#########################################################

set.seed(42)
model = rand_forest(trees = 35,
                    mode = "classification",
                    engine = "ranger")

fitModel = model |>
            fit(formula, data = train)

saveRDS(fitModel, "models/08_CPF_Combined.rds")

#########################################################
#             Obtaining Results                         #
#########################################################

testSetVariables = mget(testSets)

i = 1
for(dataSet in testSetVariables) {
    setName = testSets[i]
    mdMetrics(fitModel,
              dataSet,
              setName = setName,
              num = i)
    i = i + 1
}

i = 1
for(dataSet in testSetVariables) {
    setName = testSets[i]
    rocCurve(fitModel,
             dataSet,
             filename = setName,
             folder = paste0("plots/", subFolder),
             mdText = "CPF Combined",
             title = paste0("Combined prediciting on ", setName),
             num = i,
             plot = FALSE)
    i = i + 1
}

rm(i,
   genes,
   dataSet,
   dataSets,
   testSets,
   dataSetVariables,
   testSetVariables,
   setName,
   subFolder,
   readFiles,
   bakeFiles,
   mdMetrics,
   rocCurve,
   model,
   formula,
   split)



