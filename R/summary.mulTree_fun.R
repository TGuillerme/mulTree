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
    quantile_out <- stats::quantile(X, probs = prob.converter(prob), ...)
    #Calculate the central tendency
    return(list("quantiles" = quantile_out, "central" = cent.tend(X)))
}

#Smoothing the hdr (if more than one value for the prob region)
smooth.hdr <- function(hdr_out, prob, name) {
    #Test if smoothing needed
    if(length(hdr_out$hdr) > length(prob)*2) {
        #Smooth the values
        new_hdr <- matrix(NA, nrow=length(prob), ncol=2)
        for(CI in 1:nrow(hdr_out$hdr)) {
            new_hdr[CI, ] <- c(min(hdr_out$hdr[CI, ], na.rm = TRUE), max(hdr_out$hdr[CI, ], na.rm = TRUE))
        }
        hdr_out$hdr <- new_hdr
        #Print some warning!
        message("Warning message:\n", name, " has multiple highest density regions (hdr) for some probabilities.\nOnly the maximum and the minimum hdr were used for each probabilities.", sep="")
    }
    return(hdr_out)
}

#Calculate the hdr from a vector (for lapply)
lapply.hdr <- function(X, name, prob, ...) {
    #Calculate the hdr
    hdr_out <- hdrcde::hdr(X, prob, ...)

    #Smooth the results (if needed)
    hdr_out <- smooth.hdr(hdr_out, prob, name)

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