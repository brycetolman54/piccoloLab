bakeFiles = function(files, recipe, subFolder = "") {
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
        eval(expr(write_tsv(!!sym(name), paste0("baked/", subFolder, name, ".tsv"))))
    }
}
