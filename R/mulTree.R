#' @title Run MCMCglmm on multiple trees
#'
#' @description Running a \code{\link[MCMCglmm]{MCMCglmm}} model on a multiple phylogenies and a \code{data.frame} combined using \code{\link{as.mulTree}}. The results are written out of \code{R} environment as individual models.
#'
#' @param mulTree.data A list of class \code{mulTree} generated using \code{\link{as.mulTree}}.
#' @param formula An object of class \code{formula} (excluding the random terms).
#' @param parameters A list of three numerical values to be used respectively as: (1) the number of generations, (2) the sampling value, (3) the burnin.
#' @param chains The number of independent chains to run per model.
#' @param priors A series of priors to use for the MCMC. If missing, the priors will be the default parameters from the \code{\link[MCMCglmm]{MCMCglmm}} function.
#' @param ... Any additional arguments to be passed to the \code{\link[MCMCglmm]{MCMCglmm}} function.
#' @param convergence A numerical value for assessing chains convergence (default = \code{1.1}).
#' @param ESS A numerical value for assessing the effective sample size (default = \code{1000}).
#' @param verbose A logical value stating whether to be verbose or not (default = \code{TRUE}).
#' @param output A string of characters that will be used as chain name for the models output (default = \code{mulTree_models}).
#' @param warn Whether to print the warning messages from the \code{\link[MCMCglmm]{MCMCglmm}} function (default = \code{FALSE}).
#' @param parallel An optional vector containing the virtual connection process type for running the chains in parallel (requires \code{snow} package).
#' @param ask \code{logical}, whether to ask to overwrite models (\code{TRUE} - default) or not (\code{FALSE})).
#'
#' @return
#' Generates MCMCglmm models and saves them sequentially out of \code{R} environment to minimise users RAM usage. 
#' Use \code{\link{read.mulTree}} to reload the models back in the \code{R} environment. 
#' Because of the calculation of the vcv matrix for each model and each tree in the MCMCglmm models, this function is really RAM demanding. 
#' For big datasets we heavily recommend to have at least 4GB RAM DDR3 available.
#' 
#' @examples
#' ## Quick example:
#' ## Before the analysis
#' data <- data.frame("sp.col" = LETTERS[1:5], var1 = rnorm(5), var2 = rnorm(5))
#' tree <- replicate(3, rcoal(5, tip.label = LETTERS[1:5]), simplify = FALSE)
#' class(tree) <- "multiPhylo"
#' mulTree.data <- as.mulTree(data, tree, taxa = "sp.col")
#' priors <- list(R = list(V = 1/2, nu = 0.002),
#'      G = list(G1 = list(V = 1/2, nu = 0.002)))
#' ## quick example
#' mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(10000, 10, 1000),
#'      chains = 2, prior = priors, output = "quick_example", convergence = 1.1,
#'      ESS = 100)
#' ## Clean folder
#' file.remove(list.files(pattern = "quick_example"))
#' ## alternative example with parallel argument (and double the chains!)
#' mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(10000, 10, 1000),
#'      chains = 4, prior = priors, output = "quick_example", convergence = 1.1,
#'      ESS = 100, parallel = "SOCK")
#' ## Clean folder
#' file.remove(list.files(pattern = "quick_example"))
#'
#' \dontrun{
#' ## Before the analysis:
#' ## read in the data
#' data(lifespan)
#' ## combine aves and mammalia trees
#' combined_trees <- tree.bind(x = trees_mammalia, y = trees_aves, sample = 2,
#'      root.age = 250)
#' 
#' ## Preparing the variables for the mulTree function
#' ## creates the "mulTree" object
#' mulTree_data <- as.mulTree(data = lifespan_volant, tree = combined_trees,
#'      taxa = "species")
#' ## formula
#' test_formula <- longevity ~ mass + volant
#' ## parameters (number of generations, thin/sampling, burnin)
#' mcmc_parameters <- c(101000, 10, 1000)
#' # For higher ESS run longer by increasing the number of generations
#' ## priors
#' mcmc_priors <- list(R = list(V = 1/2, nu = 0.002),
#'      G = list(G1 = list(V = 1/2, nu = 0.002)))
#' 
#' ## Running MCMCglmm on multiple trees
#' ## WARNING: This example takes between 1 and 2 minutes to run
#' ## and generates files in your current directory.
#' mulTree(mulTree_data, formula = test_formula, parameters = mcmc_parameters,
#'      priors = mcmc_priors, output = "longevity.example", ESS = 50)
#' 
#' ## The models are saved out of R environment under the "longevity.example"
#' ## chains names.
#' ## Use read.mulTree() to read the generated models.
#' 
#' ## Remove the generated files from the current directory
#' file.remove(list.files(pattern = "longevity.example"))
#' 
#' ## Parallel example
#' ## Loading the snow package
#' library(snow)
#' ## Running the same MCMCglmm on multiple trees
#' mulTree(mulTree_data, formula = test_formula, parameters = mcmc_parameters,
#'      priors = mcmc_priors, output = "longevity.example", ESS = 50,
#'      parallel = "SOCK")
#' ## Remove the generated files from the current directory
#' file.remove(list.files(pattern = "longevity.example"))
#'  
#' ## Same example but including specimens
#' ## Subset of the data
#' data <- lifespan_volant[sample(nrow(lifespan_volant), 30),]
#' ##Create a dataset with two specimen per species
#' data <- rbind(cbind(data, specimen = rep("spec1", 30)), cbind(data,
#'      specimen = rep("spec2", 30)))
#' ##Cleaning the trees
#' trees <- clean.data(data, combined_trees, data.col = "species")$tree
#' 
#' ##Creates the mulTree object
#' mulTree_data <- as.mulTree(data, trees, taxa = "species",
#'      rand.terms = ~species+specimen)
#' 
#' ## Updating the priors
#' mcmc_priors <- list(R = list(V = 1/2, nu = 0.002),
#'                     G = list(G1 = list(V = 1/2, nu = 0.002),
#'                     G2 = list(V = 1/2, nu = 0.002)))
#' 
#' ##Running MCMCglmm on multiple trees
#' mulTree(mulTree_data, formula = test_formula, parameters = mcmc_parameters,
#'      priors = mcmc_priors, output = "longevity.example", ESS = 50)
#' ##Remove the generated files from the current directory
#' file.remove(list.files(pattern = "longevity.example"))
#'}
#' 
#' @seealso \code{\link[MCMCglmm]{MCMCglmm}}, \code{\link{as.mulTree}}, \code{\link{read.mulTree}}
#' @author Thomas Guillerme
#' @export

#DEBUG
# source("sanitizing.R")
# source("mulTree_fun.R")
# source("read.mulTree_fun.R")
# data <- data.frame("sp.col" = LETTERS[1:5], var1 = rnorm(5), var2 = rnorm(5))
# tree <- replicate(3, rcoal(5, tip.label = LETTERS[1:5]), simplify = FALSE)
# class(tree) <- "multiPhylo"
# mulTree.data <- as.mulTree(data, tree, taxa = "sp.col")
# priors <- list(R = list(V = 1/2, nu = 0.002), G = list(G1 = list(V = 1/2, nu = 0.002)))
# formula = var1 ~ var2
# parameters = c(10000, 10, 1000)
# chains = 2
# prior = priors
# output = "quick_example"
# convergence = 1.1
# ESS = 100
# verbose = TRUE
# warn = FALSE

mulTree <- function(mulTree.data, formula, parameters, chains = 2, priors, ..., convergence = 1.1, ESS = 1000, verbose = TRUE, output = "mulTree_models", warn = FALSE, parallel, ask = TRUE) {  

    ## HEADER
    ## libraries
    if(!missing(parallel)) {
        requireNamespace("snow")
    }
    ## timer(start)
    start.time <- Sys.time()

    ## Set working environment
    mulTree_env <- new.env()

    ## SANITIZING
    check.class(mulTree.data, "mulTree")

    ## formula
    check.class(formula, 'formula')
    ## Check the terms
    formula_terms <- as.character(attr(stats::terms(formula), "variables"))[-1]
    ## Remove potential trait/units
    if(length(grep("trait:", formula)) > 0) {
        formula_terms <- formula_terms[-which(formula_terms == "trait")]
    }
    if(length(grep("units:", formula)) > 0) {
        formula_terms <- formula_terms[-which(formula_terms == "units")]
    }

    check_formula <- match(formula_terms, colnames(mulTree.data$data))

    if(any(is.na(check_formula))) {
        ## Check if the NA is from a multi-random
        na_formula_terms <- formula_terms[which(is.na(check_formula))]
        
        if(grep("\\(", na_formula_terms) > 0) {
            ## Function for clean term splitting
            split.term <- function(one_na) {
                return(unlist(strsplit(gsub(" ", "", gsub("\\)", "", strsplit(one_na, split = "\\(")[[1]][2])), split = ",")))
            }
            ## Splitting the terms (e.g. from a cbind)
            split_terms <- unique(unlist(lapply(as.list(na_formula_terms), split.term)))
            ## Matching the terms to the column names
            matching <- split_terms %in% colnames(mulTree.data$data)

            if(any(!matching)) {
                stop(paste(paste(formula_terms[which(!matching)], collapse = ", "), "terms in the formula do not match dataset column names."))
            }
        } else {
            stop(paste(paste(formula_terms[which(is.na(check_formula))], collapse = ", "), "terms in the formula do not match dataset column names."))
        }
    }

    ## chains
    check.class(chains, 'numeric')
    check.length(chains, 1, " must be a single value.")
    if(chains == 1) {
        message("Only one chain has been called: the convergence test can't be performed.")
    }

    ## parameters
    check.class(parameters, 'numeric')
    check.length(parameters, 3, " must be a vector of three elements: (1) the number of generations, (2) the sampling and (3) the burnin.")

    ## priors
    if(!missing(priors)) {
        check.class(priors, 'list')
    }

    ## convergence
    check.class(convergence, 'numeric')
    check.length(convergence, 1, " must be a single value.")

    ## ESS
    check.class(ESS, 'numeric')
    check.length(ESS, 1, " must be a single value.")

    ## verbose
    check.class(verbose, 'logical')

    ## output
    check.class(output, 'character')
    check.length(output, 1, " must be a single chain of characters.")
    ## Check if the output chain name is already present in the current directory
    if(ask && length(grep(output, list.files())) > 0) {
        read.key(paste("Output chain name \"", output, "\" already exists!\nPress [enter] if you wish to overwrite the models or [esc] to cancel.", sep = ""), "Models will be overwritten...")
    }

    ## warn
    check.class(warn, 'logical', " must be logical.")

    ## parallel
    if(!missing(parallel)) {
        check.class(parallel, "character")
        ## Set up the cluster
        cluster_ID <- snow::makeCluster(chains, parallel)
        do_parallel <- TRUE
    } else {
        do_parallel <- FALSE
    }

    ## Getting the optional arguments
    dots <- list(...)
    optional_args <- ifelse(length(dots) == 0, FALSE, TRUE)

    ## RUNNING THE MODELS
    for (ntree in 1:length(mulTree.data$phy)) {
        ## Setting up mulTree arguments
        mulTree_arguments <-  list("warn" = warn, "fixed" = formula, "random" = mulTree.data$random.terms, "pedigree" = mulTree.data$phy[[ntree]], "prior" = priors, "data" = mulTree.data$data, "verbose" = FALSE, "nitt" = parameters[1], "thin" = parameters[2], "burnin" = parameters[3])

        ## Run the models
        if(!do_parallel) {
            for(nchain in 1:chains) {

                ## Run the model
                if(optional_args){
                    model <- lapply.MCMCglmm(c(mulTree_arguments, dots))
                } else {
                    model <- lapply.MCMCglmm(mulTree_arguments)
                }

                ## Saving the model out of R environment
                save(model, file = get.model.name(nchain, ntree, output))

                ## reset the model's content (for safety) 
                model <- NULL
            }

        } else {
            ## Run the models
            if(optional_args){
                model_tmp <- snow::clusterCall(cluster_ID, lapply.MCMCglmm, c(mulTree_arguments, dots))
            } else {
                model_tmp <- snow::clusterCall(cluster_ID, lapply.MCMCglmm, mulTree_arguments)
            }

            # if (!exists('pr')) {
            #     model_tmp <- snow::clusterCall(cluster_ID, lapply.MCMCglmm, ntree, mulTree.data=mulTree.data, formula=formula, priors=priors, parameters=parameters, ..., warn=warn)
            # } else {
            #     model_tmp <- snow::clusterCall(cluster_ID, lapply.MCMCglmm, ntree, mulTree.data=mulTree.data, formula=formula, priors=priors, parameters=parameters, ..., warn=warn, pr=pr)
            # }

            # model_tmp <- snow::clusterCall(cluster_ID, lapply.MCMCglmm, ntree, mulTree.data, formula, priors, parameters, ..., warn)
            #model_tmp <- snow::clusterCall(cluster_ID, lapply.MCMCglmm, ntree, mulTree.data=mulTree.data, formula=formula, priors=priors, parameters=parameters, warn=warn) ; warning("DEBUG MODE")
                        
            ## Saving the models
            for (nchain in 1:chains) {
                ## Save on model for one chain
                model <- model_tmp[[nchain]]
                save(model, file = get.model.name(nchain, ntree, output))
                ## Reset the model's content (for safety) 
                model <- NULL
            }

            ## Reset the models for both chains (safety)
            model_tmp <- NULL
        }

        ## RUNNING THE CONVERGENCE DIAGNOSIS (if more than one chain)
        if(chains > 1) {
            ## Get the models
            models <- lapply(as.list(seq(1:chains)), extract.chains, ntree, output)
            ## Run the convergence test
            converge.test <- convergence.test(models)
            if(!is.null(converge.test)) {
                ## Saving the convergence test
                save(converge.test, file = paste(output, "-tree", ntree, "_conv", ".rda", sep = ""))
            }
            ## Calculate the ESS
            ESS_results <- lapply(models, ESS.lapply)
            names(ESS_results) <- paste("C", 1:chains, sep = "")
            ESS_results <- unlist(ESS_results)
            ## reset the models content (for safety) 
            models <- NULL
        }

        ## BE VERBOSE
        if(verbose == TRUE) {
            cat("\n", format(Sys.Date()), " - ", format(Sys.time(), "%H:%M:%S"), ":", " MCMCglmm performed on tree ", ntree, "\n", sep = "")
            if(chains > 1) {
                cat("Convergence diagnosis:\n")
                if(all(ESS_results > ESS)) {
                    cat("Effective sample size is > ", ESS, ": TRUE\n", sep = "")
                    cat(ESS_results, sep="; ") ; cat("\n")
                } else {
                    cat("Effective sample size is > ", ESS, ": FALSE\n", sep = "")
                    cat(ESS_results, sep="; ") ; cat("\n")
                    cat(paste(names(which(ESS_results < ESS)), collapse =", "), " < ", ESS, "\n", sep = "")
                }
                if(!is.null(converge.test)) {
                    cat("All levels converged < ", convergence, ": ", all(converge.test$psrf[,c(1:2)] < convergence), "\n", sep = "")
                    cat(converge.test$psrf[,c(1:2)], sep="; ") ; cat("\n")
                }
                cat("Individual models saved as: ", output, "-tree", ntree, "_chain*.rda\n", sep = "")
                cat("Convergence diagnosis saved as: ", output, "-tree", ntree, "_conv.rda", "\n", sep = "")
            } else {
                cat("Model saved as: ", output, "-tree", ntree, "_chain1.rda\n", sep = "")
            }
        }
    } 

    if(!missing(parallel)) {
        ## Stop the cluster
        snow::stopCluster(cluster_ID)
    }

    ## OUTPUT

    ## timer (end)
    end.time <- Sys.time()
    execution.time <- difftime(end.time, start.time, units = "secs")

    ## verbose
    if(verbose==TRUE) {
        cat("\n",format(Sys.Date())," - ",format(Sys.time(), "%H:%M:%S"), ":", " MCMCglmm successfully performed on ", length(mulTree.data$phy), " trees.\n",sep = "")
        get.timer(execution.time)
        cat("Use read.mulTree() to read the data as 'mulTree' data.\nUse summary.mulTree() and plot.mulTree() for plotting or summarizing the 'mulTree' data.\n", sep = "")
    }
    
    return(invisible())
}
