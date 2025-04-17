readFiles = function(files,
                     folder = "merged/",
                     columns = c(),
                     getNames = FALSE,
                     rotate = TRUE) {
  
    # Function to read in files for future use
    # 
    # Inputs:
    #   - files (required): a list of files (as strings) which are to be read in
    #       you can pass in `ls(folderName)` to read in all of the contents of a given folder if desired
    #   - folder (optional): the folder from which to read the given files [default is "merged/", which is where the "collectMerged" function stores the collecte data sets]
    #   - columns (optional): the columns to keep from the read-in file [default is nothing, in the code, typically I read in the selected set of common genes among all the data sets and the Class column]
    #   - getNames (optional): whether or not to get and return the gene names of the data sets as they are read in
    #           this option is used only in the beginning script in which I collect all of the data sets and find the genes common to them all
    #   - rotate (optional): whether or not to rotate the data after it is read in
    #       this one is relevant as I found that the data sets read in faster if they are stored with the genes in rows instead of columns
    #       for the most part, leave this as it is. If things aren't working, check if the data set you are reading in has the genes stored in columns
    #       using the scripts I have provided to collect the data sets, you should be fine leaving `rotate` as TRUE
    #
    # Outputs:
    #   - A list of the gene names from each data set, if desired
  
    # initialize some variables
    size = length(files)
    geneNames = list()
    
    # loop the files to read each in
    for(i in 1:size) {
      
        # get the filename, if you have used `ls(folderName)`, the second line takes care of the file extension
        file = files[i]
        name = strsplit(file, "\\.")[[1]][1]
        
        # read in the file and rotate if needed
        cat("  Reading", name, "\t(", i, "/", size, ")\n")
        start = Sys.time()
        if(rotate) {
            eval(expr(!!sym(name) <<- read_tsv(paste0(folder, name, ".tsv"), show_col_types = FALSE) |> pivot_longer(cols = -names, names_to = "index", values_to = "values") |> pivot_wider(names_from = names, values_from = values) |> select(-index)))
        } else {
            eval(expr(!!sym(name) <<- read_tsv(paste0(folder, name, ".tsv"), show_col_types = FALSE)))
        }
        end = Sys.time()
        cat("\b\t", substring(seconds(end - start), 1, 5), " s\n", sep = "")
        
        # select the appropriate columns from the data
        if(length(columns) != 0) {
            eval(expr(!!sym(name) <<- eval(expr(!!sym(name))) |> select(all_of(columns))))
        }
        
        # collect the column names if desired
        if(getNames) {
            geneNames[[paste0("names", i)]] = eval(expr(names(!!sym(name))[-1]))
        }
    }
    
    # return the list of gene names if desired
    if(getNames) {
        return(geneNames)
    }
}
