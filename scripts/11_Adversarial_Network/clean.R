rmList = c(ls(), "rmList")
rmList = rmList[!rmList %in% standardNames]
rm(list = rmList)

invisible(gc())

