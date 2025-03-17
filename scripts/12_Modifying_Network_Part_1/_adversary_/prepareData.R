# define folders
plots = paste0("plots/", subfolder, novelName, "/")
if(!dir.exists(plots)) dir.create(plots)

# TODO: DO I NEED TO STANDARDIZE THE DATA HERE???

# load the data
newNovelName = paste0("new", novelName)

if(!exists("Standard")) {
    readFiles("standard", folder = vars, columns = c("Class", genes), rotate = FALSE)
    Standard = standard
}
if(!exists(novelName)) readFiles(novelName, columns = c("Class", genes))

novel = get(novelName)
assign(newNovelName, novel)

split = splitData(novel, 0.3, 0.3, 0)

for(datum in data) assign(datum, split[[datum]])
for(class in classes) assign(class, split[[class]])

# remove classes
standardClasses = Standard |> select(Class) |> mutate(Class = as.factor(Class))
standard = Standard |> select(-Class)

# make the data matrices
for(i in 1:3) assign(matData[i], as.matrix(get(data[i])))
standardBefore = as.matrix(standard)

