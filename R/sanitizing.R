#SANITYZING FUNCTIONS


#Checking the class of an object and returning an error message if != class
check.class<-function(object, class, msg, errorif=FALSE) {
    #Set msg if missing
    if(missing(msg)) {
        msg<-paste(" must be of class: ", class, ".", sep="")
    }

    match_call<-match.call()

    #check if object is class.
    if(length(class) == 1) {
        if(errorif==FALSE) {
            if(class(object) != class) {
                stop(match_call$object, msg , call.=FALSE)
            }
        } else {
            if(class(object) == class) {
                stop(match_call$object, msg , call.=FALSE)
            }        
        }
    } else {
    #check if object is class in a cascade (class[1] else class[2] else class[3], etc..)
    #returns error only if object is not of any class
        for (i in 1:length(class)) {
            if(class(object) == class[i]) {
                class.test<-class[i]
            }        
        }
        if(exists(as.character(quote(class.test)))) {
            return(class.test)
        } else {
            stop(match_call$object, msg , call.=FALSE)
        }
    }
}


#Checking the class of an object and returning an error message if != class
check.length<-function(object, length, msg, errorif=FALSE) {

    match_call<-match.call()

    if(errorif==FALSE) {
        if(length(object) != length) {
            stop(match_call$object, msg , call.=FALSE)
        }
    } else {
        if(length(object) == length) {
            stop(match_call$object, msg , call.=FALSE)
        }        
    }
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
