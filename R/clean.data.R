#' @title Cleaning phylogenetic data
#'
#' @description Cleans a table/tree to match with a given table/tree
#'
#' @param taxa A \code{vector} of taxa to keep or a \code{numerical} or \code{character} value refering to the column in \code{data} containing the taxa list.
#' @param data A \code{data.frame} or \code{matrix}.
#' @param tree A \code{phylo} or \code{multiPhylo} object.
#'
#' @return
#' A \code{list} containing the cleaned data and tree(s) and information on the eventual dropped tips and rows.
#'
#' @examples
#' ##Create a set of different trees
#' trees_list <- list(rtree(5, tip.label = LETTERS[1:5]), rtree(4, tip.label = LETTERS[1:4]), rtree(6, tip.label = LETTERS[1:6])) ; class(trees_list) <- "multiPhylo"
#' ##Creates a data frame
#' dummy_data <- data.frame(taxa_list = LETTERS[1:5], var1 = rnorm(5), var2 = c(rep('a',2), rep('b',3)))
#'
#' ##Cleaning the trees and the data
#' cleaned <- clean.data(taxa = "taxa_list", data = dummy_data, tree = trees_list)
#' ##The taxa that where dropped (tips and rows):
#' c(cleaned$dropped_tips, cleaned$dropped_rows)
#' ##The cleaned trees:
#' cleaned$tree
#' ##The cleaned data set:
#' cleaned$data
#' 
#' @author Thomas Guillerme & Kevin Healy
#' @export


clean.data<-function(taxa, data, tree) {

    #SANITIZING
    #taxa
    # must be a single numeric element
    if (class(taxa) == 'numeric') {
        #taxa is a column number
        check.length(taxa, 1, " must be a single numerical value referring to the column containing the taxa names in data.")
        taxa_column <- TRUE
        taxa_number <- TRUE

    } else {
        check.class(taxa, 'character', " must be a character value referring to the column containing the taxa names in data or a vector of taxa names.")
        if(length(taxa) == 1) {
            #taxa is a column name
            taxa_column <- TRUE
            taxa_number <- FALSE

        } else {

            taxa_column <- FALSE
        }
    }

    #data
    data_class <- check.class(data, c('data.frame', 'matrix'), " must be a data.frame or matrix object.")   

    #tree
    tree_class <- check.class(tree, c('phylo', 'multiPhylo'), " must be a phylo or multiPhylo object.")   

    #is provided column present in data?
    if(taxa_column == TRUE) {
        if(taxa_number == TRUE) {
            #Is it a valid number?
                if(taxa > length(data)) {
                stop("Taxon column not found in data.")
            } else {
                taxa_col <- taxa
                taxa <- unique(as.vector(unlist(as.list(data[taxa]))))
            }                
        } else {
            #Is it a valid name?
            taxa_col <- grep(taxa, names(data))
            taxa <- unique(as.vector(unlist(as.list(data[taxa_col]))))
            check.class(taxa, 'character', " not found in data.")
        }
    }

    #CLEANING THE DATA/TREES
    #for a single tree
    if(tree_class == "phylo") {
        
        cleaned_data <- clean.tree.table(tree, data, taxa, taxa_col)

    } else {
        #for multiple trees
        #lapply function
        cleaned_list <- lapply(tree, clean.tree.table, data = data, taxa = taxa, taxa_col = taxa_col)

        #Selecting the tips to drop
        tips_to_drop <- unique(unlist(lapply(cleaned_list, function(x) x[[3]])))
        #removing NAs
        tips_to_drop <- tips_to_drop[-which(is.na(tips_to_drop))]

        #Selecting the rows to drop
        rows_to_drop <- unique(unlist(lapply(cleaned_list, function(x) x[[4]])))
        #removing NAs
        rows_to_drop <- rows_to_drop[-which(is.na(rows_to_drop))]

        #Combining both
        taxa_to_drop <- c(tips_to_drop, rows_to_drop)

        #Dropping the tips across all trees
        if(length(taxa_to_drop) != 0) {
            tree_new <- lapply(tree, drop.tip, taxa_to_drop) ; class(tree_new) <- 'multiPhylo'
        } else {
            #removing taxa from the trees
            #keep the same trees
            tree_new <- tree
            if(length(tips_to_drop) == 0) tips_to_drop <- NA
        }

        #Dropping the rows
        if(length(rows_to_drop) != 0) {
            #removing taxa from the data
            data_new <- data[-match(rows_to_drop, data[,taxa_col]),]
        } else {
            #keep the same data
            data_new <- data
            if(length(rows_to_drop) == 0) rows_to_drop <- NA
        }

        #output list
        cleaned_data <- list("tree" = tree_new, "data" = data_new, "dropped_tips" = tips_to_drop,  "dropped_rows" = rows_to_drop)
    }

    return(cleaned_data)

#End
}
