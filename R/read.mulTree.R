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
# What does it return?
#'
#' @details
#' The argument \code{model = TRUE} can be used to load the \code{MCMCglmm} object of a unique chain.
#' The resulting object can be then summarized or plotted as S3 method for class \code{MCMCglmm}.
#' 
#' @examples
#' \dontrun{
#' ## Quick example:
#' ## Before the analysis
#' data <- data.frame("sp.col" = LETTERS[1:5], var1 = rnorm(5), var2 = rnorm(5))
#' tree <- replicate(3, rcoal(5, tip.label = LETTERS[1:5]), simplify = FALSE) ; class(tree) <- "multiPhylo"
#' mulTree.data <- as.mulTree(data, tree, taxa = "sp.col")
#' priors <- list(R = list(V = 1/2, nu = 0.002), G = list(G1 = list(V = 1/2, nu = 0.002)))
#' ## quick example
#' mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(10000, 10, 1000), chains = 2, prior = priors, output = "quick_example", convergence = 1.1, ESS = 100)
#' 
#' ##Reading only one model
#' model <- read.mulTree("dummy_ex_tree1_chain1", model=TRUE)
#' plot(model)
#' 
#' ##Reading the convergence diagnosis for tree 1
#' read.mulTree("dummy_ex_tree1", convergence=TRUE)
#' 
#' ##Reading all the models
#' all_chains<-read.mulTree("dummy_ex")
#' summary(all_chains)
#' 
#' ##Reading the error term and the Tune of each model
#' read.mulTree("dummy_ex", extract=c("error.term", "Tune"))
#' 
#' ##Remove the generated files from the current directory
#' file.remove(list.files(pattern="dummy_ex"))
#' }
#' 
#' @seealso \code{\link{mulTree}}, \code{\link{plot.mulTree}}, \code{\link{summary.mulTree}}
#' @author Thomas Guillerme
#' @export

read.mulTree <- function(mulTree.chain, convergence = FALSE, model = FALSE, extract = NULL) { 
    #HEADER
    match_call<-match.call()

    #SANITIZING
    #mulTree.chain
    check.class(mulTree.chain, "character")
    #check if chain is present
    scanned_chains <- list.files(pattern = mulTree.chain)
    check.length(scanned_chains, 0, " files not found in current directory.", errorif = TRUE)
    if(length(scanned_chains) == 1) {
        if(length(grep("chain[0-9].rda", scanned_chains)) == 0) {
            stop("File \"", mulTree.chain, "\" not found in current directory.", sep="",call.=FALSE)
        }
    } else {
        if(length(grep("chain[0-9].rda", scanned_chains)) == 0) {
            stop("File \"", mulTree.chain, "\" not found in current directory.", sep="",call.=FALSE)
        }
    }


    #convergence
    check.class(convergence, 'logical')
    if(convergence == TRUE & length(scanned_chains) == 1) {
        stop("The convergence file can't be loaded because \"", mulTree.chain, "\" is a single model.\n", sep="")
    }

    #model
    check.class(model, 'logical')
    if(length(scanned_chains) > 1 & model == TRUE) {
        stop("The MCMCglmm model can't be loaded because \"", mulTree.chain, "\" is a chain name.\nPlease specify the single model's name.", sep="")
    }

    #extract
    if(!is.null(extract)) {
        check.class(extract, 'character')
    }

    #Extracting some specific elements from all the chains
    if(!is.null(extract)) {
        # Extract the testing model
        test_model <- get.mulTree.model(paste(mulTree.chain, "-tree1_", "chain1.rda", sep=""))
        #checking if the required element exists
        if(any(is.na(match(extract, names(test_model))))) {
            stop(paste(as.expression(match_call$extract), " element does not exist in any model.", sep=""))
        } else {
            # Proceed to extraction
            if(length(extract) == 1) {
                #Remove only one element
                output <- get.element(extract, mulTree.chain)
            } else {
                #Remove the number of elements
                output <- lapply(as.list(extract), get.element, mulTree.chain)
                names(output) <- extract
            }
        }
        #Stop the function here
        return(output)
    }

    #Extracting a single model
    if(model == TRUE) {
        #get the model
        output <- get.mulTree.model(scanned_chains)
        #Stop the function here
        return(output)

    } else {
        #Reading the convergence files
        if(convergence == TRUE) {
            #Selecting the convergence scanned_chains
            conv_file <- scanned_chains[grep("_conv.rda", scanned_chains)]
            if(length(conv_file) == 1) {
                #Reading a single convergence file
                output <- get.convergence(conv_file)
            } else {
                #Reading multiple convergence scanned_chains
                output <- lapply(conv_file, get.convergence)
                names(output) <- strsplit(conv_file, split=".rda")
            }
            #Stop the function here
            return(output)

        #Reading the chains
        } else {
            #Selecting the chains
            mcmc_file <- scanned_chains[grep("_chain", scanned_chains)]
            if(length(mcmc_file) == 1) {
                #Reading a single chain
                output <- get.mulTree.model(mcmc_file)
            } else {
                #Reading multiple chains
                output <- lapply(mcmc_file, get.mulTree.model)
                names(output) <- strsplit(mcmc_file, split=".rda")
            }

            #Transform the output into a table
            
        }
        


        return(output)
    }

#OUTPUT

    #If model == TRUE, return the MCMCglmm model
    if(model == TRUE) {

        return(mcmc.model)

    } else {

        #If convergence == FALSE transforms the file using table.mulTree function
        if(convergence == FALSE) {
            output<-table.mulTree(output)
            #make output in format 'mulTree' (list)
            class(output)<-'mulTree'
        }

        return(output)

    }

#End
}