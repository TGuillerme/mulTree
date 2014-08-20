#Checking the class of an object and returning an error message if != class

check.class<-function(object, class, msg, errorif=FALSE) {
    #check if object is class.
    if(length(class) == 1) {
        if(errorif==FALSE) {
            if(class(object) != class) {
                stop(as.character(substitute(object)), msg , call.=FALSE)
            }
        } else {
            if(class(object) == class) {
                stop(as.character(substitute(object)), msg , call.=FALSE)
            }        
        }
    } else {
    #check if object is class in a cascade (class[1] else class[2] else class[3], etc..)
    #returns error only if object is not of any class
        for (i in 1:length(class)) {
            if(class(object) == class[i]) {
                class.test<-class[i]
            }        
        }
        if(exists(as.character(quote(class.test)))) {
            return(class.test)
        } else {
            stop(as.character(substitute(object)), msg , call.=FALSE)
        }
    }
}