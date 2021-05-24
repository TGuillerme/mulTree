# TEST summary.mulTree
# Testing is.wholenumber works
test_that("is.wholenumber works", {
    # Error
    expect_error(
    	is.wholenumber("a")
    	)
    # Testing which number is whole
    # Not this one
    expect_false(
    	is.wholenumber(1.1)
    	)
    # But this one is
    expect_true(
    	is.wholenumber(round(1.1))
    	)
    expect_true(
    	is.wholenumber(1)
    	)
})

# Testing if prob.converter works
test_that("prob.converter works", {
    # Error 
    expect_error(
    	prob.converter("a")
    	)
    # Transforming one CI
    expect_is(
    	prob.converter(50), "numeric"
    	)
    expect_equal(
    	prob.converter(50), c(0.25, 0.75)
    	)
    # Transforming multiple CIs
    expect_is(
    	prob.converter(c(50, 95)), "numeric"
    	)
    expect_equal(
    	prob.converter(c(50, 95)), c(0.025, 0.25, 0.75, 0.975)
    	)
    # And even more!
    expect_equal(
    	length(prob.converter(seq(1:100))), 200
    	)
})

# Testing lapply.quantile
test_that("lapply.quantile works", {
    # Errors
    expect_error(
    	lapply.quantile("X", prob=c(50,95), cent.tend=mean)
    	)
    expect_error(
    	lapply.quantile(rnorm(100), prob="X", cent.tend=mean)
    	)
    expect_true(
    	lapply.quantile(rnorm(100), prob=c(50,95), cent.tend=mean)[[2]] != lapply.quantile(rnorm(100), prob=c(50,95), cent.tend=median)[[2]]
    	)
    # Output is a list
    expect_is(
    	lapply.quantile(rnorm(100), prob=c(50,95), cent.tend=mean), "list"
    	)
    # Of two elements
    expect_equal(
    	names(lapply.quantile(rnorm(100), prob=c(50,95), cent.tend=mean)), c("quantiles", "central")
    	)
    # First one is length 4
    expect_equal(
    	length(lapply.quantile(rnorm(100), prob=c(50,95), cent.tend=mean)[[1]]), 4
    	)
    # Second one is length 1
    expect_equal(
    	length(lapply.quantile(rnorm(100), prob=c(50,95), cent.tend=mean)[[2]]), 1
    	)
    # And works with additional arguments
    expect_is(
    	lapply.quantile(rnorm(100), prob=c(50,95), cent.tend=mean, na.rm=TRUE), "list"
    	)
})

# Testing lapply.hdr
test_that("lapply.hdr works", {

    ## Smooth hdr (internal)

    smooth_simple <- smooth.hdr(hdrcde::hdr(rnorm(100), prob=c(50,95)), prob=c(50,95), "test_hrd")
    expect_is(smooth_simple, "list")
    expect_equal(names(smooth_simple), c("hdr", "mode", "falpha"))

    expect_warning(smooth_bimod <- smooth.hdr(hdrcde::hdr((c(rnorm(50, 1, 1), rnorm(50, 10, 1))), prob=c(50,95)), prob=c(50,95), "test_hrd"))
    expect_is(smooth_bimod, "list")
    expect_equal(names(smooth_bimod), c("hdr", "mode", "falpha"))

    # Errors
    expect_error(
    	lapply.hdr("X", prob=c(50,95))
    	)
    expect_warning(
    	expect_error(lapply.hdr(rnorm(100), prob="X"))
    	)
    # Output is a list
    expect_is(
    	lapply.hdr(rnorm(100), prob=c(50,95)), "list"
    	)
    # Of two elements
    expect_equal(
    	names(lapply.hdr(rnorm(100), prob=c(50,95))), c("hdr", "mode", "falpha")
    	)
    # First one is length 4
    expect_equal(
    	length(lapply.hdr(rnorm(100), prob=c(50,95))[[1]]), 4
    	)
    # Second one is length 1
    expect_equal(
    	length(lapply.hdr(rnorm(100), prob=c(50,95))[[2]]), 1
    	)
    # And works with additional arguments
    expect_is(
    	lapply.hdr(rnorm(100), prob=c(50,95), n=100), "list"
    	)
})

# Testing result.list.to.table
test_that("result.list.to.table works", {
    list_test <- replicate(3, list("a"=rnorm(4), "b"=rnorm(sample(1:3, 1))), simplify = FALSE)
    # Errors
    expect_error(
    	result.list.to.table(NULL)
    	)
    # Output is a matrix
    expect_is(
    	result.list.to.table(list_test), "matrix"
    	)
    # of dimension 3 by 5
    expect_equal(
    	dim(result.list.to.table(list_test)), c(3,5)
    	)
})

# Loading the inbuilt data
data(lifespan.mcmc)
mulTree.results <- lifespan.mcmc

# Testing example
test_that("example works", {
    # Errors
    expect_error(
    	summary.mulTree(list(1))
    	)
    expect_error(
    	summary(lifespan.mcmc, prob="A")
    	)
    expect_error(
    	summary(lifespan.mcmc, use.hdr="why not")
    	)
    expect_error(
    	expect_warning(summary(lifespan.mcmc, use.hdr=FALSE, cent.tend=matrix))
    	)
    expect_error(
        summary(lifespan.mcmc, prob = 101)
        )
    test <- lifespan.mcmc
    test$Intercept <- 1
    test$mass <- 1
    test$volancy <- 1
    test$phy.var <- 1
    test$res.var <- 1
    expect_error(
        summary(test)
        )

    # Default example
    test_example <- summary(lifespan.mcmc)
    expect_is(
    	test_example, "matrix"
    	)
    expect_equal(
    	dim(test_example), c(5,5)
    	)
    expect_equal(
    	unlist(dimnames(test_example)), c("Intercept","mass","volancy","phy.var","res.var","Estimates(mode hdr)","lower.CI(2.5)","lower.CI(25)","upper.CI(75)","upper.CI(97.5)")
    	)
    # Example with different CI
    test_example <- summary(lifespan.mcmc, prob = 75)
    expect_is(
    	test_example, "matrix"
    	)
    expect_equal(
    	dim(test_example), c(5,3)
    	)
    expect_equal(
    	unlist(dimnames(test_example)), c("Intercept","mass","volancy","phy.var","res.var","Estimates(mode hdr)","lower.CI(12.5)","upper.CI(87.5)")
    	)
    # Example without hdr
    test_example <- summary(lifespan.mcmc, use.hdr = FALSE)
    test_example2 <- summary(lifespan.mcmc, use.hdr = FALSE, cent.tend=mean)
    expect_is(
    	test_example, "matrix"
    	)
    expect_equal(
    	dim(test_example), c(5,5)
    	)
    expect_equal(
    	unlist(dimnames(test_example)), c("Intercept","mass","volancy","phy.var","res.var","Estimates(median)","lower.CI(2.5)","lower.CI(25)","upper.CI(75)","upper.CI(97.5)")
    	)
})
