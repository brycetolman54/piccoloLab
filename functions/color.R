color = function(fn, code) {
    cat("\u001b[38;5;", code, "m", sep = "")
    eval(fn)
    cat("\u001b[38;5;15m")
}
