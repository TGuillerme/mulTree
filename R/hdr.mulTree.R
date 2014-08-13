##########################
#Calculates the highest density regions for mulTree data
##########################
#Performs the hdr function on mulTree data and outputs a list of hdr for each fixed and random terms
#v0.1
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


hdr.mulTree<-function(mulTree.mcmc, CI=95, ...)
{   #stop("IN DEVELOPEMENT")
    #warning("only works with uni-modal and hdr")
#HEADER
    require(hdrcde)
    require(MCMCglmm)

#DATA
    #mulTree.mcmc
    if(class(mulTree.mcmc) != 'mulTree') {
        stop(as.character(substitute(mulTree.mcmc))," must be a 'mulTree' object.\nUse read.mulTree() function.", call.=FALSE)
    } else {
        table.mcmc<-mulTree.mcmc
        class(table.mcmc)<-'data.frame'
    }

    #CI
    if (class(CI) != 'numeric') {
        stop("Credibility interval must be between 0 and 100.", call.=FALSE)
    }
    if (any(CI < 0)) {
        stop("Credibility interval must be between 0 and 100.", call.=FALSE)
    } else {
        if (any(CI > 100)) {
            stop("Credibility interval must be between 0 and 100.", call.=FALSE)
        }
    }

#FUNCTIONS

    FUN.hdr.mcmc<-function(table.mcmc, CI, ...) {
        #A list calculating the hdr for each fix and random terms
        hdr.mcmc<-lapply(as.list(table.mcmc), hdr, CI, ...)
        #Output
        return(hdr.mcmc)
    }


#CALCULATING THE HDR

    hdr.results<-FUN.hdr.mcmc(mulTree.mcmc, CI, ...)

#OUPTUT

    return(hdr.results)

#End
}