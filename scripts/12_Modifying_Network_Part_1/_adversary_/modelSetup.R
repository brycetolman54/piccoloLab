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
    Discriminator = keras_model_sequential(input_shape = c(embeddingSize),
                                           name = "Discriminator")
    for(layer in 1:(adLayersD - 1)) {
        Discriminator |>
            layer_dense(units = units,
                        activation = adActFunD,
                        name = paste0("D", layer))
            # layer_batch_normalization() |>
            # layer_activation(adActFunD)
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
    input = layer_input(inputSize, name = "Input")
    embedding = Encoder(input)
    output = Discriminator(embedding)
    Adversary = keras_model(input, output)
    
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


