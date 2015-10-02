##########################
#Calculates the highest density regions for mulTree data
##########################
#Performs the hdr function on mulTree data and outputs a list of hdr for each fixed and random terms
#v0.2
#Update: isolated function externally
##########################
#SYNTAX :
#<mulTree.mcmc> a mcmc chain written by the mulTree function. Can be either a unique file or a chain name referring to multiple files. Use read.mulTree() to properly load the chains
#<CI> the credibility interval (can be more than one value)
#<...> any optional arguments to be passed to the hdr function
#
#Note,
#One might want to use all.modes=TRUE option for reporting all the modes using the hdr function. By default, hdr only calculates one mode.
##########################
#----
#guillert(at)tcd.ie - 13/08/2014
##########################
#Requirements:
#-R 3
#-R package "hdrcde"
#-R package "MCMCglmm"
#-R package "coda"
##########################

#quantile + mode
quantile.list<-function(X, CI, ...) {
    #Calculate the quantiles (called hdr to match hdr.mulTree)
    quant <- quantile(X, probs=sort(c(50-CI/2, 50+CI/2)/100), ...)
    #Transform the results into a table (called hdr to match hdr.mulTree)
    hdr <- matrix(data=quant, ncol=2, nrow=length(CI), byrow=FALSE, dimnames=list(paste(CI, "%", sep="")))
    #Reorder the maximum column
    hdr[,2] <- rev(hdr[,2])

    #Calculate the median (called mode to match hdr.mulTree)
    mode <- median(X)
    #mode <- as.numeric(names(sort(-table(X))[1]))

    #Output
    return(list("hdr"=hdr, "mode"=mode))
}


hdr.mulTree<-function(mulTree.mcmc, CI=95, use.hdr=TRUE, ...) {
    #DATA
    #mulTree.mcmc
    check.class(mulTree.mcmc, 'mulTree', " must be a 'mulTree' object.\nUse read.mulTree() function.")
    #making the 'mulTree' object into a 'data.frame'
    table.mcmc<-mulTree.mcmc
    class(table.mcmc)<-'data.frame'

    #CI
    check.class(CI, 'numeric', " is not numeric.")
    if (any(CI < 0)) {
        stop("Credibility interval must be between 0 and 100.", call.=FALSE)
    } else {
        if (any(CI > 100)) {
            stop("Credibility interval must be between 0 and 100.", call.=FALSE)
        }
    }

    #FUNCTIONS

    fun.hdr.mcmc<-function(table.mcmc, CI, ...) {
        #A list calculating the hdr for each fix and random terms
        hdr.mcmc<-lapply(as.list(table.mcmc), hdr, CI, ...)
        #Output
        return(hdr.mcmc)
    }

    fun.quantile.mcmc<-function(table.mcmc, CI, ...) {
        #A list calculating the quantiles for each terms
        hdr.mcmc<-lapply(as.list(table.mcmc), quantile.list, CI=CI, ...)
        #Output
        return(hdr.mcmc)
    }

    #CALCULATING THE HDR

    if(use.hdr == TRUE) {
        hdr.results<-fun.hdr.mcmc(mulTree.mcmc, CI, ...)
    } else {
        hdr.results<-fun.quantile.mcmc(mulTree.mcmc, CI, ...)
    }

    #OUPTUT

    return(hdr.results)

#End
}