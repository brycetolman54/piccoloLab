timer = function(code,
                 min = FALSE) {
  
    # Function to keep track of the time it takes to complete tasks
    #
    # Inputs:
    #   - code (required): the code to be run whose time you want to track
    #   - min (optional): whether to keep track of the time in minutes or seconds [default is FALSE, meaning seconds]
    #
    # Outputs:
    #   - a string of the time taken to complete the code, rounded to 3 decimal places
  
    start = Sys.time()
    eval(code)
    end = Sys.time()
    if(min) {
        diff = round(as.numeric(difftime(end, start, units = "sec")) / 60, 3)
        return(paste0(diff, " m"))
    }
    else {
        diff = round(as.numeric(difftime(end, start, units = "sec")), 3)
        return(paste0(diff, " s"))
    }
}