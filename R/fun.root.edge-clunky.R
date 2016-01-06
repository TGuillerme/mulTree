#Adds an edge length to the phylogeny
fun.root.edge<-function(phy, root.age) {
    phy$root.edge<-root.age-max(node.depth.edgelength(phy))
    return(phy)
}