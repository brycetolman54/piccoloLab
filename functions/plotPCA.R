plotPCA = function(dataNames, title = "PCA Plot", normalized = TRUE, plot = FALSE, output = FALSE, mdOutput = TRUE, folder = "plots/", filename = "", extension = ".jpg") {
    
    if(missing(dataNames)) {
        stop("Error: you must provide data")
    }
    
    names = paste(dataNames, collapse = ", ")
    
    cat("\n  Performing PCA on:", names, "\n")
    
    dataSets = lapply(dataNames, get)
    
    firstData = dataSets[[1]]
    allData = firstData |> select(-Class) |> dplyr::filter(FALSE)
    classData = tibble(Class = character(0))
# 
    if(length(dataNames) == 1) {
        dataNames = ""
    }
    
    i = 1
    for(dataSet in dataSets) {
        oneClassData = tibble(Class = factor(paste0(dataNames[i],
                            if_else(dataNames[i] == "", "", "_"),
                            if_else(dataSet$Class == 0, "0", "1"))))

        classData = bind_rows(classData, oneClassData)

        dataNoClass = dataSet |> select(-Class)
        allData = bind_rows(allData, dataNoClass)
        i = i + 1
    }

    start = Sys.time()
    pcaData = prcomp(as.matrix(allData),
                     center = normalized,
                     scale. = normalized)
    end = Sys.time()
    
    cat("\b\t", substring(seconds(end - start), 1, 6), "s\n")

    plotData = as_tibble(pcaData$x[,1:2]) |>
                mutate(Class = classData$Class)

    pcaPlot = ggplot(plotData,
                     aes(x = PC1, y = PC2,
                         color = Class)) +
              geom_point(alpha=0.5) +
              labs(title = title,
                   color = "Class") +
              theme_bw()

    if(filename != "") {
        if(mdOutput) {
            cat("    ![Two dimensional PCA plot of ",  names, "](../", folder, filename, extension, "){width=100%}\n", sep = "")
        }
        ggsave(paste0(folder, filename, extension), pcaPlot, width = 6, height = 6, unit = "in")
    }
    
    if(plot) {
        print(pcaPlot)
    }
    
    if(output) {
        return(plotData)
    }
}
