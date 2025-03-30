run_  = function(file) {
    source(paste0("scripts/", subfolder, "_adversary_/", file, ".R"))
}

color(cat("\n\nRunning Adversary for ",  novelName, "\n\n", sep = ""), 210)

run_("prepareData")
if(!optimizing) run_("initialClassification")
run_("modelSetup")
run_("train")
if(!optimizing) run_("verify")
run_("clean")