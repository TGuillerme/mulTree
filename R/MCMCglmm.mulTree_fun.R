#Asking for confirmation
read.key <- function(msg1, msg2, scan = TRUE) {
    message(msg1)
    if(scan == TRUE) {
        scan(n=1, quiet=TRUE)
    }
    silent <- "yes"
    if(!missing(msg2)) {
        message(msg2)
    }
}

#Runs one single (on one single tree) MCMCglmmm
lapply.MCMCglmm <- function(tree, mulTree.data, formula, priors, parameters, warn, ...){

    #require MCMCglmm for snow
    require(MCMCglmm)

    #Disable warnings (if needed)
    if(warn == FALSE) {options(warn=-1)}
    #MCMCglmm
    model <- MCMCglmm::MCMCglmm(fixed = formula, random = mulTree.data$random.terms, pedigree = mulTree.data$phy[[tree]], prior = priors, data = mulTree.data$data, verbose = FALSE, nitt = parameters[1], thin = parameters[2], burnin = parameters[3], ...)

    #Re-enable warnings (if needed)
    if(warn == FALSE) {options(warn=0)}

    return(model)
}

#Runs a convergence test
convergence.test <- function(chains){
    
    #lapply wrapper
    lapply.convergence.test <- function (model) {
        #return(coda::as.mcmc(get(paste("model_tree", ntree, "_chain", chain, sep = ""))$Sol[1:(length(get(paste("model_tree", ntree, "_chain", chain, sep = ""))$Sol[, 1])), ]))
        #return(list(terms = coda::as.mcmc(model$Sol[1:(length(model$Sol[, 1])), ]), random = coda::as.mcmc(model$Sol[1:(length(model$vcv[, 1])), ])))
        return(coda::as.mcmc(model$Sol[1:(length(model$Sol[, 1])), ]))
    }

    #get the list of mcmcm
    list_mcmc <- lapply(chains, lapply.convergence.test)

    #Convergence check using Gelman and Rubins diagnoses set to return true or false based on level of scale reduction set (default = 1.1)
    convergence <- coda::gelman.diag(mcmc.list(list_mcmc))

    return(convergence)
}

ESS.lapply <- function(X) {
    coda::effectiveSize(X$Sol[])
}

#Get the timer
get.timer <- function(execution.time) {
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
}
