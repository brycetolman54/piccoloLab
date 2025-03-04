readFiles = function(files, folder = "merged/", columns = c(), getNames = FALSE, rotate = TRUE) {
    size = length(files)
    geneNames = list()
    for(i in 1:size) {
        file = files[i]
        name = strsplit(file, "\\.")[[1]][1]
        cat("  Reading", name, "\t(", i, "/", size, ")\n")
        start = Sys.time()
        if(rotate) {
            eval(expr(!!sym(name) <<- read_tsv(paste0(folder, name, ".tsv"), show_col_types = FALSE) |> pivot_longer(cols = -names, names_to = "index", values_to = "values") |> pivot_wider(names_from = names, values_from = values) |> select(-index)))
        } else {
            eval(expr(!!sym(name) <<- read_tsv(paste0(folder, name, ".tsv"), show_col_types = FALSE)))
        }
        end = Sys.time()
        cat("\b\t", substring(seconds(end - start), 1, 5), " s\n", sep = "")
        if(length(columns) != 0) {
            eval(expr(!!sym(name) <<- eval(expr(!!sym(name))) |> select(all_of(columns))))
        }
        if(getNames) {
            geneNames[[paste0("names", i)]] = eval(expr(names(!!sym(name))[-1]))
        }
    }
    if(getNames) {
        return(geneNames)
    }
}
