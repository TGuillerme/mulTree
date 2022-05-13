## Asking for confirmation
read.key <- function(msg1, msg2, scan = TRUE) {
    message(msg1)
    if(scan == TRUE) {
        scan(n = 1, quiet = TRUE)
    }
    silent <- "yes"
    if(!missing(msg2)) {
        message(msg2)
    }
}

## Runs one single (on one single tree) MCMCglmmm
lapply.MCMCglmm <- function(all_args){

    ## require MCMCglmm for snow
    require(MCMCglmm)

    ## Remove the warn from the arguments list
    warn <- all_args$warn
    all_args$warn <- NULL
    ## Disable warnings (if needed)
    if(warn == FALSE) {options(warn=-1)}

    ## Formula check
    if(class(all_args$random) == "call") {
        all_args$random <- stats::as.formula(all_args$random)
    }

    ## MCMCglmm
    model <- do.call(MCMCglmm::MCMCglmm, all_args)
    #model <- MCMCglmm::MCMCglmm(fixed = formula, random = mulTree.data$random.terms, pedigree = mulTree.data$phy[[tree]], prior = priors, data = mulTree.data$data, verbose = FALSE, nitt = parameters[1], thin = parameters[2], burnin = parameters[3]); warning("DEBUG") ## , ...)

    ## Re-enable warnings (if needed)
    if(warn == FALSE) {options(warn = 0)}

    return(model)
}


## Runs one single (on one single tree) MCMCglmmm
# lapply.MCMCglmm2 <- function(tree, mulTree.data, formula, priors, parameters, warn, ...){

#     ## require MCMCglmm for snow
#     require(MCMCglmm)

#     ## Disable warnings (if needed)
#     if(warn == FALSE) {options(warn=-1)}

#     ## Formula check
#     if(class(mulTree.data$random.terms) == "call") {
#         mulTree.data$random.terms <- stats::as.formula(mulTree.data$random.terms)
#     }

#     ## MCMCglmm
#     model <- MCMCglmm::MCMCglmm(fixed = formula, random = mulTree.data$random.terms, pedigree = mulTree.data$phy[[tree]], prior = priors, data = mulTree.data$data, verbose = FALSE, nitt = parameters[1], thin = parameters[2], burnin = parameters[3], ...)
#     #model <- MCMCglmm::MCMCglmm(fixed = formula, random = mulTree.data$random.terms, pedigree = mulTree.data$phy[[tree]], prior = priors, data = mulTree.data$data, verbose = FALSE, nitt = parameters[1], thin = parameters[2], burnin = parameters[3]); warning("DEBUG") ## , ...)

#     ## Re-enable warnings (if needed)
#     if(warn == FALSE) {options(warn = 0)}

#     return(model)
# }


## get the name of a model
get.model.name <- function(nchain, ntree, output){
    return(paste(output, "-tree", ntree, "_chain", nchain, ".rda", sep = ""))
}

## get the chains of a model
extract.chains <- function(nchain, ntree, output) {
    return(get.mulTree.model(get.model.name(nchain, ntree, output)))
}

## Runs a convergence test
convergence.test <- function(models){
    ## lapply wrapper
    get.VCV <- function (model) {
        return(coda::as.mcmc(model$VCV[1:(length(model$VCV[, 1])), ]))
    }

    ## get the list of mcmcm
    list_mcmc <- lapply(models, get.VCV)

    ## Convergence check using Gelman and Rubins diagnoses set to return true or false based on level of scale reduction set (default = 1.1)
    convergence <- try(coda::gelman.diag(coda::mcmc.list(list_mcmc)), silent = TRUE)

    ## Print error messages if convergence didn't run
    if(class(convergence) == "try-error") {
        warning(paste("Convergence test failed.\nError probably originated from coda::gelman.diag.\n", paste(convergence, collapse = "\n"), sep = ""), call. = FALSE)
        convergence <- NULL
    }

    return(convergence)
}

## Extract the ESS of a model
ESS.lapply <- function(model) {
    Sol <- coda::effectiveSize(model$Sol[])
    VCV <- coda::effectiveSize(model$VCV[])
    return(list("Sol"=Sol, "VCV"=VCV))
}

## Get the timer
get.timer <- function(execution.time) {
    if (execution.time[[1]] < 60) {
        cat("Total execution time: ", execution.time[[1]], " secs.\n", sep = "")
    } else {
        if (execution.time[[1]] >= 60 & execution.time[[1]] < 3600) {
            cat("Total execution time: ", execution.time[[1]]/60, " mins.\n", sep = "") 
        } else {
            if (execution.time[[1]] >= 3600 & execution.time[[1]] < 86400) {
               cat("Total execution time: ", execution.time[[1]]/3600, " hours.\n", sep = "")
            } else {
                if (execution.time[[1]] >= 86400) {
                    cat("Total execution time: ", execution.time[[1]]/86400, " days.\n", sep = "")
                }
            }
        }
    }
}