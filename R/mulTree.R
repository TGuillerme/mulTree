##########################
#Run MCMCglmm on a 'mulTree.data' object
##########################
#Running a MCMCglmm model on a list of phylogenies and the data stored in a 'mulTree.data' object. The results can be written out of R environment as individual models.
#v0.2
#Update: added convergence conditions
#Update: typos and added warn option
#Update: fixed timing management
#Update: isolated function externally
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
#guillert(at)tcd.ie & healyke(at)tcd.ie - 13/08/2014
##########################
#Requirements:
#-R 3
#-R package "ape"
#-R package "caper"
#-R package "MCMCglmm"
#-R package "coda"
##########################


mulTree<-function(mulTree.data, formula, parameters, chains=2, priors=NULL, ..., convergence=1.1, ESS=1000, verbose=TRUE, output=TRUE, warn=FALSE)
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

#DATA
    #mulTree.data
    #must be mulTree
    CHECK.class(mulTree.data, 'mulTree', " is not a \"mulTree\" object.\nUse as.mulTree.data() function.")
    #must be of three elements
    CHECK.length(mulTree.data, 3, " is not a \"mulTree\" object.\nUse as.mulTree.data() function.")
    #first element must be phylo
    mulTree_phylogeny<-mulTree.data[[1]]
    CHECK.class(mulTree_phylogeny, 'multiPhylo', " is not a \"multiPhylo\" object.\nUse as.mulTree.data() function.")
    #second element must be data.frame
    mulTree_data<-mulTree.data[[2]]
    CHECK.class(mulTree_data, 'data.frame', " is not a \"data.frame\" object.\nUse as.mulTree.data() function.")


    #formula
    CHECK.class(formula, 'formula', " is not a \"formula\" object.")

    #chains
    CHECK.class(chains, 'numeric', " must be numeric.")
    CHECK.length(chains, 1, " must be a single value.")
    if(chains == 1) {
        multiple.chains=FALSE
        warning("Only one chain has been called:\nconvergence test can't be performed.", call.=FALSE)
    } else {
        multiple.chains=TRUE
    }

    #parameters
    CHECK.class(parameters, 'numeric', " is not a \"vector\" object.")
    CHECK.length(parameters, 3, "must be a vector of three elements:\nthe number of generations ; the sampling and the burnin.")

    #priors
    if(is.null(priors)) {
        prior.default=TRUE
    } else {
        prior.default=FALSE
        CHECK.class(priors, 'list', " must be a list of three elements:\nsee ?MCMCglmm manual.")
    }

    #convergence
    CHECK.class(convergence, 'numeric', " must be numeric.")
    CHECK.length(convergence, 1, " must be a single value.")

    #ESS
    CHECK.class(ESS, 'numeric', " must be numeric.")
    CHECK.length(ESS, 1, " must be a single value.")

    #verbose
    CHECK.class(verbose, 'logical', " must be logical.")

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
        CHECK.class(output, 'logical', " must be a chain of characters.")
        CHECK.length(output, 1, " must be a single chain of characters.")
    } else {
        do.output=TRUE
    }

    #warn
    CHECK.class(warn, 'logical', " must be logical.")

#FUNCTION


    FUN.MCMCglmm<-function(ntree, mulTree.data, formula, priors, parameters, warn, ...){
        require(MCMCglmm)
        #Model running using MCMCglmm function (MCMCglmm) on each tree [i] on two independent chains
        if(warn == FALSE) {
            options(warn=-1) #Disable warning for now
        }
        model<-MCMCglmm(formula, random=~animal, pedigree=mulTree.data$phy[[ntree]], prior=priors, data=mulTree.data$data, verbose=FALSE, nitt=parameters[1], thin=parameters[2], burnin=parameters[3], ...)
        if(warn == FALSE) {
            options(warn=0) #Re-enable warnings
        }
        return(model)
    }

    FUN.convergence.test<-function(chains){
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
        for (nchains in 1:chains) {
            model_chain<-FUN.MCMCglmm(ntree, mulTree.data, formula, priors, parameters, ..., warn)
            assign(paste("model_chain", nchains, sep=""), model_chain)
        }

        #Saving models
        if(do.output == TRUE) {
            for (nchains in 1:chains) {
                model<-get(paste("model_chain",nchains,sep=""))
                name<-get(paste("file.names.chain",nchains,sep=""))[[ntree]]
                save(model, file=name)
            }
        }

        #Testing the convergence for one tree
        if(multiple.chains == TRUE) {
            converge.test<-FUN.convergence.test(chains)
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