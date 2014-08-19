CHECK.class<-function(object, class, msg) {
    if(class(object) != class) {
        stop(as.character(substitute(object)), msg , call.=FALSE)
    }
}