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
#'
#' @return
#' Generates MCMCglmm models and saves them sequentially out of \code{R} environement to minimise users RAM usage. 
#' Use \code{\link{read.mulTree}} to reload the models back in the \code{R} environement. 
#' Because of the calculation of the vcv matrix for each model and each tree in the MCMCglmm models, this function is really RAM demanding. 
#' For big datasets we heavily recomend to have at least 4GB RAM DDR3 available.
#' 
#' @examples
#' ## Quick example:
#' ## Before the analysis
#' data <- data.frame("sp.col" = LETTERS[1:5], var1 = rnorm(5), var2 = rnorm(5))
#' tree <- replicate(3, rcoal(5, tip.label = LETTERS[1:5]), simplify = FALSE) ; class(tree) <- "multiPhylo"
#' mulTree.data <- as.mulTree(data, tree, taxa = "sp.col")
#' priors <- list(R = list(V = 1/2, nu = 0.002), G = list(G1 = list(V = 1/2, nu = 0.002)))
#' ## quick example
#' mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(10000, 10, 1000), chains = 2, prior = priors, output = "quick_example", convergence = 1.1, ESS = 100)
#' ## Clean folder
#' file.remove(list.files(pattern = "quick_example"))
#' ## alternative example with parallel argument (and double the number of chains!)
#' mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(10000, 10, 1000), chains = 4, prior = priors, output = "quick_example", convergence = 1.1, ESS = 100, parallel = "SOCK")
#' ## Clean folder
#' file.remove(list.files(pattern = "quick_example"))
#'
#' \dontrun{
#' ## Before the analysis:
#' ## read in the data
#' data(lifespan)
#' ## combine aves and mammalia trees
#' combined_trees <- tree.bind(x = trees_mammalia, y = trees_aves, sample = 2, root.age = 250)
#' 
#' ## Preparing the variables for the mulTree function
#' ## creates the "mulTree" object
#' mulTree_data <- as.mulTree(data = lifespan_volant, tree = combined_trees, taxa = "species")
#' ## formula
#' test_formula <- longevity ~ mass + volant
#' ## parameters (number of generations, thin/sampling, burnin)
#' mcmc_parameters <- c(101000, 10, 1000) # For higher ESS run longer by increasing the number of generations
#' ## priors
#' mcmc_priors <- list(R = list(V = 1/2, nu = 0.002), G = list(G1 = list(V = 1/2, nu = 0.002)))
#' 
#' ## Running MCMCglmm on multiple trees
#' ## WARNING: This example takes between 1 and 2 minutes two run and generates files in your current directory.
#' mulTree(mulTree_data, formula=test_formula, parameters=mcmc_parameters, priors=mcmc_priors, output="longevity.example", ESS = 50)
#' 
#' ## The models are saved out of R environment under the "longevity.example" chains names.
#' ## Use read.mulTree() to read the generated models.
#' 
#' ## Remove the generated files from the current directory
#' file.remove(list.files(pattern="longevity.example"))
#' 
#' ## Parallel example
#' ## Loading the snow package
#' library(snow)
#' ## Running the same MCMCglmm on multiple trees
#' mulTree(mulTree_data, formula=test_formula, parameters=mcmc_parameters, priors=mcmc_priors, output="longevity.example", ESS = 50, parallel="SOCK")
#' ## Remove the generated files from the current directory
#' file.remove(list.files(pattern="longevity.example"))
#'  
#' ## Same example but including specimens
#' ## Subset of the data
#' data<-lifespan_volant[sample(nrow(lifespan_volant), 30),]
#' ##Create a dataset with two specimen per species
#' data<-rbind(cbind(data, specimen=rep("spec1",30)),cbind(data, specimen=rep("spec2",30)))
#' ##Cleaning the trees
#' trees<-clean.data(taxon="species", data, combined_trees)$tree
#' 
#' ##Creates the mulTree object
#' mulTree_data<-as.mulTree(data, trees, species="species", rand.terms=~species+specimen)
#' 
#' ##Running MCMCglmm on multiple trees
#' mulTree(mulTree_data, formula=test_formula, parameters=mcmc_parameters, priors=mcmc_priors, output="longevity.example", ESS = 50)
#' ##Remove the generated files from the current directory
#' file.remove(list.files(pattern="longevity.example"))
#'}
#' 
#' @seealso \code{\link[MCMCglmm]{MCMCglmm}}, \code{\link{as.mulTree}}, \code{\link{read.mulTree}}
#' @author Thomas Guillerme
#' @export



mulTree <- function(mulTree.data, formula, parameters, chains=2, priors, ..., convergence=1.1, ESS=1000, verbose=TRUE, output="mulTree_models", warn=FALSE, parallel) {  

    #HEADER
    #libraries
    if(!missing(parallel)) {
        requireNamespace("snow")
    }
    #timer(start)
    start.time <- Sys.time()

    #Set working environment
    mulTree_env <- new.env()

    #SANITIZING
    #mulTree.data
    #must be mulTree
    check.class(mulTree.data, "mulTree")
    #moving the random terms to current environment
    environment(mulTree.data$random.terms)<-environment()
    
    #formula
    check.class(formula, 'formula')

    #chains
    check.class(chains, 'numeric')
    check.length(chains, 1, " must be a single value.")
    if(chains == 1) {
        message("Only one chain has been called: the convergence test can't be performed.")
    }

    #parameters
    check.class(parameters, 'numeric')
    check.length(parameters, 3, " must be a vector of three elements: (1) the number of generations, (2) the sampling and (3) the burnin.")

    #priors
    if(!missing(priors)) {
        check.class(priors, 'list')
    }

    #convergence
    check.class(convergence, 'numeric')
    check.length(convergence, 1, " must be a single value.")

    #ESS
    check.class(ESS, 'numeric')
    check.length(ESS, 1, " must be a single value.")

    #verbose
    check.class(verbose, 'logical')

    #output
    check.class(output, 'character')
    check.length(output, 1, " must be a single chain of characters.")
    #Check if the output chain name is already present in the current directory
    if(length(grep(output, list.files())) > 0) {
        read.key(paste("Output chain name \"", output, "\" already exists!\nPress [enter] if you wish to overwrite the models or [esc] to cancel.", sep = ""), "Models will be overwritten...")
    }

    #warn
    check.class(warn, 'logical', " must be logical.")

    #parallel
    if(!missing(parallel)) {
        check.class(parallel, "character")
    }

    #RUNNING THE MODELS
    for (ntree in 1:length(mulTree.data$phy)) {
        #For each tree...

        if(missing(parallel)) {
#        testing_nopar <- TRUE
#        if(testing_nopar == TRUE) {
#            warning("DEBUG MODE")
            #SEQUENTIALLY RUNNING THE CHAINS
            for(nchain in 1:chains) { # Weirdly enough, the loop is slightly more efficient in this non-parallel case!
                #...Run each chain one by one
                model_tmp <- lapply.MCMCglmm(ntree, mulTree.data, formula, priors, parameters, ..., warn)
                #model_tmp <- lapply.MCMCglmm(ntree, mulTree.data, formula, priors, parameters, warn) ; warning("DEBUG MODE")
                assign(paste("model_tree", ntree, "_chain", nchain, sep = ""), model_tmp)

                #Saving the model out of R environment
                model <- get(paste("model_tree", ntree, "_chain", nchain, sep = ""))
                name <- paste(output, "-tree", ntree, "_chain", nchain, ".rda", sep = "")
                save(model, file = name)
            }
        } else {
            #PARALLEL CHAINS RUN
            #Set cluster up
            cluster <- makeCluster(chains, parallel)
            model_tmp <- clusterCall(cluster, lapply.MCMCglmm, ntree, mulTree.data, formula, priors, parameters, ..., warn)
            #model_tmp <- clusterCall(cluster, lapply.MCMCglmm, ntree, mulTree.data=mulTree.data, formula=formula, priors=priors, parameters=parameters, warn=warn) ; warning("DEBUG MODE")
            stopCluster(cluster)
            #Assigning the models
            for (nchain in 1:chains) {
                assign(paste("model_tree", ntree, "_chain", nchain, sep = ""), model_tmp[[nchain]])
            }
            #Saving models
            for (nchain in 1:chains) {
                model <- get(paste("model_tree", ntree, "_chain", nchain, sep = ""))
                name <- paste(output, "-tree", ntree, "_chain", nchain, ".rda", sep = "")
                save(model, file = name)
            }
        }

        #RUNNING THE CONVERGENCE DIAGNOSIS (if more than one chain)
        if(chains > 1) {
            #Running the convergence test
            converge.test <- convergence.test(lapply(as.list(seq(1:chains)), function(X) get(paste("model_tree", ntree, "_chain", X, sep = ""))))
            #Saving the convergence test
            save(converge.test, file = paste(output, "-tree", ntree, "_conv", ".rda", sep = ""))
        }

        #BE VERBOSE
        if(verbose == TRUE) {
            cat("\n", format(Sys.Date()), " - ", format(Sys.time(), "%H:%M:%S"), ":", " MCMCglmm performed on tree ", ntree, "\n", sep = "")
            if(chains > 1) {
                cat("Convergence diagnosis:\n")
                cat("Effective sample size is > ", ESS, ": ", all(effectiveSize(model$Sol[]) > ESS), "\n", sep = "")
                cat(unlist(lapply(lapply(as.list(seq(1:chains)), function(X) get(paste("model_tree", ntree, "_chain", X, sep = ""))), ESS.lapply)), sep="; ")
                cat("\nAll levels converged < ", convergence, ": ", all(converge.test$psrf[,1] < convergence), "\n", sep = "")
                cat(converge.test$psrf[,1], sep="; ") ; cat("\n")
                cat("Individual models saved as: ", output, "-tree", ntree, "_chain*.rda\n", sep = "")
                cat("Convergence diagnosis saved as: ", output, "-tree", ntree, "_conv.rda", "\n", sep = "")
            } else {
                cat("Model saved as: ", output, "-tree", ntree, "_chain1.rda\n", sep = "")
            }
        }
    } 


#OUTPUT

    #timer (end)
    end.time <- Sys.time()
    execution.time <- difftime(end.time,start.time, units = "secs")

    #verbose
    if(verbose==TRUE) {
        cat("\n",format(Sys.Date())," - ",format(Sys.time(), "%H:%M:%S"), ":", " MCMCglmm successfully performed on ", length(mulTree.data$phy), " trees.\n",sep = "")
        if (execution.time[[1]] < 60) {
            cat("Total execution time: ", execution.time[[1]], " secs.\n", sep = "")
        } else {
            if (execution.time[[1]] > 60 & execution.time[[1]] < 3600) {
                cat("Total execution time: ", execution.time[[1]]/60, " mins.\n", sep = "") 
            } else {
                if (execution.time[[1]] > 3600 & execution.time[[1]] < 86400) {
                   cat("Total execution time: ", execution.time[[1]]/3600, " hours.\n", sep = "")
                } else {
                    if (execution.time[[1]] > 86400) {
                        cat("Total execution time: ", execution.time[[1]]/86400, " days.\n", sep = "")
                    }
                }
            }
        }
        cat("Use read.mulTree() to read the data as 'mulTree' data.\nUse summary.mulTree() and plot.mulTree() for plotting or summarizing the 'mulTree' data.\n", sep = "")
    }

#End
}
