bakeFiles = function(files, recipe) {
  
    # Function to bake data files and show the progress of the baking
    # 
    # Inputs:
    #   - files (required): a vector of strings that represent data sets that are to be baked
    #            these data sets need to exist beforehand, and you must pass in the name
    #            of the data set, not the data set itself
    #   - recipe (required): the recipe (base out of the `tidymodels` package) with which to bake the data
    # 
    # Outputs:
    #   - Nothing
    #   - Each set that is baked is saved under the name it already had
  
    size = length(files)
    geneNames = list()
    for(i in 1:size) {
        file = files[i]
        name = strsplit(file, "\\.")[[1]][1]
        cat("  Baking", name, "\t(", i, "/", size, ")")    
        start = Sys.time()
        eval(expr(!!sym(name) <<- bake(recipe, new_data = !!sym(name))))
        end = Sys.time()
        cat("\t", substring(seconds(end - start), 1, 5), " s\n", sep = "")
    }
}
