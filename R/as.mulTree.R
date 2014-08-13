##########################
#Combines a data table ("data.frame" or "matrix") and a "multiPhylo" object into a "mulTree" object
##########################
#Combines a table and a multiple phylogenies using comparative.data{caper} function.
#Changes the name of the species column into "sp.col" to be read by comparative.data
#v0.1.1
#Update: added the 'animal' column
#Update: added example
##########################
#SYNTAX :
#<data> any table ("data.frame" or "matrix" object) containing at least two variable and species names
#<trees> a "multiPhylo" object
#<species> either the name or the number of the column containing the list of species in the data
#----
#guillert(at)tcd.ie - 10/08/2014
##########################
#Requirements:
#-R 3
#-R package "ape"
#-R package "caper"
##########################

as.mulTree<-function(data, trees, species) {

#HEADER
    require(ape)
    require(caper)

#DATA INPUT
    #data
    #converting into a data.frame (if matrix)
    if (class(data) == 'matrix') {
        data<-as.data.frame(data)
    }

    if (class(data) != 'data.frame') {
        stop("\"data\" must be a \"data.frame\" object.", call.=FALSE)
    } else {
        if(length(data) < 3) {
            stop("\"data\" must contain one species name column and at least two variables.", call.=FALSE)
        }
    }


    #trees
    if(class(trees) != 'multiPhylo') {
        if(class(trees) == 'phylo') {
            warning("Provided \"trees\" is not a \"multiPhylo\" object.", call.=FALSE)
            is.multiphylo=FALSE
            is.single.tree=TRUE
        } else {
            stop("\"trees\" must be a \"multiPhylo\" object.", call.=FALSE)
        }
    } else {
        if(length(trees) == 1) {
            warning("Provided \"trees\" contains only one tree.", call.=FALSE)
            is.multiphylo=TRUE
            is.single.tree=TRUE
        } else {
            is.multiphylo=TRUE
            is.single.tree=FALSE
        }
    }

    #species
    if (class(species) == 'numeric') {
        species.column.num=TRUE
    } else {
        if (class(species) == 'character') {
            species.column.num=FALSE
        } else {
            stop("\"species\" not found in \"data\".", call.=FALSE)
        }
    }
    #is provided column present in data?
    if(species.column.num == TRUE) {
        if(species > length(data)) {
            stop("species column not found in \"data\".", call.=FALSE)
        } else {
            species=names(data)[species]
        }
    } else {
        if(length(grep(species, names(data))) == 0) {
            stop("\"",species,"\""," not found in \"data\".", call.=FALSE)
        }
    }

#FUNCTION

    FUN.comparative.data.test<-function(data, trees, is.multiphylo){

        if(is.multiphylo == TRUE) {
            test<-try(comparative.data(trees[[1]], data, names.col="sp.col", vcv=FALSE), silent=TRUE) #see comment in the BUILDING THE "mulTree" OBJECT LIST section
        } else {
            test<-try(comparative.data(trees, data, names.col="sp.col", vcv=FALSE), silent=TRUE) #see comment in the BUILDING THE "mulTree" OBJECT LIST section
        }

        if(class(test) == "comparative.data") {
            try.comp.data=TRUE
        } else {
            try.comp.data=FALSE
        }
        return(try.comp.data)
    }

#BUILDING THE "mulTree" OBJECT LIST

    #because of the weird way comparative.data() deals with it's arguments (names.col <- as.character(substitute(names.col))),
    #species as to be replaced by just "sp.col" instead of the more cleaner way :
    #(species, list(species=species))) as in names.col <- as.character(substitute(species, list(species=species))).

    #renaming the species column in the data.frame
    names(data)<-sub(species,"sp.col",names(data))
    #adding the 'animal' column for MCMCglmm() random effect
    data["animal"]<-NA
    data$animal<-data$sp.col

    #Testing if the data and the trees can be used in comparative.data() and creating the 'mulTree' list
    if(FUN.comparative.data.test(data, trees, is.multiphylo) == TRUE) {
        species.column<-paste("renamed column '", species, "' into 'sp.col'", sep="")
        output<-list(phy=trees, data=data, species.column=species.column)
        class(output)<-'mulTree'
        return(output)
    } else {
        cat("Impossible to use comparative.data() on the given data and trees.")
    }

#End
}