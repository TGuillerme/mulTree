##########################
#Randomly binds trees together
##########################
#Randomly binds trees together with a provided number of trees and a root age.
#v1.3
#Update: removed verbose option (useless)
#Update: fixed randY
#Update: added example
#Update: isolated function externally
##########################
#SYNTAX :
#<x,y> two phylo or multiPhylo objects
#<sample> the number of trees to create
#<root.age> the age of the root where both trees are combined (can be any unit)
#----
#guillert(at)tcd.ie - 10/08/2014
##########################
#Requirements:
#-R 3
#-R package "ape"
##########################

rTreeBind<-function(x, y, sample, root.age) {

#SANITIZING
    #trees
    x.class<-check.class(x, c('multiPhylo', 'phylo'), " must be a \"phylo\" or \"multiPhylo\" object.")
    y.class<-check.class(y, c('multiPhylo', 'phylo'), " must be a \"phylo\" or \"multiPhylo\" object.")
    x.single.tree <- ifelse((class(x) == 'phylo'), TRUE, FALSE)
    y.single.tree <- ifelse((class(x) == 'phylo'), TRUE, FALSE)

    #sample
    check.class(sample, 'numeric', " must be numeric.")
    #checking if sample is > or < than the number of trees provided
    replace.x<-get.replace(x, sample)
    if(replace.x == TRUE) {
        warning(as.character(substitute(sample)), " is a higher than the number of trees in \"x\": \"x\" will be re-sampled.", call.=FALSE)
    }
    replace.y<-get.replace(y, sample)
    if(replace.y == TRUE) {
        warning(as.character(substitute(sample)), " is a higher than the number of trees in \"y\": \"y\" will be re-sampled.", call.=FALSE)
    }

    #root age
    check.class(root.age, 'numeric', " must be numeric.")

#RANDOMLY BINDING THE TREES

    tree<-fun.rand.bind(x, y, x.single.tree, y.single.tree, sample, replace.x, replace.y, root.age)

#OUTPUT

    return(tree)

#End
}
