setwd("C:/Users/bat20/OneDrive - Brigham Young University/BYU/2024/Fall/Lab/BreastCancer")
#########################################################
#             Loading the Functions                     #
#########################################################

library(tidyverse)
library(keras3)
library(rsample)
source("functions/readFiles.R")
source("functions/plotPCA.R")

#########################################################
#             Preparing the data                        #
#########################################################

# get the common genes (the reduced subset)
genes = readLines("variables/lessGenes.txt")[1:100]

# read in the Standard data (don't include the class)
readFiles("METABRIC", columns = c("Class", genes))
data = METABRIC


# separate out the Class
classes = data |> select(Class) |> mutate(Class = as.factor(Class))
data = data |> select(-Class)

# set the seed
set.seed(0)

# split into test and train data (not in the final Deliverable)
dataSplit = data |>
    initial_split(prop = 0.7)
train = training(dataSplit)
test = testing(dataSplit)

# split train into train and val
trainSplit = train |>
    initial_split(prop = 0.7)
train = training(trainSplit)
val = testing(trainSplit)


#########################################################
#             Creating the network                      #
#########################################################

# set the seed
tensorflow::set_random_seed(0)

# initialize some variables
inputSize = length(genes)
embeddingSize = 10
layers = 2
dropout = FALSE
layerDrop = ceiling((inputSize - embeddingSize) / layers)
actFun = "elu"
optimizer = "adam"
loss = "mse"
metric = "mae"

# define the Encoder
Encoder = keras_model_sequential(input_shape = c(inputSize),
                                 name = paste0("Encoder_",
                                               embeddingSize,
                                               "D"))
for(layer in 1:(layers - 1)) {
    Encoder |> 
        layer_dense(units = inputSize - layerDrop * layer,
                           activation = actFun,
                           name = paste0("Deflate_", layer))
    if(dropout) {
        Encoder|>
            layer_dropout(rate = 0.4,
                          name = paste0("Dropout_", layer))
    }
}
Encoder |>
    layer_dense(units = embeddingSize,
                name = "Embedding")

# define the Decoder
Decoder = keras_model_sequential(input_shape = c(embeddingSize),
                                 name = paste0("Decoder_",
                                               embeddingSize,
                                               "D"))
for(layer in 1:(layers - 1)) {
    Decoder |> 
        layer_dense(units = embeddingSize + layerDrop * layer,
                    activation = actFun,
                    name = paste0("Inflate_", layer))
    if(dropout) {
        Decoder |>
            layer_dropout(rate = 0.4,
                          name = paste0("Dropout_", layer))
    }
}
Decoder |>
    layer_dense(units = inputSize,
                name = "Output")

# build the AutoEncoder
input = layer_input(shape = c(inputSize),
                    name = "Input")
encodedLayer = Encoder(input)
decodedLayer = Decoder(encodedLayer)
AutoEncoder = keras_model(inputs = input,
                          outputs = decodedLayer,
                          name = paste0("AutoEncoder_",
                                        embeddingSize,
                                        "D"))

# compile the AutoEncoder
AutoEncoder |> compile(
    optimizer = optimizer,
    loss = loss,
    metrics = metric
)

#########################################################
#             Training the network                      #
#########################################################

# declare some variables
epochs = 75
batchSize = 6

# make a callback function
stopEarly = callback_early_stopping(
    monitor = "val_loss",
    patience = 10,
    restore_best_weights = TRUE,
    mode = "min"
)

cat("\n  Training ", embeddingSize, "D network:", sep = "")
start = Sys.time()

# train the AutoEncoder
history = AutoEncoder |> fit(
    x = as.matrix(train),
    y = as.matrix(train),
    batch_size = batchSize,
    epochs = epochs,
    validation_data = list(as.matrix(val),
                           as.matrix(val)),
    callbacks = stopEarly,
    verbose = 0
)

end = Sys.time()
cat(" Done in", substring(seconds(end - start), 1, 6), "s\n")

#########################################################
#      Testing the network (on Validation)              #
#########################################################

# get some info about the data
mat = as.matrix(data)
cat("\n  Data Metrics:")
cat("\n    The max is:\t\t", max(mat))
cat("\n    The min is:\t\t", min(mat))
cat("\n    The mean is:\t", mean(mat))
cat("\n    The median is:\t", median(mat))
cat("\n")

# evaluate the test set
cat("\n  Evaluating Validation set:")
valEval = AutoEncoder |> evaluate(as.matrix(val),
                                     as.matrix(val),
                                  verbose = 0)

# # print out the metrics
cat("\n    Validation Set MSE:", valEval[[1]])
cat("\n    Validation set MAE:", valEval[[2]])
cat("\n")

# Print out the optimization info
# cat("\n|",
#     layers, "|",
#     actFun, "|",
#     optimizer, "|",
#     embeddingSize, "|",
#     dropout, "|",
#     batchSize, "|",
#     which.min(history$metrics$val_loss), "|",
#     round(valEval[[2]], 3), "|")

#########################################################
#      Testing the network (after optimization)         #
#########################################################

# evaluate the test set
cat("\n  Evaluating Test set:")
testEval = AutoEncoder |> evaluate(as.matrix(test),
                                     as.matrix(test),
                                   verbose = 0)

# # print out the metrics
cat("\n    Test Set MSE:", testEval[[1]])
cat("\n    Test set MAE:", testEval[[2]])
cat("\n")

#########################################################
#             Creating the 2D network                   #
#########################################################

# define variables
embeddingSize = 2

# define the Encoder
Encoder_2D = keras_model_sequential(input_shape = c(inputSize),
                                 name = paste0("Encoder_",
                                               embeddingSize,
                                               "D"))
for(layer in 1:(layers - 1)) {
    Encoder_2D |> 
        layer_dense(units = inputSize - layerDrop * layer,
                    activation = actFun,
                    name = paste0("Deflate_", layer))
    if(dropout) {
        Encoder_2D|>
            layer_dropout(rate = 0.4,
                          name = paste0("Dropout_", layer))
    }
}
Encoder_2D |>
    layer_dense(units = embeddingSize,
                name = "Embedding")

# define the Decoder
Decoder_2D = keras_model_sequential(input_shape = c(embeddingSize),
                                 name = paste0("Decoder_",
                                               embeddingSize,
                                               "D"))
for(layer in 1:(layers - 1)) {
    Decoder_2D |> 
        layer_dense(units = embeddingSize + layerDrop * layer,
                    activation = actFun,
                    name = paste0("Inflate_", layer))
    if(dropout) {
        Decoder_2D |>
            layer_dropout(rate = 0.4,
                          name = paste0("Dropout_", layer))
    }
}
Decoder_2D |>
    layer_dense(units = inputSize,
                name = "Output")

# build the AutoEncoder
input = layer_input(shape = c(inputSize),
                    name = "Input")
encodedLayer = Encoder_2D(input)
decodedLayer = Decoder_2D(encodedLayer)
AutoEncoder_2D = keras_model(inputs = input,
                          outputs = decodedLayer,
                          name = paste0("AutoEncoder_",
                                        embeddingSize,
                                        "D"))

# compile the AutoEncoder
AutoEncoder_2D |> compile(
    optimizer = optimizer,
    loss = loss,
    metrics = metric
)

cat("\n  Training ", embeddingSize, "D network:", sep = "")
start = Sys.time()

# train the network
history_2D = AutoEncoder_2D |> fit(
    x = as.matrix(train),
    y = as.matrix(train),
    batch_size = batchSize,
    epochs = epochs,
    validation_data = list(as.matrix(val),
                           as.matrix(val)),
    callbacks = stopEarly,
    verbose = 0
)

end = Sys.time()
cat(" Done in", substring(seconds(end - start), 1, 6), "s\n")

#########################################################
#             Visualizing the Data                      #
#########################################################

# define the folder to use for plots
subFolder = "10_Standard_Auto_Encoder/"
plots = paste0("plots/", subFolder)
if(!dir.exists(plots)) dir.create(plots)

# do the PCA
plotPCA("METABRIC",
        title = "2D PCA Plot of METABRIC",
        folder = plots,
        filename = "pcaStandardPlot")

cat("  Plotting 2D Data:\n")
# get the 2D version of the data
data2D = Encoder_2D |>
            predict(as.matrix(data),
                    verbose = 0)

# prepare it for plotting
suppressMessages({data2D = as_tibble(data2D, .name_repair = "unique")})
names(data2D) = c("x", "y")
data2D = bind_cols(data2D, classes)

# plot the data
plot2D = data2D |>
    ggplot(aes(x = x, y = y, color = Class)) +
    geom_point(alpha = 0.5) +
    labs(x = "Node 1", 
         y = "Node 2",
         title = "2D Plot of METABRIC Latent Space",
         color = "Class") +
    theme_bw() +
    xlim(-13, 22) +
    ylim(-8, 10.5)

# save the file
suppressWarnings({ggsave(paste0(plots, "latentSpaceStandard.jpg"), plot2D,
       width = 6, height = 6, unit = "in")})
cat("    ![Two dimensional Latent Space of METABRIC](", 
    paste0("../", plots, "latentSpaceStandard.jpg"),
    "){width=100%}\n", sep = "")
cat("\n")

#########################################################
#             Saving the Data                           #
#########################################################

cat("  Saving the Data:\n")
# define the folder to use for the models
models = paste0("models/", subFolder)
if(!dir.exists(models)) dir.create(models)

# save the models
save_model(Encoder, paste0(models, "encoder.keras"), overwrite = TRUE)
save_model(Decoder, paste0(models, "decoder.keras"), overwrite = TRUE)
save_model(AutoEncoder, paste0(models, "autoEncoder.keras"), overwrite = TRUE)
save_model(Encoder_2D, paste0(models, "encoder2D.keras"), overwrite = TRUE)
save_model(Decoder_2D, paste0(models, "decoder2D.keras"), overwrite = TRUE)
save_model(AutoEncoder_2D, paste0(models, "autoEncoder2D.keras"), overwrite = TRUE)

# define the folder to use for the model data
dist = paste0("variables/Model_Data/")
if(!dir.exists(dist)) dir.create(dist)

# get the standard distribution and save it
distribution = Encoder |> predict(as.matrix(data),
                                  verbose = 0)
suppressMessages({distribution = as_tibble(distribution, .name_repair = "unique")})
names(distribution) = c(paste0("d", 1:10))
distribution = bind_cols(distribution, classes)

write_tsv(distribution, paste0(dist, "Standard_Distribution.tsv"))

cat("\b Done\n")

#########################################################
#             Cleaning up                               #
#########################################################

# remove everything
suppressWarnings({
rm(start,
   genes,
   METABRIC,
   readFiles,
   plotPCA,
   inputSize,
   embeddingSize,
   actFun,
   layerDrop,
   dataSplit,
   trainSplit,
   train,
   val,
   test,
   data,
   epochs,
   batchSize,
   loss,
   metric,
   optimizer,
   input,
   encodedLayer,
   decodedLayer,
   stopEarly,
   mat,
   layer,
   layers,
   dropout,
   testEval,
   valEval,
   plots,
   subFolder,
   classes,
   history,
   history_2D,
   data2D,
   AutoEncoder,
   AutoEncoder_2D,
   Encoder,
   Encoder_2D,
   Decoder,
   Decoder_2D,
   models,
   plot2D,
   distribution,
   dist,
   end)
})

# Free up space
invisible({gc()})