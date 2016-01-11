# TEST read.mulTree
context("read.mulTree")

# Dummy data for testing
set.seed(1)
data <- data.frame("sp.col" = LETTERS[1:5], var1 = rnorm(5), var2 = rnorm(5))
tree <- replicate(3, rcoal(5, tip.label = LETTERS[1:5]), simplify = FALSE) ; class(tree) <- "multiPhylo"
mulTree.data <- as.mulTree(data, tree, taxa = "sp.col")
priors <- list(R = list(V = 1/2, nu = 0.002), G = list(G1 = list(V = 1/2, nu = 0.002)))
mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(10000, 10, 1000), chains = 2, prior = priors, output = "read.mulTree_testing", convergence = 1.1, ESS = 100, verbose = FALSE)

# Testing get.mulTree.model to get individual models
test_that("get.mulTree.model works", {
    #Errors
    # file not found
    expect_error(expect_warning(get.mulTree.model("Some_wrong_file")))
    # file not a MCMCglmm model
    expect_error(get.mulTree.model("read.mulTree_testing-tree2_conv.rda"))
    # Reading a single model
    # Input succeeds
    expect_is(get.mulTree.model("read.mulTree_testing-tree1_chain1.rda"), "MCMCglmm")
    # (18 elements)
    expect_equal(length(get.mulTree.model("read.mulTree_testing-tree1_chain1.rda")), 18)
})

# Testing get.convergence to get the convergence test
test_that("get.convergence works", {
    #Errors
    # file not found
    expect_error(expect_warning(get.convergence("Some_wrong_file")))
    # file not a MCMCglmm model
    expect_error(get.convergence("read.mulTree_testing-tree1_chain1.rda"))
    # Reading a single model
    # Input succeeds
    expect_is(get.convergence("read.mulTree_testing-tree1_conv.rda"), "gelman.diag")
    # first element is a matrix
    expect_is(get.convergence("read.mulTree_testing-tree1_conv.rda")[[1]], "matrix")
})

# Testing get.element to get the proper element
test_that("get.element works", {
    #Errors
    # Missing arguments
    expect_error(get.element("Tune"))
    expect_error(get.element("read.mulTree_testing"))
    # Wrong chain name
    expect_error(get.element("Tune", "read.mulTree_testing_wrong"))
    # Wrong element name (output is null)
    expect_true(all(unlist(lapply(get.element("Blune","read.mulTree_testing"), is.null))))
    # Extracting all the "Tune" elements
    # Output is a list
    expect_is(get.element("Tune", "read.mulTree_testing"), "list")
    # Of 6 objects
    expect_equal(length(get.element("Tune", "read.mulTree_testing")), 6)
    # All equal to 1
    expect_equal(as.numeric(unlist(get.element("Tune", "read.mulTree_testing"))), rep(1,6))
})

# Testing get.element to get the proper element

get.table.mulTree <- function(mcmc.file)

test_that("get.mulTree.table works", {
    #Errors
    # Missing arguments
    expect_error(get.table.mulTree("Tune"))
    # Getting the table
    # Get the table from an extracted model
    table_test <- get.table.mulTree( get.mulTree.model("read.mulTree_testing-tree1_chain1.rda"))
    # Table is a data.frame
    expect_is(table_test, "data.frame")
    # With 4 columns and 900 rows
    # and 900

})







#Remove the data
test_that("data has been cleaned", {
    #All true!
    expect_true(all(file.remove(list.files(pattern = "read.mulTree_testing"))))
})