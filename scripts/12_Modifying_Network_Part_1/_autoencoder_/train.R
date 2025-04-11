# make a callback function
stopEarly = callback_early_stopping(
    monitor = "val_loss",
    patience = 20,
    restore_best_weights = TRUE,
    mode = "min"
)

cat("\n  Training network:", sep = "")

time = timer({
    # train the AutoEncoder
    history = AutoEncoder |> fit(
        x = get(standardMat[1]),
        y = get(standardMat[1]),
        batch_size = aeBatchSize,
        epochs = aeEpochs,
        validation_data = list(get(standardMat[2]),
                               get(standardMat[2])),
        callbacks = stopEarly,
        verbose = ifelse(optimizing, 1, 0)
    )
}, min = TRUE)

cat(" Done in", time, "\n")

# save models
save_model_tf(Encoder, paste0(models, "standardEncoder_", embeddingSize, "D_", extraName), overwrite = TRUE)
save_model_tf(Decoder, paste0(models, "standardDecoder_", embeddingSize, "D_", extraName), overwrite = TRUE)

