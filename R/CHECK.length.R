#Checking the class of an object and returning an error message if != class

CHECK.length<-function(object, length, msg, errorif=FALSE) {
    if(errorif==FALSE) {
        if(length(object) != length) {
            stop(as.character(substitute(object)), msg , call.=FALSE)
        }
    } else {
        if(length(object) == length) {
            stop(as.character(substitute(object)), msg , call.=FALSE)
        }        
    }
}
