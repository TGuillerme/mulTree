#Asking for confirmation
read.key <- function(msg1, msg2) {
    message(msg1)
    scan(n=1, quiet=TRUE)
    silent <- "yes"
    if(!missing(msg2)) {
        message(msg2)
    }
}

#Runs one single (on one single tree) MCMCglmmm
lapply.MCMCglmm <- function(tree, mulTree.data, formula, priors, parameters, warn, ...){
    #Disable warnings (if needed)
    if(warn == FALSE) {options(warn=-1)}
    #MCMCglmm
    model <- MCMCglmm(formula, random = mulTree.data$random.terms, pedigree = tree, prior = priors, data = mulTree.data$data, verbose = FALSE, nitt = parameters[1], thin = parameters[2], burnin = parameters[3], ...)
    #Re-enable warnings (if needed)
    if(warn == FALSE) {options(warn=0)}

    return(model)
}

#Runs a convergence test
convergence.test<-function(chains, ntree){
    #Creating the chains list
    list_chains <- as.list(seq(1:chains))

    #lapply wrapper
    lapply.convergence.test <- function (chain) {
        return(as.mcmc(get(paste("model_tree", ntree, "_chain", chain, sep = ""))$Sol[1:(length(get(paste("model_tree", ntree, "_chain", chain, sep = ""))$Sol[, 1])), ]))
    }

    #get the list of mcmcm
    list_mcmc <- lapply(list_chains, lapply.convergence.test)

    #Convergence check using Gelman and Rubins diagnoses set to return true or false based on level of scale reduction set (default = 1.1)
    convergence <- gelman.diag(mcmc.list(list_mcmc))

    return(convergence)
}


ESS.lapply <- function(chain, ntree) {
    effectiveSize(get(paste("model_tree", ntree, "_chain", chain, sep = ""))$Sol[])
}
