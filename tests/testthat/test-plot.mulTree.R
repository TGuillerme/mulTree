# TEST plot.mulTree
context("plot.mulTree (non-graphic)")

# Testing get.ylim
test_that("get.ylim works", {
    # Error
    expect_error(get.ylim("bla"))
    # Output is 0.99 + 1.01 (max and min of 1 +/- 1%)
    expect_equal(get.ylim(1), c(0.99, 1.01))
    # Output is 0.99 + 10.01
    expect_equal(get.ylim(matrix(seq(from=0, to=9), 5)), c(0, 9.09))
})

# Testing get.width
test_that("get.width works", {
    # Error
    expect_error(get.width("bla"))
    # Output is 0,0,2,2
    expect_equal(get.width(1,1,1), c(0,0,2,2))
    # Output is 9.7, 9.7, 10.3, 10.3
    expect_equal(get.width(c(0.10, 0.20, 0.30), 10, 3), c(9.7, 9.7, 10.3, 10.3))
})

# Testing get.height
test_that("get.height works", {
    # Error
    expect_error(get.height("bla"))
    expect_error(get.height(1,1,1))
    expect_error(get.height(matrix(seq(1:15), nrow=3), 4, 1))
    # Output works
    expect_equal(get.height(matrix(seq(1:15), nrow=3), 1, 1), c(4,13,13,4))
    expect_equal(get.height(matrix(seq(1:15), nrow=3), 3, 2), c(9,12,12,9))
})
