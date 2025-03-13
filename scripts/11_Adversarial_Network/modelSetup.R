cat("Preparing Models:")

time = timer({
    # set the seed
    tensorflow::set_random_seed(0)
    
    # set some variables (for the encoder)
    inputSize = length(genes)
    embeddingSize = 10
    layers = 6
    layerDrop = ceiling((inputSize - embeddingSize) / layers)
    actFun = "elu"
    
    optim = "adam"
    lr = 0.0001
    optimizer = optimizer_adam(learning_rate = lr)
    dOptimizer = optimizer_adam(learning_rate = lr)
    loss = "binary_crossentropy"
    metric = "accuracy"
    
    dLayers = 6
    units = 32
    dActFun = "elu"
    dropout = FALSE
    rate = 0.4
    
    # define the encoder
    Encoder = keras_model_sequential(input_shape = c(inputSize),
                                     name = "Encoder")
    for(layer in 1:(layers - 1)) {
        Encoder |> 
            layer_dense(units = inputSize - layerDrop * layer,
                        activation = actFun,
                        name = paste0("Deflate_", layer))
        if(dropout) {
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
    for(layer in 1:(dLayers - 1)) {
        Discriminator |>
            layer_dense(units = units,
                        # activation = dActFun,
                        name = paste0("D", layer)) |>
            layer_batch_normalization() |>
            layer_activation(dActFun)
        if(dropout) {
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
    Adversary |> compile(optimizer = optimizer,
                         loss = loss,
                         metric = metric)
    
    # Compile the Discriminator
    Discriminator |> compile(optimizer = dOptimizer,
                             loss = loss,
                             metric = metric)
})

cat("\t", time, "\n\n")


