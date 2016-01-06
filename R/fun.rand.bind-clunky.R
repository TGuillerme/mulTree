#Randomly binds trees together
fun.rand.bind<-function(x, y, x.single.tree, y.single.tree, sample, replace.x, replace.y, root.age){
    #Creating a empty multiPhylo object
    z<-rmtree(sample,2)

    #Sample list
    randX<-fun.sample.trees(x, sample, replace.x)
    randY<-fun.sample.trees(y, sample, replace.y)

    #Binding the trees together by adding the root.age
    for (n in 1:sample) {
        if(x.single.tree == FALSE & y.single.tree == FALSE) {
            z[[n]]= fun.root.edge(x[[randX[n]]], root.age ) + fun.root.edge(y[[randY[n]]], root.age )
            #z[[n]]<-bind.tree( fun.root.edge(x[[randX[n]]], root.age ), fun.root.edge(y[[randX[n]]], root.age ) ,where="root", position=root.age-max(node.depth.edgelength(y[[randX[n]]])) )
        } 

        if(x.single.tree == TRUE & y.single.tree == TRUE) {
            z[[n]]= fun.root.edge(x, root.age ) + fun.root.edge(y, root.age )
            #z[[n]]<-bind.tree( fun.root.edge(x, root.age ), fun.root.edge(y, root.age ) ,where="root", position=root.age-max(node.depth.edgelength(x)) )
        } 

        if(x.single.tree == TRUE & y.single.tree == FALSE) {
            z[[n]]= fun.root.edge(x, root.age ) + fun.root.edge(y[[randY[n]]], root.age )
            #z[[n]]<-bind.tree( fun.root.edge(x, root.age ), fun.root.edge(y[[randY[n]]], root.age ) ,where="root", position=root.age-max(node.depth.edgelength(y[[randX[n]]])) )
        } 

        if(x.single.tree == FALSE & y.single.tree == TRUE) {
            z[[n]]= fun.root.edge(x[[randX[n]]], root.age ) + fun.root.edge(y, root.age )
            #z[[n]]<-bind.tree( fun.root.edge(x[[randX[n]]], root.age ), fun.root.edge(y, root.age), where="root", position=root.age-max(node.depth.edgelength(y)) )
        } 

    }

    if(length(z) != 1) {
        return(z)
    } else {
        Z<-z[[1]]
        return(Z)
    }

}