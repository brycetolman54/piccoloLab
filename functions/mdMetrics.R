mdMetrics = function(model, data, mdOutput = TRUE, output = FALSE, setName = "", num = 0) {
    
    # Function to create and print out the metrics and confusion matrix for a test set prediction
    # 
    # Inputs:
    #   - model (required): a fit model that can be used to make predictions
    #   - data (required): a tibble holding the data to be predicted on (including the ground truth as a Class column)
    #   - mdOutput (optional): prints out the confusion matrix and metrics in md format [default is TRUE]
    #   - output (optional): returns data to a variable [default is FALSE]
    #   - setName (optional): adds a name to the beginning of the print out results [default is nothing]
    #   - num (optional): adds a link to the titles of the md output [default is 0]
    #
    # Outputs:
    #   - Prints out the markdown table and metrics for reports (if specified)
    #   - Returns a list containing the confusion matrix ($cfMatrix) and a tibble of the metrics ($metrics)
    
    # Ensure we have the required arguments
    if(missing(model) || missing(data)) {
        stop("Error: you must provide the model and data")
    }
    
    # get the predictions
    predictions = model |> predict(data)
    
    # Create the confusion matrix
    confusionMatrix = table(P = predictions$.pred_class, A = data$Class)[2:1, 2:1]
    
    # Obtain the metrics and combine them into a tibble
    acc = accuracy(confusionMatrix)
    prec = precision(confusionMatrix)
    rec = recall(confusionMatrix)
    spec = specificity(confusionMatrix)
    metrics = bind_rows(acc, prec, rec, spec)
    
    # Print out the makrdown data if desired
    if(mdOutput) {
        cat("####", setName, "Confusion Matrix", ifelse(num == 0, "", paste0("{#matrix-", num, "}")),"\n\n")
        
        cat("|   Predicted/Actual    |   +   |   -   |\n",
            "| :-------------------: | :---: | :---: |\n",
            "|           +           |  ",
            confusionMatrix[1,1],
            "  |  ",
            confusionMatrix[1,2],
            "  |\n",
            "|           -           |  ",
            confusionMatrix[2,1],
            "  |  ",
            confusionMatrix[2,2],
            "  |\n\n", sep = "")
        
        cat("####", setName, "Metrics", ifelse(num == 0, "", paste0("{#metrics-", num, "}")),"\n\n")
        cat("- Accuracy:    ", round(acc$.estimate, 3), "\n")
        cat("- Precision:   ", round(prec$.estimate, 3), "\n")
        cat("- Recall:      ", round(rec$.estimate, 3), "\n")
        cat("- Specificity: ", round(spec$.estimate, 3), "\n")
        cat("\n")
    }
    
    if(output) {
        return(list(confMatrix = confusionMatrix, metrics = metrics))
    }
}