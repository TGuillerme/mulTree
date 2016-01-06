#' @title Randomly binding trees together
#'
#' @description Randomly binds trees together with a provided number of trees and a root age.
#'
#' @param x,y Two \code{phylo} or \code{multiPhylo} objects.
#' @param sample The number of trees to create.
#' @param root.age The age of the root where both trees are combined (can be any unit).
#'
#' @return
#' If \code{x}, \code{y} and \code{sample} are \eqn{>1}, the function returns a \code{multiPhylo} object; else it returns a \code{phylo} object.
#'
#' @examples
#' ##Combines 2 randomly chosen trees from x and from y into z putting the root age at 12.
#' x <- rmtree(10, 5) ; y <- rmtree(5, 5)
#' z <- tree.bind(x, y, sample = 3, root.age = 12)
#' z # 3 phylogenetic trees
#' 
#' ##Combines one mammal and and one bird tree and setting the root age at 250 Mya.
#' data(lifespan)
#' combined_trees <- tree.bind(trees_mammalia, trees_aves, sample = 1, root.age = 250)
#' plot(conbined_trees) # A tree with both mammals and aves
#' 
#' @author Thomas Guillerme

tree.bind<-function(x, y, sample, root.age) {

    # Get call
    match_call<-match.call()

    #SANITIZING
    #trees
    # getting the class of each tree object (and checking their class)
    x.class <- check.class(x, c("multiPhylo", "phylo"))
    y.class <- check.class(y, c("multiPhylo", "phylo"))

    # transforming the trees into multiPhylo objects
    if(x.class == "phylo") x <- list(x) ; class(x) <- "multiPhylo"
    if(y.class == "phylo") y <- list(y) ; class(y) <- "multiPhylo"

    #sample
    check.class(sample, "numeric")
    # checking if sample is > or < than the number of trees provided
    replace.x <- get.replace(x, sample)
    if(replace.x == TRUE) {
        warning("The sample is a higher than the number of trees in ", match_call$x, ".\n", match_call$x, " will be re-sampled.", call.=FALSE)
    }
    replace.y <- get.replace(y, sample)
    if(replace.y == TRUE) {
        warning("The sample is a higher than the number of trees in ", match_call$y, ".\n", match_call$y, " will be re-sampled.", call.=FALSE)
    }

    #root age
    check.class(root.age, "numeric")

    #RANDOMLY BINDING THE TREES







#Randomly binds trees together
fun.rand.bind<-function(x, y, x.single.tree, y.single.tree, sample, replace.x, replace.y, root.age){
    #Creating a empty multiPhylo object
    z<-rmtree(sample,2)

    # Sample draws
    randX <- sample.trees(x, sample, replace.x)
    randY <- sample.trees(y, sample, replace.y)

    #Binding the trees together by adding the root.age
    for (n in 1:sample) {
        if(x.single.tree == FALSE & y.single.tree == FALSE) {
            z[[n]]= add.root.edge(x[[randX[n]]], root.age ) + add.root.edge(y[[randY[n]]], root.age )
            #z[[n]]<-bind.tree( add.root.edge(x[[randX[n]]], root.age ), add.root.edge(y[[randX[n]]], root.age ) ,where="root", position=root.age-max(node.depth.edgelength(y[[randX[n]]])) )
        } 

        if(x.single.tree == TRUE & y.single.tree == TRUE) {
            z[[n]]= add.root.edge(x, root.age ) + add.root.edge(y, root.age )
            #z[[n]]<-bind.tree( add.root.edge(x, root.age ), add.root.edge(y, root.age ) ,where="root", position=root.age-max(node.depth.edgelength(x)) )
        } 

        if(x.single.tree == TRUE & y.single.tree == FALSE) {
            z[[n]]= add.root.edge(x, root.age ) + add.root.edge(y[[randY[n]]], root.age )
            #z[[n]]<-bind.tree( add.root.edge(x, root.age ), add.root.edge(y[[randY[n]]], root.age ) ,where="root", position=root.age-max(node.depth.edgelength(y[[randX[n]]])) )
        } 

        if(x.single.tree == FALSE & y.single.tree == TRUE) {
            z[[n]]= add.root.edge(x[[randX[n]]], root.age ) + add.root.edge(y, root.age )
            #z[[n]]<-bind.tree( add.root.edge(x[[randX[n]]], root.age ), add.root.edge(y, root.age), where="root", position=root.age-max(node.depth.edgelength(y)) )
        } 

    }

    if(length(z) != 1) {
        return(z)
    } else {
        Z<-z[[1]]
        return(Z)
    }

}



    tree<-fun.rand.bind(x, y, x.single.tree, y.single.tree, sample, replace.x, replace.y, root.age)

#OUTPUT

    return(tree)

#End
}