#Extracting tip labels from a tree (in alphabetical order)
select.tip.labels <- function(tree, sort=TRUE) {
    if(sort == TRUE) {
        return(sort(tree$tip.label))
    } else {
        return(tree$tip.label)
    }
}

#Transform specimens in unique species occurrences if necessary
specimen.transform <- function(data) {
    #Checking if they are multiple specimens in the data
    if(length(unique(data$sp.col)) == length(data$sp.col)) {
        #all entries are unique
        return(data)
    } else {
        #remove the duplicated names (create a dummy data)
        return(data.frame("sp.col"=unique(data$sp.col), "dummy"=rnorm(length(unique(data$sp.col)))))
    }
}

#Testing if the data can be use in comparative.data
comparative.data.test <- function(data, tree) {
    #Try lapply loop
    comparative.data.try <- function(...) {
        return(try(caper::comparative.data(...), silent = TRUE))
    }

    #Testing each tree
    test <- lapply(tree, comparative.data.try, data = specimen.transform(data), names.col = "sp.col", vcv = FALSE)

    #All outputs must be "comparative.data" and match the lenght of the tree object
    test_results <- unlist(lapply(test, class))
    if(length(test_results) != length(tree)) {
        return(FALSE)
    } else {
        if(any(test_results != "comparative.data")) {
            return(FALSE)
        } else {
            return(TRUE)
        }
    }
}

