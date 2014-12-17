##########################
#Cleans a table/tree to match with a given table/tree
##########################
#v0.1
##########################
#SYNTAX :
#<table> any table ("data.frame" or "matrix" object) containing at least two variable and species names
#<tree> a "multiPhylo" object
#----
#guillert(at)tcd.ie - 17/12/2014
##########################
#Requirements:
#-R 3
#-R package "ape"
#-R package "caper"
##########################


#Debug
trees<-list(trees[[1]], trees[[2]], rtree(6, tip.label=LETTERS[1:6]), rtree(4, tip.label=LETTERS[2:5]))
class(trees)<-"multiPhylo"


    #Cleaning the tree/table (optional)
clean=FALSE
    if(clean==TRUE) {
        #Selecting which data.set (unique or not)
        if(is.unique==TRUE) {
            data_cleaning<-data
        } else {
            data_cleaning<-sub.data
        }
        #Creating the table_cleaning pattern
        table_cleaning<-data_cleaning
        row.names(table_cleaning)<-data_cleaning$sp.col
        #Checking the length of the table
        table_names<-sort(row.names(table_cleaning))
        #Checking the length of each tree
        select.tip.labels<-function(tree) {return(sort(tree$tip.label))}
        trees_names<-lapply(trees, select.tip.labels)
        #drop table rows if any row is not matching with the trees
        match.tip.labels<-function(tree_names) {return(match(x=table_names, table=tree_names))}
        matching_names<-lapply(trees_names, match.tip.labels)

    }


#Cleaning a tree so that the species match with the ones in a table
clean.tree<-function(tree, table, verbose=FALSE) {
    missing.species<-comparative.data(tree, data.frame("species"=row.names(table), "dummy"=rnorm(nrow(table)), "dumb"=rnorm(nrow(table))), "species")$dropped
    if(length(missing.species$tips) != 0) {
        tree.tmp<-drop.tip(tree, missing.species$tips)
        if (verbose==TRUE) {
            cat("Dropped tips:\n")
            cat(missing.species$tips, sep=", ")
        }
        tree<-tree.tmp
    }

    return(tree)
}

#Cleaning a table so that the species match with the ones in the tree
clean.table<-function(table, tree, verbose=FALSE) {
    missing.species<-comparative.data(tree, data.frame("species"=row.names(table), "dummy"=rnorm(nrow(table)), "dumb"=rnorm(nrow(table))), "species")$dropped
    if(length(missing.species$unmatched.rows) != 0) {
        table.tmp<-table[-c(match(missing.species$unmatched.rows, rownames(table))),]
        if (verbose==TRUE) {
            cat("Dropped rows:\n")
            cat(missing.species$unmatched.rows, sep=", ")
        }
        table<-table.tmp
    }
    return(table)
}