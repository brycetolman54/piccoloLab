run_  = function(file) {
    source(paste0("scripts/", subfolder, "_adversary_/", file, ".R"))
}

cat("\nRunning Adversary for ",  novelName, "\n\n", sep = "")

run_("prepareData")
run_("initialClassification")
run_("modelSetup")
run_("train")
if(!optimizing) run_("verify")
run_("clean")