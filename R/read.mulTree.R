#' @title Reads MCMCglmm models fromn mulTree.
#'
#' @description Reads MCMCglmm objects from the \code{\link{mulTree}} function back into the \code{R} environment.
#'
#' @param mulTree.chain A chain name of \code{MCMCglmm} models written by the \code{\link{mulTree}} function.
#' @param convergence Logical, whether to read the convergence file associated with the chain name (default = \code{FALSE}).
#' @param model Logical, whether to input a single \code{MCMCglmm} model or the list of random and fixed terms only (default = \code{FALSE}).
#' @param extract Optional, the name of one or more elements to extract from each model (rather than loading the full model; default = \code{NULL}).
#'
#' @return
#' A \code{list} of the terms of class \code{mulTree} by default.
#' Else a \code{MCMCglmm} object (if \code{model = TRUE}); a \code{gelman.diag} object (if \code{convergence = TRUE}) or a list of extracted elements from the \code{MCMCglmm} models (if \code{extract} is not \code{NULL}).
#'
#' @details
#' The argument \code{model = TRUE} can be used to load the \code{MCMCglmm} object of a unique chain.
#' The resulting object can be then summarized or plotted as S3 method for class \code{MCMCglmm}.
#' 
#' @examples
#' ## Creating some dummy mulTree models
#' data <- data.frame("sp.col" = LETTERS[1:5], var1 = rnorm(5), var2 = rnorm(5))
#' tree <- replicate(3, rcoal(5, tip.label = LETTERS[1:5]), simplify = FALSE)
#' class(tree) <- "multiPhylo"
#' mulTree.data <- as.mulTree(data, tree, taxa = "sp.col")
#' priors <- list(R = list(V = 1/2, nu = 0.002),
#'      G = list(G1 = list(V = 1/2, nu = 0.002)))
#' mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(10000, 10, 1000),
#'      chains = 2, prior = priors, output = "quick_example", convergence = 1.1,
#'      ESS = 100, verbose = FALSE)
#'
#' ## Reading all the models
#' all_chains <- read.mulTree("quick_example")
#'
#' ## Reading the convergence diagnosis for all the trees
#' read.mulTree("quick_example", convergence = TRUE)
#'
#' ## Reading a specific model
#' model <- read.mulTree("quick_example-tree1_chain1", model = TRUE)
#'
#' ## Reading only the error term and the tune for all models
#' read.mulTree("quick_example", extract=c("error.term", "Tune"))
#'
#' ##Remove the generated files from the current directory
#' file.remove(list.files(pattern = "quick_example"))
#' 
#' @seealso \code{\link{mulTree}}, \code{\link{plot.mulTree}}, \code{\link{summary.mulTree}}
#' @author Thomas Guillerme
#' @export

read.mulTree <- function(mulTree.chain, convergence = FALSE, model = FALSE, extract = NULL) { 
    ## HEADER
    match_call<-match.call()

    ## SANITIZING
    ## mulTree.chain
    check.class(mulTree.chain, "character")
    ## check if chain is present
    scanned_chains <- list.files(pattern = mulTree.chain)
##     check.length(scanned_chains, 0, " files not found in current directory.", errorif = TRUE)
    if(length(scanned_chains) == 1) {
        if(length(grep("chain[0-9].rda", scanned_chains)) == 0) {
            stop("File \"", mulTree.chain, "\" is not a mulTree chain but a single file.", sep="",call.=FALSE)
        }
    } else {
        if(length(grep("chain[0-9].rda", scanned_chains)) == 0) {
            stop("File \"", mulTree.chain, "\" not found in current directory.", sep="",call.=FALSE)
        }
    }


    ## convergence
    check.class(convergence, 'logical')
    if(convergence == TRUE & length(scanned_chains) == 1) {
        stop("The convergence file can't be loaded because \"", mulTree.chain, "\" is a single model.\n", sep="")
    }

    ## model
    check.class(model, 'logical')
    if(length(scanned_chains) > 1 & model == TRUE) {
        stop("The MCMCglmm model can't be loaded because \"", mulTree.chain, "\" is a chain name.\nPlease specify the single model's name.", sep="")
    }

    ## extract
    if(!is.null(extract)) {
        check.class(extract, 'character')
    }

    ## READING THE MCMC MODEL BACK IN R ENVIRONMENT
    ## Extracting some specific elements from all the chains
    if(!is.null(extract)) {
        ##  Extract the testing model
        test_model <- get.mulTree.model(paste(mulTree.chain, "-tree1_", "chain1.rda", sep=""))
        ## checking if the required element exists
        if(any(is.na(match(extract, names(test_model))))) {
            stop(paste(as.expression(match_call$extract), " element does not exist in any model.", sep=""))
        } else {
            ##  Proceed to extraction
            if(length(extract) == 1) {
                ## Remove only one element
                output <- get.element(extract, mulTree.chain)
            } else {
                ## Remove the number of elements
                output <- lapply(as.list(extract), get.element, mulTree.chain)
                names(output) <- extract
            }
        }
        ## Stop the function here
        return(output)
    }

    ## Extracting a single model
    if(model == TRUE) {
        ## get the model
        output <- get.mulTree.model(scanned_chains)
        ## Stop the function here
        return(output)

    } else {
        ## Reading the convergence files
        if(convergence == TRUE) {
            ## Selecting the convergence scanned_chains
            conv_file <- scanned_chains[grep("_conv.rda", scanned_chains)]
            if(length(conv_file) == 1) {
                ## Reading a single convergence file
                output <- get.convergence(conv_file)
            } else {
                ## Reading multiple convergence scanned_chains
                output <- lapply(conv_file, get.convergence)
                names(output) <- strsplit(conv_file, split=".rda")
            }
            ## Stop the function here
            return(output)

        ## Reading the chains
        } else {
            ## Selecting the chains
            mcmc_file <- scanned_chains[grep("_chain", scanned_chains)]
            if(length(mcmc_file) == 1) {
                ## Reading a single chain
                output <- get.mulTree.model(mcmc_file)
                out_table <- get.table.mulTree(output)
            } else {
                ## Reading multiple chains
                output <- lapply(mcmc_file, get.mulTree.model)
                out_table <- lapply(output, get.table.mulTree)
                ## Combine the elements of each chain
                out_table_tmp <- as.list(as.data.frame(mapply(c, out_table[[1]], out_table[[2]])))
                if(length(out_table) > 2) {
                    for (chain in 3:length(mcmc_file)) {
                        out_table_tmp <- as.list(as.data.frame(mapply(c, out_table_tmp, out_table[[chain]])))
                    }
                }
                out_table <- out_table_tmp
            }
            ## Set output of class mulTree
            class(out_table) <- "mulTree"
            return(out_table)
        }
    }
}