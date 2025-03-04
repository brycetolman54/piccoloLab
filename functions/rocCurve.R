rocCurve = function(model, data, filename = "", extension = ".jpg", folder = "plots/", parent = TRUE, title = "ROC Curve", subtitle = "", mdText = "", output = FALSE, plot = FALSE, mdOutput = TRUE, num = 0) {
    
    # Function to plot the ROC curve for a test data set
    # 
    # Inputs:
    #   - model (required): a fit model from which predictions can be made
    #   - data (required): a tibble holding the data to be predicted on
    #   - filename (optional): the name under which to save the ROC curve [if not present, the image will not be saved]
    #   - extension (optional): the filetype to save under [default is .jpg]
    #   - title (optional): the title for the ROC curve [default is ROC Curve]
    #   - subtitle (optional): the subtitle for the ROC curve
    #   - output (optional): returns the data if desired [default is FALSE]
    #   - plotOutput (optional): prints out text for a markdown file to show the plot
    #   - num (optional): sets the num for reference in the plot output for markdown
    #   
    # Outputs:
    #   - Saves the ROC Curve to a file if a filename is specified
    #   - Plots the data in RStudio
    #   - Prints out a markdown-style link for the plot to use in an update (if specified)
    #   - Returns a list containing the area under the ROC Curve ($auc) followed by the ROC curve data ($data)
    
    # Ensure we have the two required arguments
    if(missing(model) || missing(data)) {
        stop("Error: you must provide a model and data")
    }
    
    # Make predictions on the data
    predictedProbabilities = model |> predict(data, type = "prob")
    
    # Make a tibble holding both the ground truth and predicted probability
    combinedTibble = tibble(Real = as.factor(data$Class), Prob = predictedProbabilities$.pred_1)
    
    # Extract the data for the roc curve and the area under the curve
    rocData = roc_curve(combinedTibble, truth = Real, Prob, event_level = "second")
    rocArea = roc_auc(combinedTibble, truth = Real, Prob, event_level = "second")
    
    # Create the plot of the data
    rocPlot = rocData |> 
        arrange(desc(row_number())) |> 
        ggplot(aes(x = (1 - specificity), y = sensitivity)) +
            geom_line() +
            geom_abline(linetype = "dashed") +
            theme_bw() +
            labs(x = "False Positive Rate",
                 y = "True Positive Rate",
                 title = title
                )
    
    # If we have a subtitle, add it to the plot
    if(subtitle != "") {
        rocPlot = rocPlot + ggtitle(title, subtitle = subtitle)
    }
    else {
        rocPlot = rocPlot + ggtitle(title, subtitle = paste0("The area under the curve is ", round(rocArea$.estimate, 3)))
    }

    # Save the data if necessary
    if(filename != "") {
        ggsave(paste0(folder, filename, extension), rocPlot, width = 6, height = 6, unit = "in")
    }

    # Plot the data
    if(plot) {
        print(rocPlot)
    }

    # Print out the markdown data if desired
    if(mdOutput) {
        cat("![", ifelse(mdText == "", paste0("The area under the ROC Curve is ", round(rocArea$.estimate, 3)), mdText), "](", ifelse(parent, "../", ""), folder, filename, ".jpg){#plot-", num, " width=100%}\n\n", sep = "")
    }

    if(output) {
        return(list(auc = rocArea, data = rocData))
    }
}