##########################
#Combines a data table ("data.frame" or "matrix") and a "multiPhylo" object into a "mulTree" object
##########################
#Combines a table and a multiple phylogenies using comparative.data{caper} function.
#Changes the name of the species column into "sp.col" to be read by comparative.data
#v1.0.1
#Update: added the 'animal' column
#Update: added example
#Update: isolated function externally
#Update: allows multiple specimens for the same species
#Update: allows to give a random term formula
##########################
#SYNTAX :
#<data> any table ("data.frame" or "matrix" object) containing at least two variable and species names
#<trees> a "multiPhylo" object
#<species> either the name or the number of the column containing the list of species in the data
#<rand.terms> the formula for the random terms to be given to the MCMCglmm function where each elements are a column of the given data. If NULL (default), the random terms is the column containing the species names and a column containing the specimen names if more than one species per specimen is present.
#----
#guillert(at)tcd.ie - 17/12/2014
##########################
#Requirements:
#-R 3
#-R package "ape"
#-R package "caper"
##########################

as.mulTree<-function(data, trees, species, rand.terms=NULL) {

#HEADER
    require(ape)
    require(caper)

#DATA INPUT
    #data
    #converting into a data.frame (if matrix)
    if (class(data) == 'matrix') {
        data<-as.data.frame(data)
    }
    check.class(data, 'data.frame', " must be a \"data.frame\" object.")
    #Testing the length
    if(length(data) < 3) {
        stop("\"data\" must contain one species name column and at least two variables.", call.=FALSE)
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
        species.names<-grep(species, names(data))
        check.length(species.names, 0, " not found in \"data\".", errorif=TRUE)
    }

    #rand.terms
    if(is.null(rand.terms)) {
        set_rand_terms<-"auto"
    } else {
        #Checking random terms class
        check.class(rand.terms, 'formula', " must be a \"formula\" object.")
        #Checking if the element of rand.terms are present in the table
        terms_list<-labels(terms(rand.terms))
        #Checking if the terms are column names
        terms_list_match<-match(terms_list, colnames(data))
        if(any(is.na(terms_list_match))) {
            no_match<-terms_list[which(is.na(terms_list_match))]
            for (i in 1:length(no_match)) {
                stop("In rand.terms, \"",no_match[i], "\" is not matching with any column name in the provided data.")    
            }
        }
        set_rand_terms<-"manual"
    }


#FUNCTION

    fun.comparative.data.test<-function(data, trees, is.multiphylo){

        if(is.multiphylo == TRUE) {
            #Extracting all the tips from all the trees
            select.tip.labels<-function(tree) {return(sort(tree$tip.label))}
            trees_tips<-lapply(trees, select.tip.labels)
            #Testing if all the tips are equal
            all_same_tips<-length(unique(trees_tips))==1
            #If all tips are equal, test only on the first tree
            if(all_same_tips==TRUE) {
                test<-try(comparative.data(trees[[1]], data, names.col="sp.col", vcv=FALSE), silent=TRUE) #see comment in the BUILDING THE "mulTree" OBJECT LIST section
            } else {
                #Test each tree
                test<-NULL
                for (tree in 1:length(trees)) {
                   test[[tree]]<-try(comparative.data(trees[[tree]], data, names.col="sp.col", vcv=FALSE), silent=TRUE) 
                }
            }
        } else {
            #Test only for one tree (not multiPhylo)
            all_same_tips==TRUE
            test<-try(comparative.data(trees, data, names.col="sp.col", vcv=FALSE), silent=TRUE) #see comment in the BUILDING THE "mulTree" OBJECT LIST section
        }

        #Testing if the result is a comparative.data object
        if(all_same_tips==TRUE) {
            #Testing the class of a single test
            if(class(test) == "comparative.data") {
                try.comp.data=TRUE
            } else {
                try.comp.data=FALSE
            }
        } else {
            #Testing the class of a multiple test (all_same_tips==FALSE)
            if(length(unlist(unique(lapply(test, class)))) == 1) {
                if(unlist(unique(lapply(test, class))) == "comparative.data") {
                    try.comp.data=TRUE
                } else {
                    try.comp.data=FALSE
                }
            } else {
                try.comp.data=FALSE
            }
        }
        return(try.comp.data)
    }

#BUILDING THE "mulTree" OBJECT LIST

    #because of the weird way comparative.data() deals with it's arguments (names.col <- as.character(substitute(names.col))),
    #species as to be replaced by just "sp.col" instead of the more cleaner way :
    #(species, list(species=species))) as in names.col <- as.character(substitute(species, list(species=species))).

    #renaming the species column in the data.frame
    names(data)<-sub(species,"sp.col",names(data))

    #Checking if they are multiple specimens in the data
    if(all(unique(data$sp.col) == data$sp.col)) {
        #all entries are unique
        is.unique<-TRUE
        #random terms formula
        if(set_rand_terms=="auto") {
            #adding the 'animal' column for MCMCglmm() random effect
            data["animal"]<-NA
            data$animal<-data$sp.col
            rand.terms<-~animal
        }
    } else {
        #all entries are not unique
        is.unique<-FALSE
        #random terms formula
        if(set_rand_terms=="auto") {
            #Adding two new columns 'animal' and 'specimen' which are duplicates of 'sp.col'
            data["animal"]<-NA
            data$animal<-data$sp.col
            data["specimen"]<-NA
            data$specimen<-data$sp.col
            rand.terms<-~animal + specimen
        }
        #Creating a subset of the data containing only the unique species names entries
        sub.data<-data.frame("sp.col"=unique(data$sp.col), "dummy"=rnorm(length(unique(data$sp.col))))
    }

    #Running the comparative data.test
    if(is.unique==TRUE) {
        #Test without specimens
        test.comp.data<-fun.comparative.data.test(data, trees, is.multiphylo)
    } else {
        test.comp.data<-fun.comparative.data.test(sub.data, trees, is.multiphylo)
    }

    #Creating the mulTree list object if test.comp.data is TRUE
    if(test.comp.data==TRUE) {
        species.column<-paste("renamed column '", species, "' into 'sp.col'", sep="")
        output<-list(phy=trees, data=data, random.terms=rand.terms, species.column=species.column)
        class(output)<-'mulTree'
        return(output)
    } else {
        if(is.multiphylo==TRUE) { 
            cat("Impossible to use comparative.data() on the given data and trees.\nTaxa names in the trees and in the table probably don't match.\nYou can use the clean.data() function to match the trees and the data.")
        } else  { 
            cat("Impossible to use comparative.data() on the given data and tree.\nTaxa names in the tree and in the table probably don't match.\nYou can use the clean.data() function to match the tree and the data.")
        }
    }

#End
}