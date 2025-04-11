# set up the optimizers
adOptimizer = do.call(get(paste0("optimizer_", adOptim)), list(learning_rate = lr))
adOptimizerD = do.call(get(paste0("optimizer_", adOptim)), list(learning_rate = lr))

cat("Preparing Model:")

time = timer({
    # set the seed
    tensorflow::set_random_seed(tfSeed)
    
    # define the encoder
    Encoder = keras_model_sequential(input_shape = c(inputSize),
                                     name = "Encoder")
    for(layer in 1:(adLayers - 1)) {
        Encoder |> 
            layer_dense(units = inputSize - adLayerDrop * layer,
                        activation = adActFun,
                        name = paste0("Deflate_", layer))
        if(adDropout) {
            Encoder |>
                layer_dropout(rate = rate,
                              name = paste0("Dropout_", layer))
        }
    }
    Encoder |>
        layer_dense(units = embeddingSize,
                    name = "Embedding")
    
    # define the discriminator
    Discriminator = keras_model_sequential(input_shape = c(embeddingSize + 1),
                                           name = "Discriminator")
    for(layer in 1:(adLayersD - 1)) {
        Discriminator |>
            layer_dense(units = units,
                        name = paste0("D", layer)) |>
            layer_batch_normalization() |>
            layer_activation(adActFunD)
        if(adDropout) {
            Discriminator |>
                layer_dropout(rate = rate,
                              name = paste0("Dropout_", layer))
        }
    }
    Discriminator |>
        layer_dense(units = 1,
                    activation = "sigmoid",
                    name = "Output")
    
    # combine them into the Adversary
    genesInput = layer_input(inputSize, name = "Input")
    classesInput = layer_input(shape = 1, name = "Classes")
    embedding = Encoder(genesInput)
    concat = layer_concatenate(list(embedding, classesInput), name = "Concat")
    output = Discriminator(concat)
    Adversary = keras_model(list(genesInput, classesInput), output, name = "Adversary")
    
    # compile the Adversary
    Adversary |> compile(optimizer = adOptimizer,
                         loss = adLoss,
                         metric = adMetric)
    
    # Compile the Discriminator
    Discriminator |> compile(optimizer = adOptimizerD,
                             loss = adLoss,
                             metric = adMetric)
})

cat("\t", time, "\n\n")


