## SANITYZING FUNCTIONS
## Checking the class of an object and returning an error message if != class
check.class <- function(object, class, msg, errorif = FALSE) {
    ## Get call
    match_call <- match.call()

    ## class_object variable initialisation
    class_object <- class(object)[1]
    ## class_length variable initialisation
    length_class <- length(class)

    ## Set msg if missing
    if(missing(msg)) {
        if(length_class != 1) {
            msg <- paste(" must be of class ", paste(class, collapse = " or "), ".", sep = "")
        } else {
            msg <- paste(" must be of class ", class, ".", sep = "")
        }
    }

    ## check if object is class.
    if(length_class != 1) {
    ## check if object is class in a cascade (class[1] else class[2] else class[3], etc..)
    ## returns error only if object is not of any class

        error <- NULL
        for(counter in 1:length_class) {
            if(errorif != TRUE) {
                if(class_object != class[counter]) {
                    error <- c(error, TRUE)
                } else {
                    error <- c(error, FALSE)
                }
            } else {
                if(class_object == class[counter]) {
                    error <- c(error, TRUE)
                } else {
                    error <- c(error, FALSE)
                }
            }
        }
        ## If function did not return, class is not matching
        if(!any(!error)) {
            stop(match_call$object, msg, call. = FALSE)
        } else {
            return(class_object)
        }

    } else {
        if(errorif != TRUE) {
            if(class_object != class) {
                stop(match_call$object, msg , call. = FALSE)
            }
        } else {
            if(class_object == class) {
                stop(match_call$object, msg , call. = FALSE)
            }        
        }
    } 
}


## Checking the class of an object and returning an error message if != class
check.length <- function(object, length, msg, errorif = FALSE) {

    match_call <- match.call()

    if(errorif != TRUE) {
        if(length(object) != length) {
            stop(match_call$object, msg , call. = FALSE)
        }
    } else {
        if(length(object) == length) {
            stop(match_call$object, msg , call. = FALSE)
        }        
    }
}