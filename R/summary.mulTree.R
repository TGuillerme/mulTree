##########################
#Summarise MCMCglmm 'mulTree' data
##########################
#Creates a table containing the modes and the credibility intervals for the fixed and the random terms
#v0.3
#Update: removed the hdr calculations
#Update: isolated function externally
##########################
#SYNTAX :
#<mulTree.mcmc> a mcmc chain written by the mulTree function. Can be either a unique file or a chain name referring to multiple files. Use read.mulTree() to properly load the chains
#<CI> the credibility interval (can be more than one value)
#<...> any optional arguments to be passed to the hdr function
##########################
#----
#guillert(at)tcd.ie - 13/08/2014
##########################
#Requirements:
#-R 3
##########################


summary.mulTree<-function(mulTree.mcmc, CI=95, ...)
{
 
#DATA
    #mulTree.mcmc
    CHECK.class(mulTree.mcmc, 'mulTree', " must be a 'mulTree' object.\nUse read.mulTree() function.")

#FUNCTIONS

    FUN.sum.mcmc<-function(hdr.mcmc) {
        #Summarize the hdr.mcmc list building a table with the terms as rows and the estimates and the CI as columns
        #Preparing the columns
        terms<-names(hdr.mcmc)
        estimates<-rep(NA, length(terms)) ; lower.CI<-rep(NA, length(terms)) ; upper.CI<-rep(NA, length(terms))
        #Filling the columns
        for (n in 1:length(terms)) {
            estimates[n]<-hdr.mcmc[[n]]$mode
            lower.CI[n]<-min(hdr.mcmc[[n]]$hdr)
            upper.CI[n]<-max(hdr.mcmc[[n]]$hdr)
        }
        #Creating the data.frame
        sum.mcmc<-data.frame(row.names=terms, estimates=estimates, lower.CI=lower.CI, upper.CI=upper.CI)
        #Output
        return(sum.mcmc)
    }

#SUMMARIZYNG THE MCMC

    #Calculates the hdr
    hdr.results<-hdr.mulTree(mulTree.mcmc, CI=95, ...)

    #Returns in a table
    table<-FUN.sum.mcmc(hdr.results)

#OUPTUT

    return(table)

#End
}
