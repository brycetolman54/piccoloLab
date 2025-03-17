# set the seed
tensorflow::set_random_seed(0)

# initialize some variables
inputSize = length(genes)
embeddingSize = 10
layers = 4
dropout = FALSE
layerDrop = ceiling((inputSize - embeddingSize) / layers)
actFun = "elu"
optimizer = "adam"
loss = "mse"
metric = "mae"

# define the Encoder
Encoder = keras_model_sequential(input_shape = c(inputSize),
                                 name = "standardEncoder")
for(layer in 1:(layers - 1)) {
    Encoder |> 
        layer_dense(units = inputSize - layerDrop * layer,
                    activation = actFun,
                    name = paste0("Deflate_", layer))
    if(dropout) {
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
for(layer in 1:(layers - 1)) {
    Decoder |> 
        layer_dense(units = embeddingSize + layerDrop * layer,
                    activation = actFun,
                    name = paste0("Inflate_", layer))
    if(dropout) {
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
    optimizer = optimizer,
    loss = loss,
    metrics = metric
)
