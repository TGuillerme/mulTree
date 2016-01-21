#is.wholenumber from ?is.integer example
is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) {
    abs(x - round(x)) < tol
}

#converts probabilities into quantile
prob.converter <- function(prob) {
    sort(c(50-prob/2, 50+prob/2)/100)
}

#Calculate the quantiles from a vector (for lapply)
lapply.quantile <- function(X, prob, cent.tend, ...) {
    #Get the quantiles
    quantile_out <- quantile(X, probs = prob.converter(prob), ...)
    #Calculate the central tendency
    return(list("quantiles" = quantile_out, "central" = cent.tend(X)))
}

#Calculate the hdr from a vector (for lapply)
lapply.hdr <- function(X, prob, ...) {
    #Calculate the hdr
    hdr_out <- hdr(X, prob, ...)
    #Transform the hdr output into a vector
    hdr_out[[1]] <- sort(hdr_out[[1]])
    return(hdr_out)
}

#Transform a list into table
result.list.to.table <- function(list) {
    #Getting the credibility intervals
    credibility_intervals <- matrix(unlist(sapply(list, "[", 1)), nrow = length(list), byrow = TRUE)
    #Getting the central tendencies (get only the first elements)
    central_tendency <- matrix(unlist(lapply(sapply(list, "[", 2), "[[", 1)), nrow = length(list), byrow = TRUE)
    #combine the results
    return(cbind(central_tendency, credibility_intervals))
}
