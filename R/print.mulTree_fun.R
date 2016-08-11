# Printing the mulTree object head
print.mulTree.head <- function(mulTree.data) {
    ntree <- length(mulTree.data$phy)
    ntax <- length(unique(mulTree.data$data$sp.col))
    terms <- length(mulTree.data$random.terms[2][[1]])
    nvar <- ncol(mulTree.data$data) - (terms%/%2 + terms%%2) - 1 #The sp.col
    cat("mulTree data containing:\n")
    if(ntree != 1) {
        cat(ntree, "phylogenetic trees with ")
    } else {
        cat(ntree, "phylogenetic tree with ")
    }
    cat(ntax, "taxa and ")
    if(nvar != 1) {
        cat(nvar ,"variables.")
    } else {
        cat(nvar ,"variable.")
    }
    #Taxa names
    taxa_names <- unique(mulTree.data$data$sp.col)
    cat("\nTaxa:\n")
    if(length(taxa_names) > 5) {
        cat(paste(taxa_names[1:5], collapse=", "),"...")
    } else {
        cat(paste(taxa_names, collapse=", "), ".", sep="")
    }
    #Variable names
    variables_names <- colnames(mulTree.data$data)[-c(1, nvar+length(mulTree.data$random.terms))]
    cat("\nVariables:\n")
    if(length(taxa_names) > 5) {
        cat(paste(variables_names[1:5], collapse=", "),"...")
    } else {
        cat(paste(variables_names, collapse=", "), ".", sep="")
    } 
}