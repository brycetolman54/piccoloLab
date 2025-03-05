# do imports
library(tidyverse)
library(keras3)
suppressMessages(library(tensorflow))
library(tidymodels)
library(rsample)
source("functions/readFiles.R")
source("functions/bakeFiles.R")
source("functions/rocCurve.R")
source("functions/mdMetrics.R")
source("functions/plotPCA.R")
source("functions/timer.R")
source("functions/color.R")
source("functions/splitData.R")

# define folders
subfolder = "11_Adversarial_Network/"
plots = paste0("plots/", subfolder)
if(!dir.exists(plots)) dir.create(plots)
models = paste0("models/", subfolder)
if(!dir.exists(models)) dir.create(models)

# define functions
plotHistory = function(standardMetrics,
                       trainMetrics,
                       valMetrics,
                       epochs,
                       interval,
                       metric) {
    
    # clear the plot
    if(length(dev.list()) != 0) {
        invisible(dev.off())
    }
    
    # turn the data into tibbles again
    standardMetrics = tibble(y = standardMetrics) |>
        mutate(x = row_number() * interval) |>
        mutate(group = paste0("standard_", metric))
    trainMetrics = tibble(y = trainMetrics) |>
        mutate(x = row_number() * interval) |>
        mutate(group = paste0("train_", metric))
    valMetrics = tibble(y = valMetrics) |>
        mutate(x = row_number() * interval) |>
        mutate(group = paste0("val_", metric))

    # combine the appropriate data sets
    metricData = bind_rows(standardMetrics, trainMetrics, valMetrics)

    # some colors
    textColor = "grey"
    fillColor = "#141414"

    # plot the data
    metricPlot = metricData |> ggplot(aes(x = x, y = y, color = group)) +
        geom_line() + geom_point() + theme_dark() + 
        scale_color_manual(values = c("orange", "#57d957", "#4fa3ff")) +
        theme(panel.background = element_rect(fill = fillColor),
              plot.background = element_rect(fill = fillColor),
              legend.background = element_rect(fill = fillColor),
              axis.title = element_text(color = textColor)) +
        theme(axis.text = element_text(color = textColor),
              legend.text = element_text(color = textColor),
              legend.title = element_blank(),
              axis.line = element_line(color = textColor),
              axis.ticks = element_line(color = textColor),
              panel.border = element_blank(),
              panel.grid = element_blank()) +
        theme(legend.position = "bottom",
              legend.margin = margin(0,0,0,0)) +
        scale_x_continuous(breaks = scales::breaks_pretty(n=min(10, epochs / 10)),
                           limits = c(0, epochs)) +
        scale_y_continuous(limits = c(0, 1)) +
        labs(x = "Epoch", y = metric)

    # plot the data
    suppressMessages({
        print(metricPlot)
    })
    
}
printMetrics = function(data, title, type) {
    cat("\n  Data Metrics: ", title, " [", type ,"]", sep = "")
    cat("\n    The max is:\t\t", max(data))
    cat("\n    The min is:\t\t", min(data))
    cat("\n    The mean is:\t", mean(data))
    cat("\n    The median is:\t", median(data))
    cat("\n    The stdev is:\t", sd(data))
    cat("\n\n")
}
saveModels = function() {
    save_model(Encoder, paste0(models, "encoder.keras"), overwrite = TRUE)
    save_model(Discriminator, paste0(models, "discriminator.keras"), overwrite = TRUE)
    save_model(Adversary, paste0(models, "adversary.keras"), overwrite = TRUE)
}
catMetrics = function(data, title, type) {
    cat("| ", title, " [", type, "]",
        " | ", round(max(data), 3),
        " | ", round(min(data), 3),
        " | ", round(mean(data), 3),
        " | ", round(median(data), 3),
        " | ", round(sd(data), 3),
        " |\n", 
        sep="")
}
tibblerize = function(data, classes) {
    data = as_tibble(data, .name_repair = ~paste0("col_", seq_len(ncol(data))))
    data = bind_cols(data, classes)
    return(data)
}


