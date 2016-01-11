#Reads a single model
get.mulTree.model <- function(mcmc.file) {
    model.name <- load(mcmc.file)
    model <- get(model.name)
    #Testing if the mcmc.file is the right object class
    check.class(model, "MCMCglmm")
    return(model)
}

#Get the convergence diagnosis file
get.convergence <- function(conv.file){
    conv.name <- load(conv.file)
    converge <- get(conv.name)
    #Testing if the converge object is the right object class
    check.class(converge, "gelman.diag")
    return(converge)
}

#Extracting some specific elements from the chain
get.element <- function(element, chain) {
    #Getting the right files
    mcmc_files <- list.files(pattern = chain)
    mcmc_files <- mcmc_files[grep("_chain", mcmc_files)]

    #Extracting all the models
    all_models <- lapply(as.list(mcmc_files), get.mulTree.model)
    #Extracting the element
    all_elements <- sapply(all_models, "[[", element, simplify = FALSE)

    #applying the names of to the list
    names(all_elements) <- paste(mcmc_files, element, sep="$")

    return(all_elements)
}

#Isolate the fixed terms (model$Sol) and the random terms (model$VCV) from a single model
get.table.mulTree <- function(mcmc.file) {
    #Getting the fixed terms
    table_mcmc <- as.data.frame(mcmc.file$Sol)
    #Adding the random terms
    random_terms <- c("phylogenetic.variance","residual.variance")
    table_mcmc[random_terms[1]]<-as.vector(mcmc.file$VCV[,1])
    table_mcmc[random_terms[2]]<-as.vector(mcmc.file$VCV[,2])
    #Output
    return(table_mcmc)
}

