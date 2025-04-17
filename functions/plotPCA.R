plotPCA = function(dataNames,
                   title = "PCA Plot",
                   normalized = TRUE,
                   plot = FALSE,
                   output = FALSE,
                   mdOutput = TRUE,
                   folder = "plots/",
                   filename = "",
                   extension = ".jpg") {
    
    # Function to plot data sets in the same 2D plot in order to see how they are related
    # 
    # Inputs:
    #   - dataNames (required): a vector of strings representing the data sets to be shown (not the actual data set objects themselves)
    #   - title (optional): a title for the PCA plot
    #   - normalized (optional): whether or not to normalize the data when obtaining the PCA [default is TRUE]
    #   - plot (optional): whether or not to print the plot in the RStudio window [default is FALSE]
    #   - output (optional): whether or not to return the PCA data for further use [default is FALSE]
    #   - mdOutput (optional): whether or not to print out a Markdown reference for the plot [default is TRUE]
    #                          in order for this to happen, the filename argument must not be blank
    #   - folder (optional): the folder in which to save the generated plot [default is "plots/"]
    #   - filename (optional): the filename under which to save the generated plot [default is "" meaning not to save the plot]
    #   - extension (optional):  the image-type extension with which to save the generated plot [default is ".jpg"]
    #
    # Outputs:
    #   - A plot of the data in the RStudio window (if desired) and in a file (if desired)
    #   - The data obtained from the PCA and used to plot the data
    
  
    if(missing(dataNames)) {
        stop("Error: you must provide data")
    }
    
    # get the names of the data set for the md output
    names = paste(dataNames, collapse = ", ")
    
    # grab the actual data sets from the strings provided
    dataSets = lapply(dataNames, get)
    
    # separate the gene expression data from the Class data
    # start the "allData" and "classData" variables on which to add future data sets
    firstData = dataSets[[1]]
    allData = firstData |> select(-Class) |> dplyr::filter(FALSE)
    classData = tibble(Class = character(0))

    # stop the process if there is only one data set to look at    
    if(length(dataNames) == 1) {
        dataNames = ""
    }
    
    # else, loop the remaining data sets and add each one's expression data to the
    # "allData" tibble and the Class data to the "classData" tibble
    i = 1
    for(dataSet in dataSets) {
        # if we have more than one data set, add the class to each point
        oneClassData = tibble(Class = factor(paste0(dataNames[i],
                            if_else(dataNames[i] == "", "", "_"),
                            if_else(dataSet$Class == 0, "0", "1"))))

        classData = bind_rows(classData, oneClassData)

        dataNoClass = dataSet |> select(-Class)
        allData = bind_rows(allData, dataNoClass)
        i = i + 1
    }

    # perform the PCA, with or without normalization
    pcaData = prcomp(as.matrix(allData),
                     center = normalized,
                     scale. = normalized)
    
    # make the PCA output a tibble and add back the class data collected earlier
    plotData = as_tibble(pcaData$x[,1:2]) |>
                mutate(Class = classData$Class)

    # generate the plot
    pcaPlot = ggplot(plotData,
                     aes(x = PC1, y = PC2,
                         color = Class)) +
              geom_point(alpha=0.5) +
              labs(title = title,
                   color = "Class") +
              theme_bw()

    # save the plot to a file, if desired
    if(filename != "") {
        if(mdOutput) {
            cat("![Two dimensional PCA plot of ",  names, "](../", folder, filename, extension, "){width=100%}\n", sep = "")
        }
        ggsave(paste0(folder, filename, extension), pcaPlot, width = 6, height = 6, unit = "in")
    }
    
    # print out the plot, if desired
    if(plot) {
        print(pcaPlot)
    }
    
    # return the pca data, with classes attached, if desired
    if(output) {
        return(plotData)
    }
}
