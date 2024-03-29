# TEST clean.data
# Testing clean.tree.table
tree <- rtree(6, tip.label = LETTERS[1:6])
data <- matrix(data =c(rnorm(4), runif(4)), 4, 2, dimnames = list(LETTERS[2:5]))
test <- clean.tree.table(tree, data, data.col = FALSE)
test_that("clean.tree.table works", {
    # Errors
    expect_error(
        clean.tree.table(TRUE)
        )
    # Output is a list...
    expect_is(
        test, "list"
        )
    # ... of 4 elements.
    expect_equal(
        length(test), 4
        )
    # First element is a tree...
    expect_is(
        test[[1]], "phylo"
        )
    # ...with three taxa.
    expect_equal(
        Ntip(test[[1]]), 4
        )
    # Second element is a table...
    expect_is(
        test[[2]], "matrix"
        )
    # ...with three rows.
    expect_equal(
        nrow(test[[2]]), 4
        )
    # Third element contains "F" and "A"
    expect_equal(
        sort(test[[3]]), c("A", "F")
        )
    # Forth element contains NA
    expect_equal(
        test[[4]], NA
        )
})

#Testing clean.data
trees_list <- list(rtree(5, tip.label = LETTERS[1:5]), rtree(4, tip.label = LETTERS[1:4]), rtree(6, tip.label = LETTERS[1:6])) ; class(trees_list) <- "multiPhylo"
dummy_data <- matrix(c(rnorm(5), runif(5)), 5, 2, dimnames = list(LETTERS[1:5], c("var1", "var2")))
cleaned <- clean.data(data = dummy_data, tree = trees_list)
test_that("clean.data works with a matrix", {
    # Output is a list...
    expect_is(
        cleaned, "list"
        )
    # ... of 4 elements.
    expect_equal(
        length(cleaned), 4
        )
    # First element are trees...
    expect_is(
        cleaned[[1]], "multiPhylo"
        )
    # ...with 4 taxa each.
    expect_equal(
        unique(unlist(lapply(cleaned[[1]], Ntip))), 4
        )
    # Second element is a table...
    expect_is(
        cleaned[[2]], "matrix"
        )
    # ...with four rows.
    expect_equal(
        nrow(cleaned[[2]]), 4
        )
    # Third element contains "F"
    expect_equal(
        cleaned[[3]], "F"
        )
    # Forth element contains "E"
    expect_equal(
        cleaned[[4]], "E"
        )
})


#Testing clean.data on data.frames
trees_list <- list(rtree(5, tip.label = LETTERS[1:5]), rtree(4, tip.label = LETTERS[1:4]), rtree(6, tip.label = LETTERS[1:6])) ; class(trees_list) <- "multiPhylo"
dummy_data <- data.frame(LETTERS[1:5], matrix(c(rnorm(5), runif(5)), 5, 2))
colnames(dummy_data) <- c("species", "var1", "var2")
cleaned <- clean.data(data = dummy_data, tree = trees_list, data.col = "species")
test_that("clean.data works with a data.frame", {
    # Errors
    expect_error(
        clean.data(data = matrix(c(rnorm(5), runif(5)), 5, 2), tree = trees_list, data.col = "species")
        )
    expect_error(
        clean.data(data = dummy_data, tree = trees_list, data.col = 8)
        )
    expect_error(
        clean.data(data = dummy_data, tree = trees_list, data.col = "8")
        )

    # Works with a single tree
    expect_is(
        clean.data(data = dummy_data, tree = trees_list[[1]], data.col = "species"), "list"
        )

    # Output is a list...
    expect_is(
        cleaned, "list"
        )
    # ... of 4 elements.
    expect_equal(
        length(cleaned), 4
        )
    # First element are trees...
    expect_is(
        cleaned[[1]], "multiPhylo"
        )
    # ...with 4 taxa each.
    expect_equal(
        unique(unlist(lapply(cleaned[[1]], Ntip))), 4
        )
    # Second element is a table...
    expect_is(
        cleaned[[2]], "data.frame"
        )
    # ...with four rows.
    expect_equal(
        nrow(cleaned[[2]]), 4
        )
    # Third element contains "F"
    expect_equal(
        cleaned[[3]], "F"
        )
    # Forth element contains "E"
    expect_equal(
        cleaned[[4]], "E"
        )

    # Returns NAs if trees and data are the same
    
    trees_list <- list(rtree(5, tip.label = LETTERS[1:5]), rtree(5, tip.label = LETTERS[1:5]), rtree(5, tip.label = LETTERS[1:5])) ; class(trees_list) <- "multiPhylo"
    dummy_data <- data.frame(LETTERS[1:5], matrix(c(rnorm(5), runif(5)), 5, 2))
    colnames(dummy_data) <- c("species", "var1", "var2")
    cleaned <- clean.data(data = dummy_data, tree = trees_list, data.col = "species")

    expect_true(
        is.na(cleaned$dropped_tips)
        )
    expect_true(
        is.na(cleaned$dropped_rows)
        )

})
