cat("Training:\n\n")

# define some variables
epochs = 1000
interval = 10
batchSize = 64

stopCount = 0
stopMin = 1
stopWait = 40

# read in the Standard Encoder and Decoder
standardEncoder = load_model("models/10_Standard_Auto_Encoder/encoder.keras")
standardDecoder = load_model("models/10_Standard_Auto_Encoder/decoder.keras")

# set up vectors to hold the losses and metrics through the epochs
standardMetric = numeric(epochs / interval)
trainMetric = numeric(epochs / interval)
valMetric = numeric(epochs / interval)

valMetrics = numeric(interval)

# prepare the data for the models
xAdv = as.matrix(train)
yAdv = rep(1, nrow(train))

valAdv = as.matrix(val)
valClass = rep(0, nrow(val))

x1 = standardEncoder |> predict(as.matrix(standard), verbose = 0)
y1 = rep(1, nrow(standard))
y2 = rep(0, nrow(train))
yDis = c(y1, y2)

# train
time = timer({
    for(epoch in 1:epochs) {

        timeMe = timer({

            color(cat("  Epoch", epoch), 242)

            x2 = Encoder |> predict(as.matrix(train), verbose = 0)
            xDis = rbind(x1, x2)

            valDis = Encoder |> predict(as.matrix(val), verbose = 0)

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

        cat("\t", timeMe, "\n")

        # get the metrics
        if(epoch %% interval == 0) {

            index = epoch / interval

            # get the data
            standardMetric[index] = evaluate(Discriminator, x1, y1, verbose = 0)[[1]]
            trainMetric[index] = evaluate(Adversary, xAdv, rep(0, nrow(train)), verbose = 0)[[1]]
            valMetric[index] = mean(valMetrics)

            # plot the data
            plotHistory(standardMetric, trainMetric, valMetric, epochs, interval, metric)

            # print out the metrics
            color(cat("    Standard: ",
                      sprintf("%.3f", round(standardMetric[index], 3)),
                      "    Train: ",
                      sprintf("%.3f", round(trainMetric[index], 3)),
                      "    Val: ", 
                      sprintf("%.3f", round(valMetric[index], 3)),
                      "\n", sep = ""),12)

            # implement the stopping criteria
            if(epoch > 100) {
                if(valMetric[index] < stopMin) {
                    stopCount = 0
                    stopMin = valMetric[index]
                    saveModels()
                    color(cat("\b\tSaved\n"), 217)
                } else {
                    stopCount = stopCount + 1
                    color(cat("\b\t(", stopCount, "/", stopWait, ")\n", sep=""), 217)
                    if(stopCount == stopWait) {
                        break
                    }
                }
            }
        }

        # print the val stats every so often
        if(epoch %% 50 == 0) {
            progressData = Encoder |> predict(valMat, verbose = 0)

            color(printMetrics(progressData, "val", "embedded"), 5)

            if(stall) {
                color(cat("Continue?"), 46)
                continue = readline()
                if(continue == "n") {
                    break
                } else if(continue == "s") {
                    tryCatch({
                        stop("Stopped")
                    }, error = function(e){})
                } # end if else
            } # end if
        } # end if
    } # end for
}, min = TRUE)

cat("\nTrained in ", time, "\n", sep = "")

ggsave(paste0(plots, "_trainModel_", novelName, "_.jpg"), plot = last_plot(), width = 6, height = 4)

# output for validation
if(valCheck) {
    cat("\n|",
        layers, "|",
        dLayers, "|",
        units, "|",
        actFun, "|",
        dActFun, "|",
        optim, "|",
        dropout, "|",
        batchSize, "|",
        epoch, "|",
        round(sd(progressData) / max(progressData), 3), "|",
        round(max(progressData), 3), "|",
        round(valMetric[index], 3) * 100, "|"
    )
}
