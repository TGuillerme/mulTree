# Whether to sample with replace or not in tree.bind
get.replace <- function(tree, sample, verbose=FALSE) {
    # Get call
    match_call<-match.call()
    # If only one sample is need do not replace
    if (sample == 1) {
        replace <- FALSE
    } else {
        # If class is phylo (one tree) do replace
        if(class(tree) == "phylo") {
            replace <- TRUE
        } else {
            # If multiPhylo has only one element do replace
            if(length(tree) == 1) {
                replace <- TRUE
            } else {
                # If sample is bigger than the number of trees do replace
                if(length(tree) < sample) {
                    replace <- TRUE
                } else {
                    # Else do no replace
                    replace <- FALSE
                }
            }
        }
    }
    # Verbose
    if(verbose == TRUE && replace == TRUE) {
        warning("The sample is a higher than the number of trees in ", match_call$tree, ".\n", match_call$tree, " will be re-sampled.", call.=FALSE)
    }

    return(replace)
}

# Creates the list of trees to sample (with or without replacement)
sample.trees <- function(tree, sample, replace) {
    rand <- sample(1:length(tree), sample, replace = replace)
    return(rand)
}


# Adds an edge length to the phylogeny
add.root.edge <- function(tree, root.age) {
    tree$root.edge <- root.age - max(node.depth.edgelength(tree))
    # Make sure root edge can not be negative!
    if(tree$root.edge < 0) {
        tree$root.edge <- 0
    }
    return(tree)
}

# Lapply loop for binding trees
lapply.bind.tree <- function(element, x, y, rand_x, rand_y, root.age) {
    return(add.root.edge(x[[rand_x[element]]], root.age) + add.root.edge(y[[rand_y[element]]], root.age))
}