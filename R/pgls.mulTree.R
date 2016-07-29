#' @title Run pgls on multiple trees
#'
#' @description Running a \code{\link[coda]{pgls}} model on a multiple phylogenies and a \code{data.frame} combined using \code{\link{as.mulTree}}. The results are written out of \code{R} environment as individual models.
#'
#' @param mulTree.data A list of class \code{mulTree} generated using \code{\link{as.mulTree}}.
#' @param formula An object of class \code{formula} (excluding the random terms).
#' @param parameters A list of three numerical values to be used respectively as: (1) \code{lambda}, (2) \code{kappa}, (3) \code{delta} (see \code{\link[coda]{pgls}} and details). If missing, the parameters are set to \code{list(1,1,1)}.
#' @param ... Any optional arguments to be passed to \code{\link[coda]{pgls}}.
#' @param verbose A logical value stating whether to be verbose or not (default = \code{TRUE}).
#' @param output A string of characters that will be used as chain name for the models output (default = \code{mulTree_models}). If missing or \code{FALSE}, no output will be created.
#' @param parallel An optional list containing the virtual connection process type for running the chains in parallel (requires \code{snow} package) and the number of cores to use.
#' 
#' @details
#' The \code{parameters} argument can be a single element (of class \code{numeric} or \code{'ML'}) for specifying the \code{lambda} only (\code{kappa} and \code{delta} will be set to \code{1}).
#' The \code{output} option allows to free the RAM after each model iteration and is highly recommended for big models!
#'
#' @return
#' Generates \code{pgls} models. 
#' 
#' @examples
#' 
#' @seealso \code{\link[coda]{pgls}}, \code{\link{as.mulTree}}, \code{\link{read.mulTree}},  \code{\link{MCMCglmm.mulTree}}
#' @author Thomas Guillerme
#' @export

pgls.mulTree <- function(mulTree.data, formula, parameters, ..., verbose = TRUE, output, parallel) {  

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
    
    #formula
    check.class(formula, 'formula')

    #parameters
    if(missing(parameters)) {
       parameters <- list("lambda" = 1.0, "kappa" = 1.0, "delta" = 1.0) 
    } else {
        class_parameters <- class(parameters)
        if(class_parameters != list) {
            #Only lambda is given
            if(class_parameters !=  "numeric" || parameters != "ML") {
                # Lambda can only be numeric or "ML"
                stop("Parameters must be a list of lambda, kappa and delta value or a single value for lambda or \"ML\".")
            }
            #Set the other parameters as default
            parameters <- list("lambda" = parameters, "kappa" = 1.0, "delta" = 1.0) 
        } else {
            #Check length
            check.length(parameters, 3, errorif=FALSE, " must be a list of lambda, kappa and delta value or a single value for lambda or \"ML\".")
            #Check lambda
            if(class(parameters[[1]]) !=  "numeric" || class(parameters[[1]]) != "ML") {
                # Lambda can only be numeric or "ML"
                stop("Parameters must be a list of lambda, kappa and delta value or a single value for lambda or \"ML\".")
            }
            #Check kappa
            check.class(parameters[[2]], "numeric", ": kappa parameter must be numeric.")
            #Check delta
            check.class(parameters[[3]], "numeric", ": delta parameter must be numeric.")
            #Rename each parameter
            names(parameters) <- c("lambda", "kappa", "delta")
        }
    }

    #verbose
    check.class(verbose, 'logical')

    #output
    if(missing(output) || output == FALSE) {
        do_output <- FALSE
    } else {
        do_output <- TRUE
        check.class(output, 'character')
        check.length(output, 1, " must be a single chain of characters.")
        #Check if the output chain name is already present in the current directory
        if(length(grep(output, list.files())) > 0) {
            read.key(paste("Output chain name \"", output, "\" already exists!\nPress [enter] if you wish to overwrite the models or [esc] to cancel.", sep = ""), "Models will be overwritten...")
        }
    }

    #parallel
    if(!missing(parallel)) {
        require(snow)
        check.class(parallel[[1]], "numeric", " must be the number of cores.")
        check.class(parallel[[2]], "numeric", " must be the name of the VPN process.")
        names(parallel) <- c("cores", "VPN")
    }

    #RUNNING THE MODELS
#test.mulTree <- function(mulTree.data = mulTree.data, formula = formula, priors = priors, parameters = parameters, warn = warn, parallel, output = "testing", chains= 2, ...) {
    for (ntree in 1:length(mulTree.data$phy)) {
        #For each tree...
        #Setting up mulTre arguments
        mulTree_arguments <- as.list(substitute(list(tree = ntree, mulTree.data = mulTree.data, formula = formula, priors = priors, parameters = parameters, warn = warn, ...)))[-1L]
        #mulTree_arguments <- as.list(substitute(list(tree = ntree, mulTree.data = mulTree.data, formula = formula, priors = priors, parameters = parameters, warn = warn)))[-1L] ; warning("DEBUG")

        if(missing(parallel)) {
#        testing_nopar <- TRUE
#        if(testing_nopar == TRUE) {
#            warning("DEBUG MODE")
            #SEQUENTIALLY RUNNING THE CHAINS
            for(nchain in 1:chains) { # Weirdly enough, the loop is slightly more efficient in this non-parallel case!
                #...Run each chain one by one
                
                #reset the models content (security) 
                model_tmp <-NULL ; model <- NULL
                
                model_tmp <- do.call(lapply.MCMCglmm, mulTree_arguments)
                #model_tmp <- lapply.MCMCglmm(ntree, mulTree.data, formula, priors, parameters, ..., warn)
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
            cluster <- snow::makeCluster(chains, parallel)
            #reset the models content (security) 
            model_tmp <-NULL ; model <- NULL

            #model_tmp <- clusterCall(cluster, do.call(lapply.MCMCglmm, mulTree_arguments))
            model_tmp <- snow::clusterCall(cluster, lapply.MCMCglmm, ntree, mulTree.data, formula, priors, parameters, ..., warn)
            #model_tmp <- snow::clusterCall(cluster, lapply.MCMCglmm, ntree, mulTree.data=mulTree.data, formula=formula, priors=priors, parameters=parameters, warn=warn) ; warning("DEBUG MODE")
            
            snow::stopCluster(cluster)
            
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
                cat("Effective sample size is > ", ESS, ": ", all(coda::effectiveSize(model$Sol[]) > ESS), "\n", sep = "")
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
#}


#OUTPUT

    #timer (end)
    end.time <- Sys.time()
    execution.time <- difftime(end.time,start.time, units = "secs")

    #verbose
    if(verbose==TRUE) {
        cat("\n",format(Sys.Date())," - ",format(Sys.time(), "%H:%M:%S"), ":", " MCMCglmm successfully performed on ", length(mulTree.data$phy), " trees.\n",sep = "")
        get.timer(execution.time)
        cat("Use read.mulTree() to read the data as 'mulTree' data.\nUse summary.mulTree() and plot.mulTree() for plotting or summarizing the 'mulTree' data.\n", sep = "")
    }

#End
}
