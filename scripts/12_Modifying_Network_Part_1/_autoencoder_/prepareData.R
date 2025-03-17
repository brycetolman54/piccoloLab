# read in the data
for(name in standardNames) if(!exists(name)) readFiles(name, columns = c("Class", genes))
Standard = bind_rows(mget(standardNames))

# split the data
if(normalize) Standard = Standard |> select(-Class) |> mutate(across(where(is.numeric), ~ (. - mean(.)) / sd(.))) |> bind_cols((Standard |> select(Class)))
split = splitData(Standard, 0.3, 0.3, 0)
StandardMat = as.matrix(Standard |> select(-Class))

# save this data set for later use
write_tsv(Standard, paste0(vars, "standard.tsv"))
standard = Standard

# define lists
standardTimes = paste0(times, "Standard")
standardData = paste0(data, "Standard")
dataClasses = paste0(data, "Classes")
standardClasses = paste0(standardData, "Classes")
standardMat = paste0(standardData, "Mat")

# gather the data
for(i in 1:3) assign(standardData[i], split[[data[i]]])
for(i in 1:3) assign(standardClasses[i], split[[dataClasses[i]]])
for(i in 1:3) assign(standardMat[i], as.matrix(get(standardData[i])))

# prepare folders
plots = paste0("plots/", subfolder, "_autoencoder_/")
if(!dir.exists(plots)) dir.create(plots)
