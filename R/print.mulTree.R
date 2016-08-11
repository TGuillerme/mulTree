#' @title Prints a \code{mulTree} object.
#'
#' @description Summarises the content of a \code{mulTree} object.
#'
#' @param mulTree.data A \code{mulTree} object.
#' @param all \code{logical}; whether to display the entire object (\code{TRUE}) or just summarise it's content (\code{FALSE} - default).
#'
#' @examples
#'
#' @seealso \code{\link{as.mulTree}}, \code{\link{mulTree}}, \code{\link{summary.mulTree}}.
#'
#' @author Thomas Guillerme
#' @export
#' 

# # DEBUG
# data_table <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5),
#      var2 = c(rep("a",2), rep("b",3)))
# ##Creates a list of tree
# tree_list <- rmtree(5,5, tip.label = LETTERS[1:5])
# ##Creates the "mulTree" object
# as.mulTree(data_table, tree_list, taxa = "taxa")

# ##Creating a mulTree object with multiple specimens
# ##Creates a data.frame with taxa being labelled as "spec1"
# data_table_sp1 <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5),
#      var2 = c(rep("a",2), rep("b",3)), specimen = c(rep("spec1", 5)))
# ##Creates a data.frame with taxa being labelled as "spec2"
# data_table_sp2 <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5),
#      var2 = c(rep("a",2), rep("b",3)), specimen = c(rep("spec2", 5)))
# ##Combines both data.frames
# data_table <- rbind(data_table_sp1, data_table_sp2)
# ##Creates a list of tree
# tree_list <- rmtree(5,5, tip.label = LETTERS[1:5])
# ##Creates the "mulTree" object (with a random term formula)
# as.mulTree(data_table, tree_list, taxa = "taxa", rand.terms = ~taxa+specimen)

print.mulTree <- function(mulTree.data, all = FALSE) {

    if(all == TRUE) {
        # Print the raw data
        tmp <- mulTree.data
        class(tmp) <- "list"
        print(tmp)

    } else {

        # Summarise the mulTree data

        # Just the data
        if(length(mulTree.data) == 4) {
            # Printing the data head
            print.mulTree.head(mulTree.data)
            # Printing details on the data
            cat("\nData:\n")
            print(head(mulTree.data$data))
            cat("\nRandom terms:\n")
            print(mulTree.data$random.terms)
        }
    }
}