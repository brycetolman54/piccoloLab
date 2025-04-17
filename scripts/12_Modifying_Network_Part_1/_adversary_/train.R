cat("Training:\n\n")

# read in the Standard Encoder and Decoder
standardEncoder = load_model_tf(paste0(models, "standardEncoder_", embeddingSize, "D_" , extraName))
standardDecoder = load_model_tf(paste0(models, "standardDecoder_", embeddingSize, "D_", extraName))

# set up vectors to hold the losses and metrics through the epochs
standardMetric = numeric(adEpochs / interval)
trainMetric = numeric(adEpochs / interval)
valMetric = numeric(adEpochs / interval)

valMetrics = numeric(interval)

# prepare the data for the models
xAdv = trainBefore
xAdvClasses = vectorize(trainClasses)
yAdv = rep(1, nrow(train))

valAdv = valBefore
valAdvClasses = vectorize(valClasses)
valClass = rep(0, nrow(val))

x1 = standardEncoder |> predict(standardBefore, verbose = 0)
y1 = rep(1, nrow(standard))
y2 = rep(0, nrow(train))
yDis = c(y1, y2)
x1Classes = vectorize(standardClasses)
classesDis = c(x1Classes, xAdvClasses)

# set up stopping criterium
stopMin = 1

# train
time = timer({
    catEpoch = 0
    for(epoch in 1:adEpochs) {
        
        timeMe = timer({
            
            if(optimizing) color(cat("  Epoch", epoch), 242)
            
            x2 = Encoder |> predict(cbind(trainBefore, xAdvClasses), verbose = 0)
            xDis = rbind(x1, x2) |> cbind(classesDis)
            
            valDis = Encoder |> predict(cbind(valBefore, valAdvClasses), verbose = 0) |> cbind(valAdvClasses)
            
            history = Discriminator |> fit(
                x = xDis,
                y = yDis,
                batch_size = adBatchSize,
                epochs = 1,
                validation_data = list(valDis,
                                       valClass),
                verbose = 0
            )
            
            # freeze the Discriminator
            Discriminator$trainable = FALSE
            
            history = Adversary |> fit(
                x = list(cbind(xAdv, xAdvClasses), xAdvClasses),
                y = yAdv,
                batch_size = adBatchSize,
                epochs = 1,
                validation_data = list(list(cbind(valAdv, valAdvClasses), valAdvClasses), valClass),
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
            standardMetric[index] = evaluate(Discriminator, cbind(x1, x1Classes), y1, verbose = 0)[[2]]
            trainMetric[index] = evaluate(Adversary, list(cbind(xAdv, xAdvClasses), xAdvClasses), rep(0, nrow(train)), verbose = 0)[[2]]
            valMetric[index] = mean(valMetrics)
            
            # plot the data
            lastPlot = plotHistory(standardMetric, trainMetric, valMetric, adEpochs, interval, adMetric)
            if(optimizing) print(lastPlot)
            
            # print out the metrics
            if(optimizing) color(cat("    Standard: ", sprintf("%.3f", round(standardMetric[index], 3)), "    Train: ", sprintf("%.3f", round(trainMetric[index], 3)), "    Val: ", sprintf("%.3f", round(valMetric[index], 3)), "\n", sep = ""),12)

            # implement the stopping criteria
            if(epoch > waitEpoch) {
                lowPoint = mean(valMetrics)
                if(lowPoint < stopMin) {
                    stopCount = 0 # restart the count
                    stopMin = lowPoint # get the lowest metric so far
                    save_model_tf(Encoder, paste0(models, "encoder_", novelName, "_", embeddingSize, "D_", extraName), overwrite = TRUE) # save the Encoder
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
            progressData = Encoder |> predict(cbind(valBefore, valAdvClasses), verbose = 0)
            
            if(optimizing) color(catMetrics(progressData, "val", "embedded"), 5)
            
            # check if we want to stop for another reason
            if(optimizing && stall) {
                color(cat("Continue?"), 46)
                continue = readline()
                if(continue == "n") {
                    break
                } else if(continue == "s") {
                    stop("Stopped")
                }
            }
        }
    } # end for
}, min = TRUE)

cat("\nTrained in ", time, "\n", sep = "")

ggsave(paste0(plots, "_trainModel_", novelName, "_", extraName, ".jpg"), plot = lastPlot, width = 6, height = 4)

# output for validation
if(optimizing) cat("\n|", novelName, "|", adLayers, "|", adLayersD, "|", units, "|", adActFun, "|", adActFunD, "|", adOptim, "|", adDropout, "|", adBatchSize, "|", catEpoch, "|", round(sd(progressData) / max(progressData), 3), "|", round(max(progressData), 3), "|", round(stopMin, 3) * 100, "|")
