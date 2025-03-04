timer = function(code, min = FALSE) {
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