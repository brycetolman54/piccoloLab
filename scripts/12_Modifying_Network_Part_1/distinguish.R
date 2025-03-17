# redefine lists
dataNames = novelNames
size = length(dataNames)
classNames = paste0(dataNames, "Classes")
encoders = paste0("encoder", dataNames)
tibbleData = as.vector(outer(dataNames, times, paste0))
matDataNames = paste0("mat", tibbleData)

# define plots folder
plots = paste0("plots/distinguish/")
if(!dir.exists(plots)) dir.create(plots)

# load the Encoders and Decoder
decoder = load_model(models, "standardDecoder.keras")
for(i in 1:size) assign(encoders[i], load_model(paste0(models, "encoder_", dataNames[i], ".keras")))

# load the data
for(datum in dataNames) if(!exists(datum)) readFiles(datum, columns = c("Class", genes))
cat("\n")

# get the data sets
for(i in 1:size) assign(classNames[i], get(dataNames[i]) |> select(Class))
for(i in 1:size) assign(matDataNames[i], as.matrix(get(dataNames[i]) |> select(-Class)))
for(i in 1:size) assign(matDataNames[i + size], get(encoders[i]) |> predict(get(matDataNames[i]), verbose = 0))
for(i in 1:size) assign(matDataNames[i + 2 * size], decoder |> predict(get(matDataNames[i + size]), verbose = 0))
for(i in 1:(3 * size)) assign(tibbleData[i], tibblerize(get(matDataNames[i]), get(classNames[((i - 1) %% size) + 1])))

# make predictions
for(i in 1:3) predictData(trainer = tibbleData[((i - 1) * size) + 1], start = ((i - 1) * size) + 2, stop = i * size, time = times[i])

