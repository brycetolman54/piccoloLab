setwd("C:/Users/bat20/OneDrive - Brigham Young University/BYU/2024/Fall/Lab/BreastCancer")

source("scripts/12_Modifying_Network_Part_1/toggleboard.R")

run("setup")
# run("_autoencoder_")
for(novelName in novelNames) run("_adversary_")
# if(!optimizing) run("distinguish")
run("clean")
