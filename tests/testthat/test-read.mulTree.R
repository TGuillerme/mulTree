# TEST read.mulTree
context("read.mulTree")

# Dummy data for testing
set.seed(1
    	)
data <- data.frame("sp.col" = LETTERS[1:5], var1 = rnorm(5), var2 = rnorm(5))
tree <- replicate(3, rcoal(5, tip.label = LETTERS[1:5]), simplify = FALSE) ; class(tree) <- "multiPhylo"
mulTree.data <- as.mulTree(data, tree, taxa = "sp.col")
priors <- list(R = list(V = 1/2, nu = 0.002), G = list(G1 = list(V = 1/2, nu = 0.002)))
mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(10000, 10, 1000), chains = 2, prior = priors, output = "read.mulTree_testing", convergence = 1.1, ESS = 100, verbose = FALSE)

# Testing get.mulTree.model to get individual models
test_that("get.mulTree.model works", {
    #Errors
    # file not found
    expect_error(
    	expect_warning(get.mulTree.model("Some_wrong_file"))
    	)
    # file not a MCMCglmm model
    expect_error(
    	get.mulTree.model("read.mulTree_testing-tree2_conv.rda")
    	)
    # Reading a single model
    # Input succeeds
    expect_is(
    	get.mulTree.model("read.mulTree_testing-tree1_chain1.rda"), "MCMCglmm"
    	)
    # (18 elements)
    expect_equal(
    	length(get.mulTree.model("read.mulTree_testing-tree1_chain1.rda")), 18
    	)
})

# Testing get.convergence to get the convergence test
test_that("get.convergence works", {
    #Errors
    # file not found
    expect_error(
    	expect_warning(get.convergence("Some_wrong_file"))
    	)
    # file not a MCMCglmm model
    expect_error(
    	get.convergence("read.mulTree_testing-tree1_chain1.rda")
    	)
    # Reading a single model
    # Input succeeds
    expect_is(
    	get.convergence("read.mulTree_testing-tree1_conv.rda"), "gelman.diag"
    	)
    # first element is a matrix
    expect_is(
    	get.convergence("read.mulTree_testing-tree1_conv.rda")[[1]], "matrix"
    	)
})

# Testing get.element to get the proper element
test_that("get.element works", {
    #Errors
    # Missing arguments
    expect_error(
    	get.element("Tune")
    	)
    expect_error(
    	get.element("read.mulTree_testing")
    	)
    # Wrong chain name
    expect_error(
    	get.element("Tune", "read.mulTree_testing_wrong")
    	)
    # Wrong element name (output is null)
    expect_true(
    	all(unlist(lapply(get.element("Blune","read.mulTree_testing"), is.null)))
    	)
    # Extracting all the "Tune" elements
    # Output is a list
    expect_is(
    	get.element("Tune", "read.mulTree_testing"), "list"
    	)
    # Of 6 objects
    expect_equal(
    	length(get.element("Tune", "read.mulTree_testing")), 6
    	)
    # All equal to 1
    expect_equal(
    	as.numeric(unlist(get.element("Tune", "read.mulTree_testing"))), rep(1,6)
    	)
})

# Testing get.mulTree.table
test_that("get.mulTree.table works", {
    #Errors
    # Missing arguments
    expect_error(
    	get.table.mulTree("Tune")
    	)
    # Getting the table
    # Get the table from an extracted model
    table_test <- get.table.mulTree(get.mulTree.model("read.mulTree_testing-tree1_chain1.rda"))
    # Table is a list
    expect_is(
    	table_test, "list"
    	)
    # Of 4 elements
    expect_equal(
    	length(table_test), 4
    	)
    #Each containing 900 elements
    expect_equal(
    	unlist(unique(lapply(table_test, length))), 900
    	)
})

# Testing read.mulTree
test_that("example works", {
    # Errors
    # wrong chain name
    expect_error(
    	read.mulTree("quick_example")
    	)
    # wrong format
    expect_error(
    	read.mulTree(1)
    	)
    # wrong format (args)
    expect_error(
    	read.mulTree("read.mulTree_testing", model = "yes")
    	)
    expect_error(
    	read.mulTree("read.mulTree_testing", convergence = "yes")
    	)
    expect_error(
    	read.mulTree("read.mulTree_testing", extract = "yes")
    	)
    # Running the example
    # Reading all the models
    all_chains <- read.mulTree("read.mulTree_testing")
    # Class is mulTree
    expect_is(
    	all_chains, "mulTree"
    	)
    # List of 4
    expect_equal(
    	length(all_chains), 4
    	)
    # List of 5400 elements
    expect_equal(
    	unlist(unique(lapply(all_chains, length))), 5400
    	)
    ## Reading the convergence diagnosis test
    conv_test <- read.mulTree("read.mulTree_testing", convergence = TRUE)
    # list of 3
    expect_equal(
    	length(conv_test), 3
    	)
    # gelman.diag objects
    expect_equal(
    	unlist(unique(lapply(conv_test, class))), "gelman.diag"
    	)
    # Reading a specific model
    model <- read.mulTree("read.mulTree_testing-tree1_chain1", model = TRUE)
    # class MCMCglmm
    expect_is(
    	model, "MCMCglmm"
    	)
    expect_equal(
    	length(model), 18
    	)
    # Reading only the error term and the tune for all models
    elements <- read.mulTree("read.mulTree_testing", extract=c("error.term", "Tune"))
    # 2 elements
    expect_equal(
    	names(elements), c("error.term", "Tune")
    	)
    # each containing 6
    expect_equal(
    	unlist(unique(lapply(elements, length))), 6
    	)
})

#Remove the data
test_that("data has been cleaned", {
    #All true!
    expect_true(
    	all(file.remove(list.files(pattern = "read.mulTree_testing")))
    	)
})