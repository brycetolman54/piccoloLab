color = function(fn, code = 15) {
  
    # Function to color output for nice formatting
    # 
    # Inputs:
    #   - fn (required): the code to be run whose output you want to color
    #   - code (required): the number of the code for the color that you want the output to be [default is 15, for white]
    #
    # Outputs:
    #   - Nothing
    #   - The output of the code will be colored, though
  
    cat("\u001b[38;5;", code, "m", sep = "")
    eval(fn)
    cat("\u001b[38;5;15m")
}
