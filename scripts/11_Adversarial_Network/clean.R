rmList = c(ls(), "rmList")
rmList = rmList[!rmList %in% c("METABRIC")]
rm(list = rmList)

invisible(gc())

