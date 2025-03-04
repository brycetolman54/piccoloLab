setwd("C:/Users/bat20/OneDrive - Brigham Young University/BYU/2024/Fall/Lab/BreastCancer")

run  = function(file) {
    source(paste0("scripts/11_Adversarial_Network/", file, ".R"))
}

run("setup")
run("defineFunctions")
run("prepareData")
run("initalClassification")
run("modelSetup")
run("train")
run("verify")
run("clean")
