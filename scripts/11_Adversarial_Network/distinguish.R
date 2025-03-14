# load libraries ###############################################################
library(tidymodels)
source("functions/readFiles.R")
source("functions/bakeFiles.R")
source("functions/rocCurve.R")
source("functions/mdMetrics.R")
source("functions/plotPCA.R")

# make functions ###############################################################
tibblerize = function(data, classes) {
    data = as_tibble(data, .name_repair = ~paste0("col_", seq_len(ncol(data))))
    data = bind_cols(data, classes)
    return(data)
}
predictData = function(trainer, start, stop, time) {
    
    set.seed(42)
    
    formula = Class ~ .
    folder = "plots/11_Adversarial_Network/distinguish/"
    
    recipe = recipe(formula, data = get(trainer)) |> step_normalize(all_predictors()) |>
        step_mutate(Class = as.factor(Class)) |> prep(training = get(trainer))
    bakeFiles(tibbleData[(start - 1):stop], recipe)
    cat("\n")
    
    model = rand_forest(trees = 25, mode = "classification", engine = "ranger")
    fitModel = model |> fit(formula, data = get(trainer))
    
    for(j in start:stop) {
        newData = tibbleData[j]
        dataName = data[((j - 1) %% size) + 1]
        title = paste0(time, " Conformation (", dataName, ")")
        
        plotPCA(c(trainer, newData), folder = folder, filename = paste0(newData, "PCA"), title = title)
        rocCurve(fitModel, get(newData), filename = paste0(newData, "ROC"), folder = folder,
                 title = title, subtitle = paste0(trainer, " predicting on ", dataName))
        suppressWarnings({mdMetrics(fitModel, get(newData), setName = title)})
    }
}

# define lists #################################################################
data = c("GSE25055", "GSE62944")
size = length(data)
times = c("Before", "During", "After")
classes = paste0("classes", data)
encoders = paste0("encoder", data)
tibbleData = as.vector(outer(data, times, paste0))
matData = paste0("mat", tibbleData)

# load the Encoders and Decoder ################################################
decoder = load_model("models/10_Standard_Auto_Encoder/decoder.keras")
for(datum in data) assign(paste0("encoder", datum), load_model(paste0("models/11_Adversarial_Network/encoder_", datum, ".keras")))

# load the data ################################################################
genes = readLines("variables/lessGenes.txt")[1:100]
for(datum in data) if(!exists(datum)) readFiles(datum, columns = c("Class", genes))
cat("\n")

# get the data sets ############################################################
for(i in 1:size) assign(classes[i], get(data[i]) |> select(Class))
for(i in 1:size) assign(matData[i], as.matrix(get(data[i]) |> select(-Class)))
for(i in 1:size) assign(matData[i + size], get(encoders[i]) |> predict(get(matData[i]), verbose = 0))
for(i in 1:size) assign(matData[i + 2 * size], decoder |> predict(get(matData[i + size]), verbose = 0))
for(i in 1:(3 * size)) assign(tibbleData[i], tibblerize(get(matData[i]), get(classes[((i - 1) %% size) + 1])))

# make predictions #############################################################
for(i in 1:3) {predictData(trainer = tibbleData[((i - 1) * size) + 1],
                           start = ((i - 1) * size) + 2,
                           stop = i * size,
                           time = times[i])}

# clean up #####################################################################
rmList = c(ls(), "rmList")
rmList = rmList[!rmList %in% data]
rm(list = rmList)

invisible(gc())

