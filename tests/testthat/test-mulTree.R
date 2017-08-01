# TEST as.mulTree
context("mulTree")

# Testing select.tip.labels
test_that("read.key works - scan option deactivated!", {
    #Message
    expect_message(
    	read.key("message1", scan=FALSE)
    	)
    expect_message(
    	read.key("message1", "message2", scan=FALSE)
    	)
    #Too many messages
    expect_error(
    	read.key("message1", "message2", "message3", scan=FALSE)
    	)
    #Not enough messages
    expect_error(
    	read.key(scan=FALSE)
    	)
})

# Dummy data for testing
set.seed(1)
data <- data.frame("sp.col" = LETTERS[1:5], var1 = rnorm(5), var2 = rnorm(5))
tree <- replicate(3, rcoal(5, tip.label = LETTERS[1:5]), simplify = FALSE) ; class(tree) <- "multiPhylo"
mulTree_data <- as.mulTree(data, tree, taxa = "sp.col") ; mulTree.data <- mulTree_data
formula <- var1 ~ var2
parameters <- c(10000, 10, 1000)
chains <- 2
priors <- list(R = list(V = 1/2, nu = 0.002), G = list(G1 = list(V = 1/2, nu = 0.002)))

# Testing lapply MCMCglmm wrapper function
test_that("lapply.MCMCglmm works", {
    #Errors
    # tree is not a tree (multiPhylo)
    expect_error(
    	lapply.MCMCglmm(tree[[1]], mulTree.data, formula, priors, parameters), warn=FALSE
    	)
    # mulTree.data is not mulTree
    expect_error(
    	lapply.MCMCglmm(1, data, formula, priors, parameters), warn=FALSE
    	)
    # formula is not a formula
    expect_error(
    	lapply.MCMCglmm(1, mulTree.data, formula="bla", priors, parameters), warn=FALSE
    	)
    # priors' not a list
    expect_error(
    	lapply.MCMCglmm(1, mulTree.data, formula, prior=1, parameters), warn=FALSE
    	)
    # parameters is not a vector
    expect_error(
    	lapply.MCMCglmm(1, mulTree.data, formula, priors, parameters=1), warn=FALSE
    	)
    # wrong additional argument
    expect_error(
    	lapply.MCMCglmm(1, mulTree.data, formula, priors, parameters, some_arg="whatever"), warn=FALSE
    	)
    
    # When no errors, outputs a MCMCglmm object
    set.seed(1)
    test <- lapply.MCMCglmm(1, mulTree.data, formula, priors, parameters, warn=FALSE)
    # Output is MCMCglmm
    expect_is(
    	test, "MCMCglmm"
    	)
    # MCMCglmm is of standard length
    expect_equal(
    	length(test), 18
    	)
})

test_that("get.model.name internal fun", {
    expect_equal(get.model.name(1,1,"test"), "test-tree1_chain1.rda")
})

data <- data.frame("sp.col" = LETTERS[1:5], var1 = rnorm(5), var2 = rnorm(5))
tree <- replicate(3, rcoal(5, tip.label = LETTERS[1:5]), simplify = FALSE)
class(tree) <- "multiPhylo"
mulTree.data <- as.mulTree(data, tree, taxa = "sp.col")
priors <- list(R = list(V = 1/2, nu = 0.002),
      G = list(G1 = list(V = 1/2, nu = 0.002)))
mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(10000, 10, 1000),
     chains = 2, prior = priors, output = "quick_example", convergence = 1.1,
     ESS = 100, ask = FALSE, verbose = FALSE)

test_that("extract.chains internal fun", {
    model <- extract.chains(1, 1, "quick_example")
    expect_is(model, "MCMCglmm")
})

test_that("ESS.lapply internal fun", {
    model <- extract.chains(1, 1, "quick_example")
    ESS <- ESS.lapply(model)
    expect_is(ESS, "list")
    expect_equal(names(ESS), c("Sol", "VCV"))
})

## Clean folder
remove <- file.remove(list.files(pattern = "quick_example"))

test_that("cleaned files", {
    expect_true(all(remove))
})


test_that("get.timer internal function", {
    expect_output(get.timer(list(600)), "Total execution time: 10 mins.")
    expect_output(get.timer(list(3600)), "Total execution time: 1 hours.")
    expect_output(get.timer(list(3601)), "Total execution time: 1.000278 hours.")
    expect_output(get.timer(list(86400)), "Total execution time: 1 days")
    expect_output(get.timer(list(1000000)), "Total execution time: 11.57407 days")
})


# Creating two dummy chains
set.seed(1)
model_tree1_chain1 <- lapply.MCMCglmm(1, mulTree.data, formula, priors, parameters, warn=FALSE)
model_tree1_chain2 <- lapply.MCMCglmm(1, mulTree.data, formula, priors, parameters, warn=FALSE)
# Testing the convergence test
test_that("convergence.test works", {
    # Errors
    # Not a list
    expect_error(
    	convergence.test(model_tree1_chain1)
    	)
    # Not enough chains
    expect_warning(
    	convergence.test(list(model_tree1_chain1))
    	)
    # Missing arguments (error + message)
    expect_error(
    	expect_message(convergence.test("bla"))
    	)
    # Convergence works
    test <- convergence.test(list(model_tree1_chain1, model_tree1_chain2))
    # Output is gelman.diag
    expect_is(
    	test, "gelman.diag"
    	)
    # gelman.diag is standard format
    expect_equal(
    	length(test), 2
    	)
    # psrf is standard matrix
    expect_is(
    	test$psrf, "matrix"
    	)
})

#Testing ESS lapply (structure similar to convergence.test)
test_that("ESS.lapply works", {
    # Errors
    # Something silly
    expect_error(
    	ESS.lapply(3, 1)
    	)
    # ESS is a numeric vector (length 2)
    expect_is(
    	ESS.lapply(model_tree1_chain1), "list"
    	)
    expect_equal(
    	names(ESS.lapply(model_tree1_chain1)), c("Sol","VCV")
    	)
})


#Testing quick example
test_that("Quick mulTree example works", {
    #Errors
    #Not mulTree format
    expect_error(
    	mulTree(data, formula = var1 ~ var2, parameters = c(10000, 10, 1000), chains = 2, prior = priors, output = "quick_example", convergence = 1.1, ESS = 100)
    	)
    #Not matching formula
#    expect_error(
#    	mulTree(mulTree.data, formula = var1 ~ var3, parameters = c(10000, 10, 1000), chains = 2, prior = priors, output = "quick_example", convergence = 1.1, ESS = 100)
#		)
    #Not enough parameters
    expect_error(
    	mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(1,1), chains = 2, prior = priors, output = "quick_example", convergence = 1.1, ESS = 100)
    	)
    #Chains are not numeric
    expect_error(
    	mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(10000, 10, 1000), chains = "plenty", prior = priors, output = "quick_example", convergence = 1.1, ESS = 100)
    	)
    #Priors are not a lits
    expect_error(
    	mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(10000, 10, 1000), chains = 2, prior = 1, output = "quick_example", convergence = 1.1, ESS = 100)
    	)

    #
    # Does not run on Travis!
    #
    
    # #First example works
    # set.seed(1)
    # mulTree_test1 <- system.time(mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(100, 10, 10), chains = 2, prior = priors, output = "mulTree_testing", verbose = FALSE))
    # #Generates 9 files
    # expect_equal(
 	#  	length(list.files(pattern = "mulTree_testing")), 9
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree1_chain")), 2
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree2_chain")), 2
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree3_chain")), 2
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree1_conv")), 1
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree2_conv")), 1
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree3_conv")), 1
    #	)
    # #File remove successful
    # expect_true(all(file.remove(list.files(pattern = "mulTree_testing")))
    #	)

    # #Second example (parallel) works
    # set.seed(1)
    # mulTree_test2 <- system.time(mulTree(mulTree.data, formula = var1 ~ var2, parameters = c(100, 10, 10), chains = 2, prior = priors, output = "mulTree_testing", parallel = "SOCK", verbose = FALSE))
    # #Generates 9 files
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing")), 9
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree1_chain")), 2
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree2_chain")), 2
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree3_chain")), 2
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree1_conv")), 1
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree2_conv")), 1
    #	)
    # expect_equal(
    #	length(list.files(pattern = "mulTree_testing-tree3_conv")), 1
    #	)
    # #File remove successful
    # expect_true(
    #	all(file.remove(list.files(pattern = "mulTree_testing")))
    #	)
    # # Timer test

})
