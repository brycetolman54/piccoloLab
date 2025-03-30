run_  = function(file) {
    source(paste0("scripts/", subfolder, "_autoencoder_/", file, ".R"))
}

color(cat("\nRunning AutoEncoder\n\n"), 210)

run_("prepareData")
run_("modelSetup")
run_("train")
run_("visualize")
run_("clean")