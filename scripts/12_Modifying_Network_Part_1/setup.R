# do imports
suppressMessages({
  library(tidyverse)
  library(keras)
  suppressMessages(library(tensorflow))
  library(tidymodels)
  library(rsample)
})
source("functions/readFiles.R")
source("functions/bakeFiles.R")
source("functions/rocCurve.R")
source("functions/mdMetrics.R")
source("functions/plotPCA.R")
source("functions/timer.R")
source("functions/color.R")
source("functions/splitData.R")

# define folders
models = paste0("models/", subfolder)
if(!dir.exists(models)) dir.create(models)
standards = "variables/standards/"
if(!dir.exists(standards)) dir.create(standards)
vars = paste0(standards, subfolder)
if(!dir.exists(vars)) dir.create(vars)

extraName = ifelse(normalize, "normal", "")

# define some lists
data = c("train", "val", "test")
times = c("Before", "During", "After")
matData = as.vector(outer(data, times, paste0))
classes = paste0(data, "Classes")

# define the formula
formula = Class ~ .

# define functions
plotHistory = function(standardMetrics, trainMetrics, valMetrics, epochs, interval, metric) {
    
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
        scale_color_manual(values = c("orange", "#4fa3ff", "#57d957")) +
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

    lastPlot = metricPlot
    
    if(optimizing) print(metricPlot)
}
catMetrics = function(data, title, type = "") {
    typeStr = ifelse(type == "", "", paste0(" [", type, "]"))
    cat("| ", title, typeStr,
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
vectorize = function(data) {
  return(as.numeric(data[[1]]) - 1)
}
predictData = function(trainer, start, stop, time) {
    
    set.seed(42)
    
    recipe = recipe(formula, data = get(trainer)) |> step_normalize(all_predictors()) |>
        step_mutate(Class = as.factor(Class)) |> prep(training = get(trainer))
    bakeFiles(tibbleData[(start - 1):stop], recipe)
    cat("\n")
    
    model = rand_forest(trees = 25, mode = "classification", engine = "ranger")
    fitModel = model |> fit(formula, data = get(trainer))
    
    for(j in start:stop) {
        newData = tibbleData[j]
        dataName = dataNames[((j - 1) %% size) + 1]
        title = paste0(time, " Conformation (", dataName, ")")
        
        cat(" ")
        plotPCA(c(trainer, newData), folder = plots, filename = paste0(newData, extraName, "PCA"), title = title)
        cat("\b |")
        cat("\n ")
        rocCurve(fitModel, get(newData), filename = paste0(newData, extraName, "ROC"), folder = plots,
                 title = title, subtitle = paste0(trainer, " predicting on ", dataName))
        cat("\b\b |\n\n")
        suppressWarnings({mdMetrics(fitModel, get(newData), setName = title)})
    }
}



