##########################
#Run MCMCglmm on a 'mulTree.data' object
##########################
#Running a MCMCglmm model on a list of phylogenies and the data stored in a 'mulTree.data' object. The results can be written out of R environment as individual models.
#v1.0.1
#Update: added convergence conditions
#Update: typos and added warn option
#Update: fixed timing management
#Update: isolated function externally
#Update: now dealing with the new mulTree objects containing the random terms formula
##########################
#SYNTAX :
#<mulTree.data> a 'mulTree.data' object obtained from as.mulTree.data function
#<formula> an object of class 'formula'
#<chains> the number of independent chains for the mcmc
#<parameters> a vector of three elements to use as parameters for the mcmc. Should be respectively Number of generations, sampling and burnin.
#<priors> a series of priors to use for the mcmc (default=NULL is using the default parameters from MCMCglmm function)
#<...> any additional argument to be passed to MCMCglmm() function
#<convergence> a numerical value for assessing chain convergence (default=1.1)
#<ESS> a numerical value for assessing the effective sample size (default=1000)
#<verbose> whether to be verbose or not (default=FALSE)
#<output> any optional string of characters that will be used as chain name for the models output (default=FALSE)
#<warn> whether to print the warning messages from the MCMCglmm function (default=TRUE)
##########################
#----
#guillert(at)tcd.ie & healyke(at)tcd.ie - 17/12/2014
##########################
#Requirements:
#-R 3
#-R package "ape"
#-R package "MCMCglmm"
#-R package "coda"
##########################


mulTree<-function(mulTree.data, formula, parameters, chains=2, priors=NULL, ..., convergence=1.1, ESS=1000, verbose=TRUE, output=TRUE, warn=FALSE, parallel=NULL)
{   #warning("ouput option doesn't accept 'FALSE' yet (change the return format)")
    #stop("IN DEVELOPEMENT")
#HEADER
    #libraries
    require(ape)
    require(caper)
    require(coda)
    require(MCMCglmm)
    #timer(start)
    start.time <- Sys.time()

#SANITIZING
    
    #mulTree.data
    #must be mulTree
    check.class(mulTree.data, 'mulTree', " is not a \"mulTree\" object.\nUse as.mulTree.data() function.")
    #must be of three elements
    check.length(mulTree.data, 4, " is not a \"mulTree\" object.\nUse as.mulTree.data() function.")
    #first element must be phylo
    mulTree_phylogeny<-mulTree.data[[1]]
    if(any(c((class(mulTree_phylogeny) == "phylo"),(class(mulTree_phylogeny) == "multiPhylo"))) != TRUE) {
    check.class(mulTree_phylogeny, 'multiPhylo', " is not a \"multiPhylo\" or \"phylo\" object.\nUse as.mulTree.data() function.")
    }
    #####cheap fix to make a single tree nested so a call for mulTree.data$phy[[1]] gives the tree not $edge
    if((class(mulTree_phylogeny) == "phylo") == TRUE) {
    mulTree.data[[1]] <- list(mulTree.data[[1]]) ###this turn it into a nested list with one extra nest.
    class(mulTree.data[[1]]) = "multiPhylo" ###and the class of the list to "multiPhylo"
    }

    #second element must be data.frame
    mulTree_data<-mulTree.data[[2]]
    check.class(mulTree_data, 'data.frame', " is not a \"data.frame\" object.\nUse as.mulTree.data() function.")
    #third element must be a formula
    mulTree_rand_terms<-mulTree.data[[3]]
    check.class(mulTree_rand_terms, 'formula', " is not a \"formula\" object.\nUse as.mulTree.data() function.")
    #Setting the current environement
    environment(mulTree.data[[3]])<-environment()
    

    #formula
    check.class(formula, 'formula', " is not a \"formula\" object.")

    #chains
    check.class(chains, 'numeric', " must be numeric.")
    check.length(chains, 1, " must be a single value.")
    if(chains == 1) {
        multiple.chains=FALSE
        warning("Only one chain has been called:\nconvergence test can't be performed.", call.=FALSE)
    } else {
        multiple.chains=TRUE
    }

    #parameters
    check.class(parameters, 'numeric', " is not a \"vector\" object.")
    check.length(parameters, 3, "must be a vector of three elements:\nthe number of generations ; the sampling and the burnin.")

    #priors
    if(is.null(priors)) {
        prior.default=TRUE
    } else {
        prior.default=FALSE
        check.class(priors, 'list', " must be a list of three elements:\nsee ?MCMCglmm manual.")
    }

    #convergence
    check.class(convergence, 'numeric', " must be numeric.")
    check.length(convergence, 1, " must be a single value.")

    #ESS
    check.class(ESS, 'numeric', " must be numeric.")
    check.length(ESS, 1, " must be a single value.")

    #verbose
    check.class(verbose, 'logical', " must be logical.")

    #output
    if(class(output) == 'logical') {
        if(output==FALSE){
            do.output=FALSE
            cat("No output option selected, this might highly decrease the performances of this function.")
        } else {
            do.output=TRUE
            output="mulTree.out"
            cat("Analysis output is set to \"mulTree.out\" by default.\nTo modify it, specify the output chain name using:\nmulTree(..., output=<OUTPUT_NAME>, ...)\n") 
        }
    }
    if(class(output) != 'logical') {
        check.class(output, 'character', " must be a chain of characters.")
        check.length(output, 1, " must be a single chain of characters.")
        do.output=TRUE
    }

    #warn
    check.class(warn, 'logical', " must be logical.")

    #parallel
    if(!is.null(parallel)) {
        check.class(parallel, "character")
    }

#FUNCTIONS


    fun.MCMCglmm<-function(ntree, mulTree.data, formula, priors, parameters, warn, ...){
        require(MCMCglmm)
        #Model running using MCMCglmm function (MCMCglmm) on each tree [i] on two independent chains
        if(warn == FALSE) {
            options(warn=-1) #Disable warning for now
        }
        model<-MCMCglmm(formula, random=mulTree.data$random.terms, pedigree=mulTree.data$phy[[ntree]], prior=priors, data=mulTree.data$data, verbose=FALSE, nitt=parameters[1], thin=parameters[2], burnin=parameters[3], ...)
        if(warn == FALSE) {
            options(warn=0) #Re-enable warnings
        }
        return(model)
    }

    fun.convergence.test<-function(chains){
        #Creating the mcmc.list
        list.mcmc<-list()
        for (nchains in 1:chains){
            list.mcmc[[nchains]]<-as.mcmc(get(paste("model_chain",nchains,sep=""))$Sol[1:(length(get(paste("model_chain",nchains,sep=""))$Sol[,1])),])
        }

        #Convergence check using Gelman and Rubins diagnoses set to return true or false based on level of scale reduction set (default = 1.1)
        convergence<-gelman.diag(mcmc.list(list.mcmc))
        return(convergence)
    }


#RUNNING THE MODELS

    #Creating the list of file names per tree
    file.names<-vector("list", length(mulTree.data$phy))
    for (ntree in (1:length(mulTree.data$phy))){
        file.names[[ntree]]<-paste(output, as.character("_tree"), as.character(ntree), sep="")
    }
    #Adding the chain name
    for (nchains in 1:chains) {
        file.names.chain<-paste(file.names, as.character("_chain"), as.character(nchains), as.character(".rda"), sep="")
        assign(paste("file.names.chain", nchains, sep=""), file.names.chain)
    }
    #Adding the convergence name
    file.names.conv<-paste(file.names, as.character("_conv"), as.character(".rda"), sep="")

    #Running the models n times for every trees
    for (ntree in 1:length(mulTree.data$phy)) {
        
        #Running the model for one tree
        if(is.null(parallel)) {

            #Serial version
            for (nchains in 1:chains) {
                model_chain<-fun.MCMCglmm(ntree, mulTree.data, formula, priors, parameters, ..., warn)
                #model_chain<-fun.MCMCglmm(ntree, mulTree.data, formula, priors, parameters, warn) ; warning("DEBUG MODE")
                #Assigning the model
                assign(paste("model_chain", nchains, sep=""), model_chain)
                if(do.output == TRUE) {
                    #Model output
                    model<-get(paste("model_chain",nchains,sep=""))
                    name<-get(paste("file.names.chain",nchains,sep=""))[[ntree]]
                    save(model, file=name)
                }
            }

        } else {
            #parallel version
            cluster<-makeCluster(chains, parallel)
            model_out<-clusterCall(cluster, fun.MCMCglmm, ntree, mulTree.data, formula, priors, parameters, ..., warn)
            #model_out<-clusterCall(cluster, fun.MCMCglmm, ntree=ntree, mulTree.data=mulTree.data, formula=formula, priors=priors, parameters=parameters, warn=warn) ; warning("DEBUG MODE")
            stopCluster(cluster)
            #Assigning the models
            for (nchains in 1:chains) {
                assign(paste("model_chain", nchains, sep=""), model_out[[nchains]])
            }
            #Saving models
            if(do.output == TRUE) {
                for (nchains in 1:chains) {
                    model<-get(paste("model_chain",nchains,sep=""))
                    name<-get(paste("file.names.chain",nchains,sep=""))[[ntree]]
                    save(model, file=name)
                }
            }
        }

        #Testing the convergence for one tree
        if(multiple.chains == TRUE) {
            converge.test<-fun.convergence.test(chains)
        }

        #Saving convergence
        if(do.output == TRUE & multiple.chains == TRUE) {
            save(converge.test, file=file.names.conv[ntree])
        }

        #Verbose
        if(verbose == TRUE) {
            cat("\n",format(Sys.Date())," - ",format(Sys.time(), "%H:%M:%S"), ":", " MCMCglmm performed on tree ", as.character(ntree),"\n",sep="")
            if(multiple.chains == TRUE) {
                cat("Convergence diagnosis:\n")
                cat("Effective sample size is > ", ESS, ": ", all(effectiveSize(model$Sol[])>ESS), "\n", sep="")
                cat(effectiveSize(get(paste("model_chain",nchains,sep=""))$Sol[]), "\n", sep=" ")
                cat("All levels converged < ", convergence, ": ", all(converge.test$psrf[,1]<convergence), "\n", sep="")
                cat(converge.test$psrf[,1], "\n", sep=" ")
            }
            if(do.output == TRUE){
                if(multiple.chains == TRUE) {
                    cat("Models saved as ", file.names[[ntree]], "_chain*.rda\n", sep="")
                    cat("Convergence diagnosis saved as ", file.names.conv[ntree],"\n", sep="")
                } else {
                    cat("Model saved as ", file.names[[ntree]], "_chain1.rda\n", sep="")
                }
            }
        }
    }


#OUTPUT

    #timer (end)
    end.time <- Sys.time()
    execution.time<- difftime(end.time,start.time, units="secs")

    #verbose
    if(verbose==TRUE) {
        cat("\n",format(Sys.Date())," - ",format(Sys.time(), "%H:%M:%S"), ":", " MCMCglmm successfully performed on ", length(mulTree.data$phy), " trees.\n",sep="")
        if (execution.time[[1]] < 60) {
            cat("Total execution time: ", execution.time[[1]], " secs.\n", sep="")
        } else {
            if (execution.time[[1]] > 60 & execution.time[[1]] < 3600) {
                cat("Total execution time: ", execution.time[[1]]/60, " mins.\n", sep="") 
            } else {
                if (execution.time[[1]] > 3600 & execution.time[[1]] < 86400) {
                   cat("Total execution time: ", execution.time[[1]]/3600, " hours.\n", sep="")
                } else {
                    if (execution.time[[1]] > 86400) {
                        cat("Total execution time: ", execution.time[[1]]/86400, " days.\n", sep="")
                    }
                }
            }
        }

        cat("Use read.mulTree() to read the data as 'mulTree' data.\nUse summary.mulTree() and plot.mulTree() for plotting or summarizing the 'mulTree' data.\n", sep="")
    }

#End
}
