#Creates the list of trees to sample (with or without replacement)
fun.sample.trees<-function(tree, sample, replace) {
    rand<-sample(1:length(tree), sample, replace=replace)
    return(rand)
}