#' @title Randomly binding trees together
#'
#' @description Randomly binds trees together with a provided number of trees and a root age.
#'
#' @param x,y Two \code{phylo} or \code{multiPhylo} objects.
#' @param sample The number of trees to create. If missing, the \code{sample} size is set to 1.
#' @param root.age The age of the root where both trees are combined (can be any unit). If missing, the \code{root.edge} is set to \code{0}.
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
#' @export

tree.bind<-function(x, y, sample, root.age) {
    #SANITIZING
    #trees
    # getting the class of each tree object (and checking their class)
    x_class <- check.class(x, c("multiPhylo", "phylo"))
    y_class <- check.class(y, c("multiPhylo", "phylo"))

    # transforming the trees into multiPhylo objects
    if(x_class == "phylo") x <- list(x) ; class(x) <- "multiPhylo"
    if(y_class == "phylo") y <- list(y) ; class(y) <- "multiPhylo"

    #sample
    if(missing(sample)) {
        sample <- 1
    } else {
        check.class(sample, "numeric")
    }

    #root age
    if(missing(root.age)) {
        root.age <- 0
    } else {
        check.class(root.age, "numeric")
    }

    #RANDOMLY BINDING THE TREES
    # Sample draws (using get.replace to set replace or not with verbose warning)
    rand_x <- sample.trees(x, sample, get.replace(x, sample, TRUE))
    rand_y <- sample.trees(y, sample, get.replace(y, sample, TRUE))
    sample_list <- as.list(seq(1:sample)) # number of samples to draw

    # Bind the trees
    binded_trees <- lapply(sample_list, lapply.bind.tree, x, y, rand_x, rand_y, root.age)

    #OUTPUT

    # Check if the trees can be converted into phylo/multiPhylo
    if(all(unlist(lapply(binded_trees, Ntip)) == unlist(lapply(binded_trees, function(x) length(unique(x$tip.label)))))) {
        # output a tree if length = 1
        if(length(binded_trees) == 1) {
            binded_trees <- binded_trees[[1]] ; class(binded_trees) <- "phylo"
        } else {
            # output is a multiPhylo
            class(binded_trees) <- "multiPhylo"
        }
        return(binded_trees)
    } else {
        # Some trees have duplicated names
        warning("Some trees have duplicated tip labels.\nThe output can not be converted into phylo or multiPhylo objects.")
        return(binded_trees)
    }

}