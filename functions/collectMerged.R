collectMerged = function(filename, 
                colStart = "GSM", 
                classColumn = "er_status_ihc", 
                classPositive = c("P"),
                classNegative = c("N"),
                output = FALSE,
                geneData = TRUE) {
  
    # Function to collect the gene expression data and metadata for a data set, extract the proper
    # and combine those into a single data set for later use
    #
    # Inputs:
    #   - filename (required): the name of the file from which to collect the data
    #           the function assumes the expression data is found in a folder labeled "data"
    #           and that the metadata is found in a file labeled "meta" and that the file in 
    #           both has the same name
    #   - colStart (required): the prefix to the gene names in the file [default is GSM, which is true for most of the data sets]
    #   - classColumn (required): the column from which to get the Class data for the data set [default is er_status_ihc, which is true for GSE25055]
    #   - classPositive (required): a list of values that signify a positive signal for the Class [default is c("P"), which is true for GSE25055]
    #   - classNegative (required): a list of values that signify a negative signal for the Class [default is c("N"), which is true for GSE25055]
    #   - output (optional): a boolean that determines if the function should return the adjusted data set [dfault is FALSE]
    #   - geneData (optional): a boolean that determines whether or not to filter the genes based on whether they are protein-endcoding and 
    #                          whether they are found on Chromosomes 1-23 and X/Y (this is relevant for data sets that do not have columns
    #                          specifying the above things, which some of the ones added to our set later do not) [default is TRUE]
    #
    # Outputs:
    #   - a file saved to a directory labeled "merged" under the same name as the expression and meta data
    #   - (if desired) the newly created data set for further use
    
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
