#Cleaning a tree so that the species match with the ones in a table
clean.tree.table <- function(tree, data, taxa, taxa_col) {

    #create a dummy data
      ###this is to make sure there are no dublicate names as the comparative.data function will throw an error about multiple
      ###entries for the same species.
  dummy_data <- data.frame(taxa,taxa_dummy =taxa)
  names(dummy_data)[taxa_col] <- "species"
 
    #dummy_data <- data
    #names(dummy_data)[taxa_col] <- "species"

    #run comparative.data to check the non matching columns/rows
    missing <- caper::comparative.data(tree, dummy_data, "species", vcv = FALSE, vcv.dim = 2, na.omit = TRUE, force.root = FALSE, warn.dropped = FALSE, scope = NULL)$dropped

    #Dropping tips (if necessary)
    if(length(missing$tips) != 0) {
        #drop the missing tips
        tree_tmp <- drop.tip(tree, missing$tips)
        #save the missing tips names
        dropped_tips <- missing$tips
    } else {
        #No drop needed!
        tree_tmp <- tree
        dropped_tips <- NA
    }

    #Dropping rows (if necessary)
    if(length(missing$unmatched.rows) != 0) {
        #Drop the unmatched rows
        
        data_loop_temp <- data
        for(i in 1:(length(missing$unmatched.rows))){
            data_loop_temp <- data_loop_temp[data_loop_temp[,1] != missing$unmatched.rows[i],]
            }
            data_tmp <- data_loop_temp
        #data_tmp <- data[-match(missing$unmatched.rows, data[,taxa_col]),]
        #save the dropped rows names
        dropped_rows<-missing$unmatched.rows
    } else {
        #No drop needed!
        data_tmp<-data
        dropped_rows<-NA
    }

    return(list("tree"=tree_tmp, "data"=data_tmp, "dropped_tips"=dropped_tips, "dropped_rows"=dropped_rows))
}
