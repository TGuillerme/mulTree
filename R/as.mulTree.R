##########################
#Combines a data table ("data.frame" or "matrix") and a "multiPhylo" object into a "mulTree" object
##########################
#Combines a table and a multiple phylogenies using comparative.data{caper} function.
#Changes the name of the species column into "sp.col" to be read by comparative.data
#v1.0.4
#Update: added the 'animal' column
#Update: added example
#Update: isolated function externally
#Update: allows multiple specimens for the same species
#Update: allows to give a random term formula
#Update: clean.data function inbuilt
#Update: now forces the first rand.terms column to be animal
#Update: the species column can now contain multiple occurrences of the same species
#Update: better formula management
##########################
#SYNTAX :
#<data> any table ("data.frame" or "matrix" object) containing at least two variable and species names
#<trees> a "multiPhylo" object
#<species> either the name or the number of the column containing the list of species in the data
#<rand.terms> additional random terms to add to the default random terms formula (phylogenetic effect). If NULL (default), the random terms is the column containing the species names and a column containing the specimen names if more than one species per specimen is present.
#<clean.data> logical, whether to use the clean.data function.
#----
#guillert(at)tcd.ie - 01/07/2015
##########################
#Requirements:
#-R 3
#-R package "ape"
#-R package "caper"
##########################

as.mulTree<-function(data, trees, species, rand.terms=NULL, clean.data=FALSE) {

#HEADER
    require(ape)
    require(caper)
    match_call <- match.call()

#DATA INPUT
    #data
    #converting into a data.frame (if matrix)
    if (class(data) == 'matrix') {
        data<-as.data.frame(data)
    }
    check.class(data, 'data.frame', " must be a \"data.frame\" object.")
    #Testing the length
    if(length(data) < 3) {
        stop(paste(as.expression(match_call$data," must contain one species name column and at least two variables.", sep=""), call.=FALSE))
    }


    #trees
    if(class(trees) != 'multiPhylo') {
        if(class(trees) == 'phylo') {
            warning(paste("Provided ", as.expression(match_call$trees)," is not a \"multiPhylo\" object.", sep=""), call.=FALSE)
            is.multiphylo=FALSE
            is.single.tree=TRUE
        } else {
            stop(paste(as.expression(match_call$trees)," must be a \"multiPhylo\" object.", sep=""), call.=FALSE)
        }
    } else {
        if(length(trees) == 1) {
            warning(paste("Provided ", as.expression(match_call$trees)," is not a \"multiPhylo\" object.", sep=""), call.=FALSE)
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
            stop(paste(as.expression(match_call$species)," not found in ", as.expression(match_call$data), sep=""), call.=FALSE)
        }
    }
    #is provided column present in data?
    if(species.column.num == TRUE) {
        if(species > length(data)) {
            stop(paste("species column not found in ", as.expression(match_call$data), sep=""), call.=FALSE)
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
        #check if at least of the terms is the phylogeny (i.e. animal)
        if(!is.na(match(species, terms_list))) {
            set_rand_terms<-"manual"
        } else {
            stop("The provided random terms should at least contain the species column (phylogeny).")
        }
    }

    #clean.data
    check.class(clean.data, 'logical', " must be \"logical\".")


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
            all_same_tips <- TRUE
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

    #Creating the temporary data set
    if(clean.data==TRUE) {
        data_cleaned<-clean.data(species, data, trees)
        trees<-data_cleaned$tree
        data_tmp<-data_cleaned$data
        cat("Dropped the following taxa:\n", data_cleaned$dropped.taxon)
    } else {
        data_tmp<-data
    }

    #renaming the species column in the data.frame
    
    #data_tmp<-data #This line overwrites the cleaned data with the original data.
    names(data_tmp)<-sub(species,"sp.col",names(data_tmp))

    #Checking if they are multiple specimens in the data
    #options(warn=-1)
    if(length(unique(data_tmp$sp.col)) == length(data_tmp$sp.col)) {
        #all entries are unique
        is.unique<-TRUE
        #random terms formula
    } else {
        #all entries are not unique
        is.unique<-FALSE
        #Creating a subset of the data containing only the unique species names entries
        sub_data<-data.frame("sp.col"=unique(data_tmp$sp.col), "dummy"=rnorm(length(unique(data_tmp$sp.col))))
    }
    #options(warn=0)

    #Running the comparative data.test
    if(is.unique==TRUE) {
        #Test without specimens
        test.comp.data<-fun.comparative.data.test(data_tmp, trees, is.multiphylo)
    } else {
        test.comp.data<-fun.comparative.data.test(sub_data, trees, is.multiphylo)
    }

    #Setting the random terms
    if(set_rand_terms=="auto") {
        #adding the 'animal' column for MCMCglmm() random effect
        data_tmp["animal"]<-NA
        data_tmp$animal<-data_tmp$sp.col
        rand.terms<-~animal
    } else {
        #Check which term corresponds to the phylogeny (i.e. animal)
        phylo_term<-terms_list[which(terms_list == species)]
        data_tmp[phylo_term]<-NA
        data_tmp[phylo_term]<-data_tmp[,which(names(data_tmp) == "sp.col")]

        #Modify the formula and the column name to correspond to animal (phylogeny) for MCMCglmm (unless the phylo term is already called animal)
        if(phylo_term != "animal") {
            names(data_tmp)[which(names(data_tmp) == phylo_term)]<-"animal"
            if(length(terms_list) == 1) {
                rand.terms[[2]]<-substitute(animal)
            }
            if(length(terms_list) == 2) {
                rand.terms[[2]][[2]]<-substitute(animal)
            }
            if(length(terms_list) == 3) {
                rand.terms[[2]][[2]][[2]]<-substitute(animal)
            }
            if(length(terms_list) == 4) {
                rand.terms[[2]][[2]][[2]][[2]]<-substitute(animal)
            }
            if(length(terms_list) == 5) {
                rand.terms[[2]][[2]][[2]][[2]][[2]]<-substitute(animal)
            }
            if(length(terms_list) == 6) {
                rand.terms[[2]][[2]][[2]][[2]][[2]][[2]]<-substitute(animal)
            }
            if(length(terms_list) == 7) {
                rand.terms[[2]][[2]][[2]][[2]][[2]][[2]][[2]]<-substitute(animal)
            }
            if(length(terms_list) == 8) {
                rand.terms[[2]][[2]][[2]][[2]][[2]][[2]][[2]][[2]]<-substitute(animal)
            }
            if(length(terms_list) == 9) {
                rand.terms[[2]][[2]][[2]][[2]][[2]][[2]][[2]][[2]][[2]]<-substitute(animal)
            }
            message("The random terms formula has been updated to \"", rand.terms,"\".\nThe column \"", species, "\" has been duplicated into a new column called \"animal\".") 
        }
    }


    #Creating the mulTree list object if test.comp.data is TRUE
    if(test.comp.data==TRUE) {
        #Save the name change notification
        if(set_rand_terms=="auto") {
            species.column<-paste("renamed column '", species, "' into 'sp.col'", sep="")
            output<-list(phy=trees, data=data_tmp, random.terms=rand.terms, species.column=species.column)
        } else {
            species.column<-paste("renamed column '", species, "' into 'sp.col'", sep="")
            output<-list(phy=trees, data=data_tmp, random.terms=rand.terms, species.column=species.column)
        }

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
