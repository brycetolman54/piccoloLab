if(optimizing) {
    eval = AutoEncoder |> evaluate(get(standardMat[2]), get(standardMat[2]), verbose = 0)
    cat("\n|", aeLayers, "|", aeActFun, "|", aeOptim, "|", aeLr, "|", embeddingSize, "|", aeDropout, "|", aeBatchSize, "|", which.min(history$metrics$val_loss), "|", round(eval[[2]], 3), "|\n\n")
} else {
    # transform the data
    assign(standardTimes[1], as.matrix(StandardMat))
    assign(standardTimes[2], Encoder |> predict(get(standardTimes[1]), verbose = 0))
    assign(standardTimes[3], Decoder |> predict(get(standardTimes[2]), verbose = 0))
    
    # print out the metrics
    cat("\n## Data Metrics\n\n")
    cat("| Data set | Max | Min | Mean | Median | SD |\n")
    cat("|:---:|:---:|:---:|:---:|:---:|:---:|\n")
    end = ifelse(optimizing, 2, 3)
    for(i in 1:end) catMetrics(get(standardTimes[i]), "Standard", times[i])
    
    # evaluate the val set
    cat("\n  Evaluating Validation set:")
    eval = AutoEncoder |> evaluate(get(standardMat[2]),
                                    get(standardMat[2]),
                                    verbose = 0)
    cat("\n    - Validation Set MSE:", eval[[1]])
    cat("\n    - Validation set MAE:", eval[[2]])
    cat("\n")
    
    # evaluate the test set
    cat("\n  Evaluating Test set:")
    eval = AutoEncoder |> evaluate(get(standardMat[3]),
                                    get(standardMat[3]),
                                    verbose = 0)
    cat("\n    - Test Set MSE:", eval[[1]])
    cat("\n    - Test set MAE:", eval[[2]])
    cat("\n\n")
    
    # plot PCA before, during, and after
    for (i in 1:3) assign(standardTimes[i], tibblerize(get(standardTimes[i]), standardClass))
    cat("| | Before | During | After |\n")
    cat("|:---:|:---:|:---:|:---:|\n|")
    for(i in 1:end) {
        cat(" ")
        plotPCA(standardTimes[i],
                title = paste0("Standard ", times[i], " Embedding"),
                folder = plots,
                filename = paste0(times[i], extraName, "PCA"))
        cat("\b |")
    }
    cat("\n")
    plotPCA(c(standardTimes[1], standardTimes[3]),
            title = "Standard Before and After Embedding",
            folder = plots,
            filename = paste0("beforeAndAfter", extraName, "PCA"))
}
