#' @title Combines a data table and a "multiPhylo" object into a list to be used by the mulTree function
#'
#' @description Combines a data table and a multiple phylogenies. Changes the name of the taxa column into "sp.col" to be read by \code{\link[MCMCglmm]{MCMCglmm}}.
#'
#' @param data A \code{data.frame} or \code{matrix} containing at least two variable and taxa names.
#' @param tree A \code{phylo} or \code{multiPhylo} object.
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
#' data_table <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5),
#'      var2 = c(rep("a",2), rep("b",3)))
#' ##Creates a list of tree
#' tree_list <- rmtree(5,5, tip.label = LETTERS[1:5])
#' ##Creates the "mulTree" object
#' as.mulTree(data_table, tree_list, taxa = "taxa")
#' 
#' ##Creating a mulTree object with multiple specimens
#' ##Creates a data.frame with taxa being labelled as "spec1"
#' data_table_sp1 <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5),
#'      var2 = c(rep("a",2), rep("b",3)), specimen = c(rep("spec1", 5)))
#' ##Creates a data.frame with taxa being labelled as "spec2"
#' data_table_sp2 <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5),
#'      var2 = c(rep("a",2), rep("b",3)), specimen = c(rep("spec2", 5)))
#' ##Combines both data.frames
#' data_table <- rbind(data_table_sp1, data_table_sp2)
#' ##Creates a list of tree
#' tree_list <- rmtree(5,5, tip.label = LETTERS[1:5])
#' ##Creates the "mulTree" object (with a random term formula)
#' as.mulTree(data_table, tree_list, taxa = "taxa", rand.terms = ~taxa+specimen)
#' 
#' @seealso \code{\link{mulTree}}
#' @author Thomas Guillerme
#' @export

as.mulTree <- function(data, tree, taxa, rand.terms, clean.data = FALSE) {

    ## Get the match call
    match_call <- match.call()

    ## SANITIZING
    ## data
    ## converting into a data.frame (if matrix)
    if (is(data, "matrix")) {
        data <- as.data.frame(data)
    }
    check.class(data, "data.frame")
    ## testing the length of the dataset
    if(length(data) < 3) {
        stop("data must contain one taxa name column and at least two variables.")
    }

    ## tree
    ## convert to multiPhylo if is phylo
    if(is(tree, "phylo")) {
        tree <- list(tree)
        class(tree) <- "multiPhylo"
    }
    ## must be multiPhylo
    check.class(tree, "multiPhylo", " must be of class phylo or multiPhylo.")

    ## taxa
    if (is(taxa, "numeric")) {
        taxa.column.num = TRUE
    } else {
        if (is(taxa,  "character")) {
            taxa.column.num = FALSE
        } else {
            stop(paste(as.expression(match_call$taxa)," not found in ", as.expression(match_call$data), sep = ""), call. = FALSE)
        }
    }

    ## is provided column present in data?
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

    ## rand.terms
    if(missing(rand.terms)) {
        set_rand_terms <- TRUE
    } else {
        ## Checking random terms class
        check.class(rand.terms, "formula")
        ## Checking if the element of rand.terms are present in the table
        terms_list <- labels(stats::terms(rand.terms))
        ## Checking if the terms are column names
        terms_list_match <- match(terms_list, colnames(data))
        
        if(any(is.na(terms_list_match))) {

            ## Check if the non-matching terms are correlation terms
            no_match <- terms_list[is.na(terms_list_match)]
            is_cor <- grep("us\\(", no_match)

            if(length(is_cor) != length(no_match)) {
                ## At leas one wrong term anyway!
                stop("The following random terms do not match with any column name provided in data:\n    ", paste(as.character(no_match), sep = ", "), ".", sep = "")
            } else {
                cor_term_tmp <- strsplit(no_match, split = ":")[[1]]
                is_us <- grep("us\\(", cor_term_tmp)
                cor_term <- c(strsplit(strsplit(cor_term_tmp[is_us], split = "\\(")[[1]][2], "\\)")[[1]][1], cor_term_tmp[-is_us])
                cor_terms_list_match <- match(cor_term, colnames(data))

                if(any(is.na(cor_terms_list_match))) {
                    if(!any(cor_term[is.na(cor_terms_list_match)] %in% c("units", "trait"))) {
                        stop("The following random terms do not match with any column name provided in data:\n    ", paste(cor_term[is.na(cor_terms_list_match)], sep = ", "), ".", sep = "")
                    }
                }
            }
        }

        ## check if at least of the terms is the phylogeny (i.e. animal)
        if(length(grep(taxa, terms_list)) > 0 || length(grep("animal", terms_list)) > 0) {
            set_rand_terms <- FALSE
        } else {
            stop("The provided random terms should at least contain the taxa column (phylogeny).")
        }
    }

    ## clean.data
    check.class(clean.data, "logical")

    ## BUILDING THE "mulTree" OBJECT LIST

    ## cleaning the data (optional)
    if(clean.data == TRUE) {
        data_cleaned <- mulTree::clean.data(data, tree, data.col = taxa)
        tree_new <- data_cleaned$tree
        data_new <- data_cleaned$data
        if(all(is.na(c(data_cleaned$dropped_tips, data_cleaned$dropped_rows)))) {
            cat("Taxa in the tree and the table are all matching!\n")
        } else {
            cat("The following taxa were dropped from the analysis:\n", c(data_cleaned$dropped_tips, data_cleaned$dropped_rows), "\n")
        }
    } else {
        tree_new <- tree
        data_new <- data
    }

    ## renaming the taxa column in the data.frame
    ## (this is because of the weird way comparative.data() deals with it's arguments (names.col <- as.character(substitute(names.col))), taxa as to be replaced by just "sp.col" instead of the more cleaner way: (taxa, list(taxa = taxa))) as in names.col <- as.character(substitute(taxa, list(taxa = taxa))).)
    names(data_new) <- sub(taxa, "sp.col", names(data_new))

    ## Setting the random terms
    if(set_rand_terms) {
        ## adding the "animal" column for MCMCglmm() random phylogenetic effect
        data_new["animal"] <- NA
        data_new$animal <- data_new$sp.col
        rand.terms <- substitute(~animal)
    } else {
        ## Check which term corresponds to the phylogeny (i.e. animal)
        phylo_term <- terms_list[which(terms_list == taxa)]
        ## Composite phylo_term
        if(length(phylo_term) == 0) {
            if(length(grep(taxa, terms_list)) > 0) {
                phylo_term <- which(colnames(data_new) == "sp.col")
            } else {
                phylo_term <- which(colnames(data_new) == "animal")
            }
        }

        data_new[phylo_term] <- NA
        data_new[phylo_term] <- data_new[,which(names(data_new) == "sp.col")]

        ## Modify the formula and the column name to correspond to animal (phylogeny) for MCMCglmm (unless the phylo term is already called animal)
        #TG: THIS PART OF THE CODE IS A BIT CLUMSY! MIGHT WANT TO MODIFY THAT IN THE FUTURE


        if(phylo_term != "animal") {
                if(length(grep("animal", rand.terms)) == 0) {
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
    }

    ## Creating the mulTree object
    taxa_column <- paste("renamed column ", taxa, " into 'sp.col'", sep = "")
    output <- list(phy = tree_new, data = data_new, random.terms = rand.terms, taxa.column = taxa_column)
    ## Assign class
    class(output) <- "mulTree"

    return(output)
}
