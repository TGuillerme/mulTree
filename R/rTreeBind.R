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

#HEADER 
    require(ape)

#DATA INPUT
    #trees
    if(class(x) == 'multiPhylo') {
        x.single.tree<-FALSE
    } else {
        if(class(x) == 'phylo') {
            x.single.tree<-TRUE
        } else {
            stop("\"x\" must be a \"phylo\" or \"multiPhylo\" object.", call.=FALSE)
        }
    }

    if(class(y) == 'multiPhylo') {
        y.single.tree<-FALSE
    } else {
        if(class(y) == 'phylo') {
            y.single.tree<-TRUE
        } else {
            stop("\"y\" must be a \"phylo\" or \"multiPhylo\" object.", call.=FALSE)
        }
    }

    #sample
    CHECK.class(sample, 'numeric', " must be numeric.")
    #checking if sample is > or < than the number of trees provided
    if (sample == 1) {
        replace.x=FALSE
    } else {
        if(x.single.tree == TRUE) {
            warning("\"sample\" is a higher than the number of trees in \"x\": \"x\" will be re-sampled.", call.=FALSE)
            replace.x=TRUE               
        } else {
            if (sample > length(x)) {
                warning("\"sample\" is a higher than the number of trees in \"x\": \"x\" will be re-sampled.", call.=FALSE)
                replace.x=TRUE
            } else {
                replace.x=FALSE
            }
        }
    }

    if (sample == 1) {
        replace.y=FALSE
    } else {
        if(y.single.tree == TRUE) {
            warning("\"sample\" is a higher than the number of trees in \"y\": \"y\" will be re-sampled.", call.=FALSE)
            replace.y=TRUE               
        } else {
            if (sample > length(y)) {
                warning("\"sample\" is a higher than the number of trees in \"y\": \"y\" will be re-sampled.", call.=FALSE)
                replace.y=TRUE
            } else {
                replace.y=FALSE
            }
        }
    }

    #root age
    CHECK.class(root.age, 'numeric', " must be numeric.")

#FUNCTION

    FUN.sample.trees<-function(tree, sample, replace) {
        #Creates the list of trees to sample (with or without replacement)
        rand<-sample(1:length(tree), sample, replace=replace)
        return(rand)
    }

    FUN.root.edge<-function(phy, root.age) {
        #Adds an edge length to the phylogeny
        phy$root.edge<-root.age-max(node.depth.edgelength(phy))
        return(phy)
    }

    FUN.rand.bind<-function(x, y, x.single.tree, y.single.tree, sample, replace.x, replace.y, root.age){
        #Creating a empty multiPhylo object
        z<-rmtree(sample,2)

        #Sample list
        randX<-FUN.sample.trees(x, sample, replace.x)
        randY<-FUN.sample.trees(y, sample, replace.y)

        #Binding the trees together by adding the root.age
        for (n in 1:sample) {
            if(x.single.tree == FALSE & y.single.tree == FALSE) {
                z[[n]]= FUN.root.edge(x[[randX[n]]], root.age ) + FUN.root.edge(y[[randY[n]]], root.age )
                #z[[n]]<-bind.tree( FUN.root.edge(x[[randX[n]]], root.age ), FUN.root.edge(y[[randX[n]]], root.age ) ,where="root", position=root.age-max(node.depth.edgelength(y[[randX[n]]])) )
            } 

            if(x.single.tree == TRUE & y.single.tree == TRUE) {
                z[[n]]= FUN.root.edge(x, root.age ) + FUN.root.edge(y, root.age )
                #z[[n]]<-bind.tree( FUN.root.edge(x, root.age ), FUN.root.edge(y, root.age ) ,where="root", position=root.age-max(node.depth.edgelength(x)) )
            } 

            if(x.single.tree == TRUE & y.single.tree == FALSE) {
                z[[n]]= FUN.root.edge(x, root.age ) + FUN.root.edge(y[[randY[n]]], root.age )
                #z[[n]]<-bind.tree( FUN.root.edge(x, root.age ), FUN.root.edge(y[[randY[n]]], root.age ) ,where="root", position=root.age-max(node.depth.edgelength(y[[randX[n]]])) )
            } 

            if(x.single.tree == FALSE & y.single.tree == TRUE) {
                z[[n]]= FUN.root.edge(x[[randX[n]]], root.age ) + FUN.root.edge(y, root.age )
                #z[[n]]<-bind.tree( FUN.root.edge(x[[randX[n]]], root.age ), FUN.root.edge(y, root.age), where="root", position=root.age-max(node.depth.edgelength(y)) )
            } 

        }

        if(length(z) != 1) {
            return(z)
        } else {
            Z<-z[[1]]
            return(Z)
        }

    }

#RANDOMLY BINDING THE TREES

    tree<-FUN.rand.bind(x, y, x.single.tree, y.single.tree, sample, replace.x, replace.y, root.age)

#OUTPUT

    return(tree)

#End
}
