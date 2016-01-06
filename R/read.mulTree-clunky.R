##########################
#Reads mcmc objects from mulTree function
##########################
#Reads mcmc objects from mulTree function stored out of R environment
#v0.3
#Update: now outputs 'mulTree' objects
#Update: allows to read a MCMCmodel (class 'MCMCglmm')
#Update: isolated function externally
##########################
#SYNTAX :
#<mulTree.mcmc> a mcmc chain written by the mulTree function. Can be either a unique file or a chain name referring to multiple files.
#<convergence> logical, if mulTree.mcmc is a chain name, whether to read the convergence file associated (default=FALSE)
#<model> logical, if mulTree.mcmc is not a chain name, whether to input the MCMCglmm model or the list of random and fixed terms only (default=FALSE)
##########################
#----
#guillert(at)tcd.ie - 13/08/2014
##########################
#Requirements:
#-R 3
#-R package "MCMCglmm"
#-R package "coda"
##########################


read.mulTree<-function(mulTree.mcmc, convergence=FALSE, model=FALSE, extract=NULL)
{   #stop("IN DEVELOPEMENT")
#HEADER
    require(MCMCglmm)
    require(coda)
    match_call<-match.call()

#DATA
    #mulTree.mcmc
    files<-list.files(pattern=mulTree.mcmc)
    check.length(files, 0, " files not found.", errorif=TRUE)

    if(length(files) == 1) {
        chain=FALSE
        if(length(grep("chain[0-9].rda", files)) == 0) {
            stop("File \"", mulTree.mcmc, "\" not found.", sep="",call.=FALSE)
        }
    } else {
        chain=TRUE
        if(length(grep("chain[0-9].rda", files)) == 0) {
            stop("File \"", mulTree.mcmc, "\" not found.", sep="",call.=FALSE)
        }
    }


    #convergence
    check.class(convergence, 'logical', " must be logical.")
    if(convergence == TRUE & chain == FALSE) {
        warning("The convergence file can't be loaded because \"", mulTree.mcmc, "\" is not a chain name.", sep="",call.=FALSE)
    }

    #model
    check.class(model, 'logical', " must be logical.")
    if(chain == TRUE & model == TRUE) {
        stop("The MCMCglmm model can't be loaded because \"", mulTree.mcmc, "\" is a chain name.", sep="",call.=FALSE)
    }

    #extract
    if(!is.null(extract)) {
        check.class(extract, 'character', " must be a character string.")
    }


#funCTION
    fun.read.mulTree<-function(mcmc.file) {
        model.name<-load(mcmc.file)
        model<-get(model.name)
        #Testing if the mcmc.file is the right object class
        if(class(model) != "MCMCglmm") {
            stop("File \"", mcmc.file, "\" is not a \"MCMCglmm\" object.", sep="",call.=FALSE)
        }
        return(model)
    }

    fun.read.convergence<-function(conv.file){
        conv.name<-load(conv.file)
        converge<-get(conv.name)
        #Testing if the mcmc.file is the right object class
        if(class(converge) != "gelman.diag") { #PUT THE RIGHT CLASS
            stop("File \"", converge, "\" is not a \"gelman.diag\" object.", sep="",call.=FALSE)
        }
        return(converge)
    }

    #function for extracting a single element
    fun.extract.element<-function(element, chain) {
        #Getting the right files
        mcmc.files<-files[grep("_chain", files)]

        #Extracting the models
        all.models <- lapply(as.list(mcmc.files), fun.read.mulTree)
        #Extracting the element
        all.elements <- sapply(all.models, "[[", element, simplify = FALSE)

        #applying the names of to the list
        elements.names <- sapply(strsplit(mcmc.files, paste(mulTree.mcmc,"_", sep="")), "[[", 2)
        elements.names <- sapply(strsplit(elements.names, ".rda"), "[[", 1)
        elements.names <- paste(elements.names, element, sep="_")
        names(all.elements) <- elements.names

        return(all.elements)
    }

#READING THE MCMC OBJECT

    if(!is.null(extract)) {
        test_model <- fun.read.mulTree(paste(mulTree.mcmc,"tree1","chain1.rda", sep="_"))
        if(any(is.na(match(extract, names(test_model))))) {
            #checking if the required element exists
            stop(paste(as.expression(match_call$extract), " element does not exist in any model.", sep=""))
        } else {
            if(length(extract) == 1) {
                #Remove only one element
                output <- fun.extract.element(extract, mulTree.mcmc)
            } else {
                #Remove the number of elements
                output <- lapply(as.list(extract), fun.extract.element, mulTree.mcmc)
                names(output) <- extract
            }
        }

        #Stop the function here
        return(output)
    }


    if(model == TRUE) {

        mcmc.file<-files[grep("_chain", files)]
        mcmc.model<-fun.read.mulTree(mcmc.file)

    } else {

        if(convergence == TRUE) {
        #Reading the convergence files
            #Selecting the convergence files
            conv.file<-files[grep("_conv.rda", files)]
            if(chain == FALSE) {
                #Reading a single convergence file
                output<-fun.read.convergence(conv.file)
            } else {
                #Reading multiple convergence files
                output<-lapply(conv.file, fun.read.convergence)
                names(output)<-strsplit(conv.file, split=".rda")
            }
        } else {
        #Reading the chains
            #Selecting the chains
            mcmc.file<-files[grep("_chain", files)]
            if(chain == FALSE) {
                #Reading a single chain
                output<-fun.read.mulTree(mcmc.file)
            } else {
                #Reading multiple chains
                output<-lapply(mcmc.file, fun.read.mulTree)
                names(output)<-strsplit(mcmc.file, split=".rda")
            }
        }
    }

#OUTPUT

    #If model == TRUE, return the MCMCglmm model
    if(model == TRUE) {

        return(mcmc.model)

    } else {

        #If convergence == FALSE transforms the file using table.mulTree function
        if(convergence == FALSE) {
            output<-table.mulTree(output)
            #make output in format 'mulTree' (list)
            class(output)<-'mulTree'
        }

        return(output)

    }

#End
}