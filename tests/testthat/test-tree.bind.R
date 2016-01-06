# TEST tree.bind
context("tree.bind")

# Testing get.replace
test_that("get.replace works", {
    # Only one tree and one sample (no replace)
    expect_false(get.replace(rtree(3), 1))
    # Only one tree and more samples (replace)
    expect_true(get.replace(rtree(3), 2))
    # Only one (multi)tree and one sample (no replace)
    expect_false(get.replace(rmtree(1,3), 1))
    # Only one (multi)tree and one sample (no replace)
    expect_true(get.replace(rmtree(1,3), 2))
    # More trees than samples (no replace)
    expect_false(get.replace(rmtree(3,3), 2))
    # More samples than trees (replace)
    expect_true(get.replace(rmtree(3,3), 4))
})

# Testing sample.trees
test_that("sample.trees works", {
    # Equals 1 (no sample)
    expect_equal(sample.trees(rmtree(1,5), 1, FALSE), 1)
    # Equals 3
    set.seed(1)
    expect_equal(sample.trees(rmtree(3,5), 1, FALSE), 3)
    # Equals 3
    set.seed(1)
    expect_equal(sample.trees(rmtree(3,5), 1, TRUE), 3)
    # is length 2
    expect_equal(length(sample.trees(rmtree(3,5), 2, TRUE)), 2)
    # is length 2
    expect_equal(length(sample.trees(rmtree(3,5), 2, FALSE)), 2)
})


# Testing add.root.age
test_that("add.root.edge works", {
    # Error
    expect_error(add.root.edge("bla", 10))
    # Phylo object
    expect_is(add.root.edge(rtree(5), 10), "phylo")
    # Correct root edge
    set.seed(88)
    expect_equal(add.root.edge(rtree(5), 10)$root.edge, 8.263)
})
