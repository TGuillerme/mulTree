#Whether to sample with replace or not in rTreeBind
get.replace<-function(x, sample) {
    if (sample == 1) {
        replace<-FALSE
    } else {
        if(class(x) == 'phylo') {
            replace<-TRUE
        } else {
            if (sample > length(x)) {
                replace<-TRUE
            } else {
                replace<-FALSE
            }
        }
    }
    return(replace)
}