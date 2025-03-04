collectMerged = function(filename, 
                colStart = "GSM", 
                classColumn = "er_status_ihc", 
                classPositive = c("P"),
                classNegative = c("N"),
                output = FALSE,
                geneData = TRUE) {
    
    # Make sure we have the requisite args
    if(missing(filename)) {
        stop("Error: you must provide the filename")
    }
    
    # Print out some info
    cat("  Collecting ", filename, ":", sep = "")
    cat("\n    Start:\t", colStart,
        "\n    Column:\t", classColumn,
        "\n    Positive:\t", classPositive,
        "\n    Negative:\t", classNegative,
        "\n    geneData:\t", geneData, "\n\n", sep = "")

    start = Sys.time()
    
    # Get the data in
    data = read_tsv(show_col_types = FALSE, paste0("data/", filename, ".tsv"))
    if(geneData) {
        data = data |> dplyr::filter(Chromosome %in% c(seq(1,22), "X", "Y")) |>
                       dplyr::filter(Gene_Biotype == "protein_coding")
    }
    data = data |> select(Ensembl_Gene_ID, starts_with(colStart)) |>
        pivot_longer(cols = starts_with(colStart),
                     names_to = "Sample_ID",
                     values_to = "Values") |>
        pivot_wider(names_from = Ensembl_Gene_ID,
                    values_from = Values)

    # Get the meta data in
    meta = read_tsv(show_col_types = FALSE, paste0("meta/", filename, ".tsv")) |>
        mutate(Class = ifelse(!!sym(classColumn) %in% classPositive, 1, ifelse(!!sym(classColumn) %in% classNegative, 0, NA))) |>
        select(Sample_ID, Class)
    
    # Merge the data
    merged = merge(data, meta) |>
        select(Class, everything(), -Sample_ID) |>
        drop_na(Class) |>
        mutate(index = row_number()) |>
        pivot_longer(cols = -index, names_to = "names", values_to = "values") |>
        pivot_wider(names_from = index, values_from = values)
    
    # Write out the data
    write_tsv(merged, paste0("merged/", filename, ".tsv"))
    
    end = Sys.time()
    
    cat("\b\b\n    Time:\t", substring(seconds(end - start), 1, 5), " s", sep = "")
    
    if(output) {
        return(merged)
    }

}
