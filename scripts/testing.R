alter = function(filename) {
    data = read_tsv(paste0("merged/old/", filename, ".tsv"), show_col_types = FALSE) |>
        mutate(index = row_number()) |>
        pivot_longer(cols = -index,
                     names_to = "names",
                     values_to = "values") |>
        pivot_wider(names_from = index,
                    values_from = values)
    write_tsv(data, paste0("merged/", filename, ".tsv"))
    return(data)
}

files = list.files("merged/old/")
for(i in 1:length(files)) {
    file = files[i]
    name = strsplit(file, "\\.")[[1]][1]
    cat("Altering ", file, "\t(", i, "/", length(files), ")\n", sep = "")
    alter(name)
}

rm(files, file, name, i, alter)