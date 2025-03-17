# read in models
standardEncoder = load_model(paste0(models, "standardEncoder.keras"))
standardDecoder = load_model(paste0(models, "standardDecoder.keras"))
Encoder = load_model(paste0(models, "encoder_", novelName, ".keras"))

# predict on the data
standardDuring = standardEncoder |> predict(standardBefore, verbose = 0)
standardAfter = standardDecoder |> predict(standardDuring, verbose = 0)
for(i in 4:6) assign(matData[i], Encoder |> predict(get(matData[i - 3]), verbose = 0))
for(i in 7:9) assign(matData[i], standardDecoder |> predict(get(matData[i - 3]), verbose = 0))

# redefine some lists
dataNames = c("standard", data)
matDataNames = as.vector(outer(dataNames, times, paste0))
tibbleData = paste0(matDataNames, "Tibble")
classNames = paste0(dataNames, "Classes")
size = 4

# show the metrics of the data sets 
cat("\n## Data Metrics\n\n")
cat("| Data Set | Max | Min | Mean | Median | SD |\n")
cat("|:---:|:---:|:---:|:---:|:---:|:---:|\n")
for(i in 1:12) catMetrics(get(matDataNames[i]), dataNames[((i - 1) %% 4) + 1], times[ceiling(i / 4)])
cat("\n")

# make the data tibbles with classes again
for(i in 1:12) assign(tibbleData[i], tibblerize(get(matDataNames[i]), get(classNames[((i - 1) %% 4) + 1])))

# predict on all the sets
for(i in 1:3) predictData(trainer = tibbleData[((i - 1) * size) + 1], start = ((i - 1) * size) + 2, stop = i * size, time = times[i])