################################################################################
# reads in and prepares data sets for use in the later scripts, also sets up som
# e folders for later use
################################################################################

# define folders
plots = paste0("plots/", subfolder, novelName, "/")
if(!dir.exists(plots)) dir.create(plots)

# load the data
newNovelName = paste0("new", novelName)

if(!exists("Standard")) {
    readFiles(paste0("standard", extraName), folder = vars, columns = c("Class", genes), rotate = FALSE)
    Standard = get(paste0("standard", extraName))
}
if(!exists(novelName)) readFiles(novelName, columns = c("Class", genes))

novel = get(novelName)
assign(newNovelName, novel)

if(normalize) novel = novel |> select(-Class) |> mutate(across(where(is.numeric), ~ (. - mean(.)) / sd(.))) |> bind_cols((novel |> select(Class)))

split = splitData(novel, 0.3, 0.3, 0)

for(datum in data) assign(datum, split[[datum]])
for(class in classes) assign(class, split[[class]])

# remove classes
standardClasses = Standard |> select(Class) |> mutate(Class = as.factor(Class))
standard = Standard |> select(-Class)

# make a set for initialClassification use
standarD = Standard

# make the data matrices
for(i in 1:3) assign(matData[i], as.matrix(get(data[i])))
standardBefore = as.matrix(standard)

