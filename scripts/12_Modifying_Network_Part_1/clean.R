rmList = c(ls(), "rmList")
rmList = rmList[!rmList %in% c(standardNames, novelNames, "Standard")]
suppressWarnings({rm(list = rmList)})

invisible(gc())
