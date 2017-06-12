## Cleaning a tree so that the species match with the ones in a table
clean.tree.table <- function(tree, data, data.col) {

    ## Intersecting names between both data sets
    if(data.col != FALSE) {
        matching_names <- intersect(tree$tip.label, data[,data.col])
    } else {
        matching_names <- intersect(tree$tip.label, rownames(data))
    }

    ## Which data is present
    if(data.col != FALSE) {
        data_match <- data[,data.col] %in% matching_names
    } else {
        data_match <- rownames(data) %in% matching_names
    }

    ## Which tips are present
    tips_match <- tree$tip.label %in% matching_names

    ## Matching the data    
    if(all(data_match)) {
        dropped_rows <- NA
    } else {
        rows_numbers <- which(!data_match)
        if(data.col != FALSE) {
            dropped_rows <- data[,data.col][rows_numbers]
        } else {
            dropped_rows <- rownames(data)[rows_numbers]
        }
        dropped_rows <- rownames(data)[rows_numbers]
        data <- data[-c(rows_numbers),]
    }

    ## Matching the tree
    if(all(tips_match)) {
        dropped_tips <- NA
    } else {
        dropped_tips <- tree$tip.label[!tips_match]
        tree <- drop.tip(tree, tip = dropped_tips)
    }

    return(list("tree" = tree, "data" = data, "dropped_tips" = dropped_tips, "dropped_rows" = dropped_rows))
}