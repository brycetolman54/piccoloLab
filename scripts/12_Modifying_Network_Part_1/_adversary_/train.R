cat("Training:\n\n")

# read in the Standard Encoder and Decoder
standardEncoder = load_model(paste0(models, "standardEncoder.keras"))
standardDecoder = load_model(paste0(models, "standardDecoder.keras"))

# set up vectors to hold the losses and metrics through the epochs
standardMetric = numeric(epochs / interval)
trainMetric = numeric(epochs / interval)
valMetric = numeric(epochs / interval)

valMetrics = numeric(interval)

# prepare the data for the models
xAdv = trainBefore
yAdv = rep(1, nrow(train))

valAdv = valBefore
valClass = rep(0, nrow(val))

x1 = standardEncoder |> predict(standardBefore, verbose = 0)
y1 = rep(1, nrow(standard))
y2 = rep(0, nrow(train))
yDis = c(y1, y2)

# train
time = timer({
    catEpoch = 0
    for(epoch in 1:epochs) {
        
        timeMe = timer({
            
            if(optimizing) color(cat("  Epoch", epoch), 242)
            
            x2 = Encoder |> predict(trainBefore, verbose = 0)
            xDis = rbind(x1, x2)
            
            valDis = Encoder |> predict(valBefore, verbose = 0)
            
            history = Discriminator |> fit(
                x = xDis,
                y = yDis,
                batch_size = batchSize,
                epochs = 1,
                validation_data = list(valDis,
                                       valClass),
                verbose = 0
            )
            
            # freeze the Discriminator
            Discriminator$trainable = FALSE
            
            history = Adversary |> fit(
                x = xAdv,
                y = yAdv,
                batch_size = batchSize,
                epochs = 1,
                validation_data = list(valAdv,
                                       valClass),
                verbose = 0
            )
            
            # unfreeze the Discriminator
            Discriminator$trainable = TRUE
            
            # get the metrics
            valMetrics[ifelse(epoch %% interval != 0, epoch %% interval, 10)] = history[[2]]$val_accuracy
            
        })
        
        if(optimizing) cat("\t", timeMe, "\n")
        
        # get the metrics
        if(epoch %% interval == 0) {
            
            index = epoch / interval
            
            # get the data
            standardMetric[index] = evaluate(Discriminator, x1, y1, verbose = 0)[[1]]
            trainMetric[index] = evaluate(Adversary, xAdv, rep(0, nrow(train)), verbose = 0)[[1]]
            valMetric[index] = mean(valMetrics)
            
            # plot the data
            lastPlot = plotHistory(standardMetric, trainMetric, valMetric, epochs, interval, metric, optimizing)
            
            # print out the metrics
            if(optimizing) color(cat("    Standard: ", sprintf("%.3f", round(standardMetric[index], 3)), "    Train: ", sprintf("%.3f", round(trainMetric[index], 3)), "    Val: ", sprintf("%.3f", round(valMetric[index], 3)), "\n", sep = ""),12)

            # implement the stopping criteria
            if(epoch > 100) {
                lowPoint = mean(valMetrics)
                if(lowPoint <= stopMin) {
                    stopCount = 0 # restart the count
                    stopMin = lowPoint # get the lowest metric so far
                    saveModels() # save the Encoder
                    catEpoch = epoch # save the epoch of the lowest point
                    if(optimizing) color(cat("\b\tSaved\n"), 217)
                } else {
                    stopCount = stopCount + 1
                    if(optimizing) color(cat("\b\t(", stopCount, "/", stopWait, ")\n", sep=""), 217)
                    if(stopCount == stopWait) {
                        break
                    }
                }
            }
        }
            
        if(epoch %% 50 == 0) {
            # get the validation stats
            progressData = Encoder |> predict(valBefore, verbose = 0)
            
            if(optimizing) color(printMetrics(progressData, "val", "embedded"), 5)
            
            # check if we want to stop for another reason
            if(optimizing && stall) {
                color(cat("Continue?"), 46)
                continue = readline()
                if(continue == "n") {
                    break
                } else if(continue == "s") {
                    tryCatch({
                        stop("Stopped")
                    }, error = function(e){})
                }
            }
        }
    } # end for
}, min = TRUE)

cat("\nTrained in ", time, "\n", sep = "")

ggsave(paste0(plots, "_trainModel_", novelName, "_.jpg"), plot = lastPlot, width = 6, height = 4)

# output for validation
if(optimizing) cat("\n|", layers, "|", dLayers, "|", units, "|", actFun, "|", dActFun, "|", optim, "|", dropout, "|", batchSize, "|", catEpoch, "|", round(sd(progressData) / max(progressData), 3), "|", round(max(progressData), 3), "|", round(stopMin, 3) * 100, "|")
