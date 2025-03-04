# load the genes
genes = readLines("variables/lessGenes.txt")[1:100]

# load the data
dataSets = c("METABRIC", "GSE62944")
if(!exists("METABRIC") || !exists("GSE62944")) {
    readFiles(dataSets, columns = c("Class", genes))
}
standard = METABRIC
novel = GSE62944

split = splitData(novel, 0.3, 0.3, 0)

train = split$train
trainClasses = split$trainClasses
val = split$val
valClasses = split$valClasses
test = split$test
testClasses = split$testClasses

# remove classes
standardClasses = standard |> select(Class) |> mutate(Class = as.factor(Class))
standard = standard |> select(-Class)

# make the data matrices
trainMat = as.matrix(train)
valMat = as.matrix(val)
testMat = as.matrix(test)
standardMat = as.matrix(standard)

