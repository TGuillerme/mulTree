##########################
#Summarizes MCMCglmm objects into a table
##########################
#Summarizes MCMCglmm objects into a table containing the results of the fixed and random terms
#v0.1
##########################
#SYNTAX :
#<mulTree.mcmc> a mcmc chain written by the mulTree function. Can be either a unique file or a chain name referring to multiple files. Use read.mulTree() to properly load the chains
##########################
#----
#guillert(at)tcd.ie - 13/08/2014
##########################
#Requirements:
#-R 3
#-R package "MCMCglmm"
#-R package "coda"
##########################


table.mulTree<-function(mulTree.mcmc)
{
    
#HEADER
    require(MCMCglmm)
    require(coda)

#DATA
    #mulTree.mcmc
    if (class(mulTree.mcmc) == "MCMCglmm") {
        #mulTree.mcmc is a single "MCMCglmm" object
        chain=FALSE
    } else {
        #is mulTree.mcmc a list?
        if (class(mulTree.mcmc) == "list") {
            #does the list contain only "MCMCglmm" objects
            if (all(summary(mulTree.mcmc)[,2] == "MCMCglmm")) {
                chain=TRUE
            } else {
                stop("Input is not a \"MCMCglmm\" object or list.", call.=FALSE)
            }
        } else {
            stop("Input is not a \"MCMCglmm\" object or list.", call.=FALSE)
        }
    }

#funCTIONS

    fun.table.mcmc<-function(data.mcmc) {
        if(class(data.mcmc) == "MCMCglmm") {
            #Isolates the fixed terms (model$Sol) and the random terms (model$VCV)
            #Adding the fixed terms
            table.mcmc<-as.data.frame(data.mcmc$Sol)
            #Adding the random terms
            random.terms<-c("phylogenetic.variance","residual.variance")
            table.mcmc[random.terms[1]]<-as.vector(data.mcmc$VCV[,1])
            table.mcmc[random.terms[2]]<-as.vector(data.mcmc$VCV[,2])
        } else {
            table.mcmc<-as.data.frame(data.mcmc[[1]]$Sol)
            random.terms<-c("phylogenetic.variance","residual.variance")
            table.mcmc[random.terms[1]]<-as.vector(data.mcmc[[1]]$VCV[,1])
            table.mcmc[random.terms[2]]<-as.vector(data.mcmc[[1]]$VCV[,2])
            for (n in 2:length(data.mcmc)) {
                table.mcmc.bis<-as.data.frame(data.mcmc[[n]]$Sol)
                table.mcmc.bis[random.terms[1]]<-as.vector(data.mcmc[[n]]$VCV[,1])
                table.mcmc.bis[random.terms[2]]<-as.vector(data.mcmc[[n]]$VCV[,2])
                table.mcmc<-rbind(table.mcmc, table.mcmc.bis)
            }
        }
        #Output
        return(table.mcmc)
    }

#SUMMARIZYNG THE MCMC

    table.results<-fun.table.mcmc(mulTree.mcmc)

#OUPTUT

    return(table.results)

#End
}
