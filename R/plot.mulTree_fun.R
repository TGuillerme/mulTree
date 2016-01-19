#Setting ylim
get.ylim <- function(matrix) {
    return(c(min(matrix, na.rm=TRUE) - 0.01*min(matrix, na.rm=TRUE), max(matrix, na.rm=TRUE) + 0.01*(max(matrix, na.rm=TRUE))))
}

# Get the width of a box
get.width <- function(box_width, term, CI) {
    return(c(term - box_width[CI], term - box_width[CI], term + box_width[CI], term + box_width[CI]))
}

# Get the height of a box
get.height <- function(data_CI, term, CI) {
    return(c(data_CI[term, 2 + (CI-1)] , rep(data_CI[term, ncol(data_CI) - (CI-1)], 2), data_CI[term, 2 + (CI-1)]))
}