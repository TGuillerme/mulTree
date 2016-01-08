#' @title Combines a data table and a "multiPhylo" object into a list to be used by the mulTree function
#'
#' @description Combines a table and a multiple phylogenies using \code{\link[caper]{comparative.data}} function. Changes the name of the taxa column into "sp.col" to be read by \code{\link[caper]{comparative.data}} and \code{\link[MCMCglmm]{MCMCglmm}}.
#'
#' @param data A \code{data.frame} or \code{matrix} containing at least two variable and taxa names.
#' @param tree A \code{phylo} or \code{multiPhylo} object.
# If phylo transform to muyltiPhylo
#' @param taxa The name or the number of the column containing the list of taxa in the \code{data}.
#' @param rand.terms A \code{\link[stats]{formula}} ontaining additional random terms to add to the default formula (phylogenetic effect). If missing, the random terms are the column containing the taxa names and a column containing the specimen names if more than one taxa per specimen is present.
#' @param clean.data A \code{logical} value: whether to use the \code{\link{clean.data}} function. Default = \code{FALSE}.
#'
#' @return
#' A \code{mulTree} object the data to be passed to the \code{\link{mulTree}} function.
#'
#' @details
#' If \code{rand.terms} is specified by the user, the first element is forced to be called "animal".
#' 
#' @examples
#' ##Creates a data.frame
#' data_table <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5), var2 = c(rep("a",2), rep("b",3)))
#' ##Creates a list of tree
#' tree_list <- rmtree(5,5, tip.label = LETTERS[1:5])
#' ##Creates the "mulTree" object
#' as.mulTree(data_table, tree_list, taxa = "taxa")
#' 
#' ##Creating a mulTree object with multiple specimens
#' ##Creates a data.frame with taxa being labelled as "spec1"
#' data_table_sp1 <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5), var2 = c(rep("a",2), rep("b",3)), specimen = c(rep("spec1", 5)))
#' ##Creates a data.frame with taxa being labelled as "spec2"
#' data_table_sp2 <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5), var2 = c(rep("a",2), rep("b",3)), specimen = c(rep("spec2", 5)))
#' ##Combines both data.frames
#' data_table <- rbind(data_table_sp1, data_table_sp2)
#' ##Creates a list of tree
#' tree_list <- rmtree(5,5, tip.label = LETTERS[1:5])
#' ##Creates the "mulTree" object (with a random term formula)
#' as.mulTree(data_table, tree_list, taxa = "taxa", rand.terms = ~taxa+specimen)
#' 
#' @author Thomas Guillerme
#' @export

as.mulTree <- function(data, tree, taxa, rand.terms, clean.data=FALSE) {

    #Get the match call
    match_call <- match.call()

    #SANITIZING
    #data
    #converting into a data.frame (if matrix)
    if (class(data) == "matrix") {
        data <- as.data.frame(data)
    }
    check.class(data, "data.frame")
    #testing the length of the dataset
    if(length(data) < 3) {
        stop(paste(as.expression(match_call$data," must contain one taxa name column and at least two variables.", sep=""), call.=FALSE))
    }

    #tree
    #convert to multiPhylo if is phylo
    if(class(tree) == "phylo") {
        tree <- list(tree)
        class(tree) <- "multiPhylo"
    }
    #must be multiPhylo
    check.class(tree, "multiPhylo", " must be of class phylo or multiPhylo.")

    #taxa
    if (class(taxa) == "numeric") {
        taxa.column.num = TRUE
    } else {
        if (class(taxa) == "character") {
            taxa.column.num = FALSE
        } else {
            stop(paste(as.expression(match_call$taxa)," not found in ", as.expression(match_call$data), sep = ""), call. = FALSE)
        }
    }

    #is provided column present in data?
    if(taxa.column.num == TRUE) {
        if(taxa > length(data)) {
            stop(paste("taxa column not found in ", as.expression(match_call$data), sep = ""), call. = FALSE)
        } else {
            taxa = names(data)[taxa]
        }
    } else {
        taxa.names <- grep(taxa, names(data))
        if(length(taxa.names) == 0) {
            stop(paste(as.expression(match_call$taxa)," not found in ", as.expression(match_call$data), ".", sep = ""), call. = FALSE)
        }
    }

    #rand.terms
    if(missing(rand.terms)) {
        set_rand_terms <- "auto"
    } else {
        #Checking random terms class
        check.class(rand.terms, "formula")
        #Checking if the element of rand.terms are present in the table
        terms_list <- labels(terms(rand.terms))
        #Checking if the terms are column names
        terms_list_match <- match(terms_list, colnames(data))
        if(any(is.na(terms_list_match))) {
            no_match <- terms_list[which(is.na(terms_list_match))]
            for (i in 1:length(no_match)) {
                stop("In rand.terms, \"",no_match[i], "\" is not matching with any column name in the provided data.")    
            }
        }
        #check if at least of the terms is the phylogeny (i.e. animal)
        if(!is.na(match(taxa, terms_list))) {
            set_rand_terms <- "manual"
        } else {
            stop("The provided random terms should at least contain the taxa column (phylogeny).")
        }
    }

    #clean.data
    check.class(clean.data, "logical")

    #BUILDING THE "mulTree" OBJECT LIST

    #cleaning the data (optional)
    if(clean.data == TRUE) {
        data_cleaned <- clean.data(taxa, data, tree)
        tree_new <- data_cleaned$tree
        data_new <- data_cleaned$data
        if(all(is.na(c(data_cleaned$dropped_tips, data_cleaned$dropped_rows)))) {
            cat("Taxa in the tree and the table are all matching!")
        } else {
            cat("The following taxa were dropped from the analysis:\n", c(data_cleaned$dropped_tips, data_cleaned$dropped_rows))
        }
    } else {
        tree_new <- tree
        data_new <- data
    }

    #renaming the taxa column in the data.frame
    #(this is because of the weird way comparative.data() deals with it's arguments (names.col <- as.character(substitute(names.col))), taxa as to be replaced by just "sp.col" instead of the more cleaner way: (taxa, list(taxa = taxa))) as in names.col <- as.character(substitute(taxa, list(taxa = taxa))).)
    names(data_new) <- sub(taxa,"sp.col",names(data_new))

    #Running the comparative tests
    test_comp_data <- comparative.data.test(specimen.transform(data_new), tree_new)

    #Stop the testing if results is FALSE
    if(test_comp_data == FALSE) {
        stop("Impossible to use the comparative.data function on the data and the tree(s). Possible reasons:\n-Check if the taxa argument corresponds to column in data containing the taxa names.\n-Check if the data matches the tree(s) using the clean.data function.")
    }

    #Setting the random terms
    if(set_rand_terms == "auto") {
        #adding the "animal" column for MCMCglmm() random phylogenetic effect
        data_new["animal"] <- NA
        data_new$animal <- data_new$sp.col
        rand.terms <- ~animal
    } else {
        #Check which term corresponds to the phylogeny (i.e. animal)
        phylo_term <- terms_list[which(terms_list == taxa)]
        data_new[phylo_term] <- NA
        data_new[phylo_term] <- data_new[,which(names(data_new) == "sp.col")]

        #Modify the formula and the column name to correspond to animal (phylogeny) for MCMCglmm (unless the phylo term is already called animal)
        #
        # THIS PART OF THE CODE IS A BIT CLUMSY! MIGHT WANT TO MODIFY THAT IN THE FUTURE
        #
        if(phylo_term != "animal") {
            names(data_new)[which(names(data_new) == phylo_term)] <- "animal"
            if(length(terms_list) == 1) {
                rand.terms[[2]] <- substitute(animal)
            }
            if(length(terms_list) == 2) {
                rand.terms[[2]][[2]] <- substitute(animal)
            }
            if(length(terms_list) == 3) {
                rand.terms[[2]][[2]][[2]] <- substitute(animal)
            }
            if(length(terms_list) == 4) {
                rand.terms[[2]][[2]][[2]][[2]] <- substitute(animal)
            }
            if(length(terms_list) == 5) {
                rand.terms[[2]][[2]][[2]][[2]][[2]] <- substitute(animal)
            }
            if(length(terms_list) == 6) {
                rand.terms[[2]][[2]][[2]][[2]][[2]][[2]] <- substitute(animal)
            }
            if(length(terms_list) == 7) {
                rand.terms[[2]][[2]][[2]][[2]][[2]][[2]][[2]] <- substitute(animal)
            }
            if(length(terms_list) == 8) {
                rand.terms[[2]][[2]][[2]][[2]][[2]][[2]][[2]][[2]] <- substitute(animal)
            }
            if(length(terms_list) == 9) {
                rand.terms[[2]][[2]][[2]][[2]][[2]][[2]][[2]][[2]][[2]] <- substitute(animal)
            }
            message("The random terms formula has been updated to \"", rand.terms,"\".\nThe column \"", taxa, "\" has been duplicated into a new column called \"animal\".") 
        }
    }

    #Creating the mulTree object
    taxa_column <- paste("renamed column ", taxa, " into 'sp.col'", sep = "")
    output <- list(phy = tree_new, data = data_new, random.terms = rand.terms, taxa.column = taxa_column)
    #Assign class
    class(output)<-"mulTree"

    return(output)
}
