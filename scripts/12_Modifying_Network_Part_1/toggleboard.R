tensorflow::tf$get_logger()$setLevel("ERROR")

# set up the subfolder #########################################################
subfolder = "12_Modifying_Network_Part_1/"
run  = function(file) source(paste0("scripts/", subfolder, file, ".R"))

################################################################################

# switches for outputs #########################################################
normalize = TRUE
optimizing = TRUE
stall = TRUE

################################################################################

# names of data sets and genes #################################################
genes = readLines("variables/lessGenes.txt")[1:100]
inputSize = length(genes)

standardNames = c("METABRIC", "GSE62944")
novelNames = c("GSE25055")
# novelNames = c("GSE25055", "GSE25065", "GSE123845")

################################################################################

# params for both networks #####################################################
tfSeed = 0
embeddingSize = 5

################################################################################

# params for autoencoder model #################################################
aeLayers = 2
aeDropout = FALSE
aeLayerDrop = ceiling((inputSize - embeddingSize) / aeLayers)
aeActFun = "elu"
aeOptim = "adam"
aeLr = 0.002
aeLoss = "mse"
aeMetric = c("mae")

################################################################################

# params for autoencoder training ##############################################
aeEpochs = 100
aeBatchSize = 32

################################################################################

# params for adversary network model ###########################################
# set some params for the encoder portion
adLayers = 8
adLayerDrop = ceiling((inputSize - embeddingSize) / adLayers)
adActFun = "elu"

# set some vars for the decoder/adversary
adOptim = "adam"
lr = 0.0001
adLoss = "binary_crossentropy"
adMetric = c("accuracy")
adDropout = FALSE

# set some params for the decoder
adLayersD = 8
units = 64
adActFunD = "elu"
adDropout = FALSE
rate = 0.4

################################################################################

# params for adversary network training ########################################
adEpochs = 1000
waitEpoch = 100
interval = 10
adBatchSize = 64
stopCount = 0
stopWait = 20

################################################################################