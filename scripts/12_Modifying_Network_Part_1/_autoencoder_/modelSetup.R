# set the seed
tensorflow::set_random_seed(tfSeed)

# get the optimizer
aeOptimizer = do.call(get(paste0("optimizer_", aeOptim)), list(learning_rate = aeLr))

# define the Encoder
Encoder = keras_model_sequential(input_shape = c(inputSize),
                                 name = "standardEncoder")
for(layer in 1:(aeLayers - 1)) {
    Encoder |> 
        layer_dense(units = inputSize - aeLayerDrop * layer,
                    activation = aeActFun,
                    name = paste0("Deflate_", layer))
    if(aeDropout) {
        Encoder|>
            layer_dropout(rate = 0.4,
                          name = paste0("Dropout_", layer))
    }
}
Encoder |>
    layer_dense(units = embeddingSize,
                name = "Embedding")

# define the Decoder
Decoder = keras_model_sequential(input_shape = c(embeddingSize),
                                 name = "standardDecoder")
for(layer in 1:(aeLayers - 1)) {
    Decoder |> 
        layer_dense(units = embeddingSize + aeLayerDrop * layer,
                    activation = aeActFun,
                    name = paste0("Inflate_", layer))
    if(aeDropout) {
        Decoder |>
            layer_dropout(rate = 0.4,
                          name = paste0("Dropout_", layer))
    }
}
Decoder |>
    layer_dense(units = inputSize,
                name = "Output")

# build the AutoEncoder
input = layer_input(shape = c(inputSize),
                    name = "Input")
encodedLayer = Encoder(input)
decodedLayer = Decoder(encodedLayer)
AutoEncoder = keras_model(inputs = input,
                          outputs = decodedLayer,
                          name = "standardAutoEncoder")

# compile the AutoEncoder
AutoEncoder |> compile(
    optimizer = aeOptimizer,
    loss = aeLoss,
    metrics = aeMetric
)
