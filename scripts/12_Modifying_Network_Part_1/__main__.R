setwd("C:/Users/bat20/OneDrive - Brigham Young University/BYU/2024/Fall/Lab/BreastCancer")

subfolder = "12_Modifying_Network_Part_1/"

run  = function(file) {
    source(paste0("scripts/", subfolder, file, ".R"))
}

normalize = TRUE
optimizing = FALSE
stall = FALSE

standardNames = c("METABRIC", "GSE62944")
novelNames = c("GSE25055", "GSE25065")
# novelNames = c("GSE25055", "GSE25065", "GSE123845")

run("setup")
run("_autoencoder_")
for(novelName in novelNames) run("_adversary_")
run("distinguish")
run("clean")

