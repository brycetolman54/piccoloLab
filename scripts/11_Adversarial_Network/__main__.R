setwd("C:/Users/bat20/OneDrive - Brigham Young University/BYU/2024/Fall/Lab/BreastCancer")

run  = function(file) {
    source(paste0("scripts/11_Adversarial_Network/", file, ".R"))
}

valCheck = FALSE
stall = FALSE
novelName = "GSE62944"

run("setup")
run("prepareData")
run("initialClassification")
run("modelSetup")
run("train")
run("verify")
run("clean")
