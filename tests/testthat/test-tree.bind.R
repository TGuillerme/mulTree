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
    set.seed(1)
    expect_equal(round(add.root.edge(rtree(5), 10)$root.edge, digit=4), 8.3372)
})

# Testing lapply.bind.tree
test_that("lapply.bind.tree works", {
    # Errors:
    # element is not numeric
    expect_error(lapply.bind.tree("a", rmtree(3,5), rmtree(3,5), c(1,2), c(1,2), 10))
    # one of the trees is not multiPhylo
    expect_error(lapply.bind.tree(1, rtree(5), rmtree(3,5), c(1,2), c(1,2), 10))
    # the samples are not the same size as the elements
    expect_error(lapply.bind.tree(3, rmtree(3,5), rmtree(3,5), c(1,2), c(1,2), 10))
    # root age is missing
    expect_error(lapply.bind.tree(1, rmtree(3,5), rmtree(3,5), c(1,2), c(1,2)))
    # Outputs a tree
    expect_is(lapply.bind.tree(1, rmtree(3,5), rmtree(3,5), c(1,2), c(1,2), 10), "phylo")
    # Outputs has 10 tips
    expect_equal(Ntip(lapply.bind.tree(1, rmtree(3,5), rmtree(3,5), c(1,2), c(1,2), 10)), 10)
})

# Testing tree.bind
test_that("tree.bind works", {
    # Sanitizing
    # Not a tree
    expect_error(tree.bind("a", rtree(5), 10, 10))
    # One tree missing
    expect_error(tree.bind(rtree(5), 10, 10))
    # Not a sample
    expect_error(tree.bind(rmtree(3,5), rmtree(3,5), "a", 10))
    # Root age is not numeric
    expect_error(tree.bind(rtree(5), rtree(5), 3, "a"))
    # Warning
    # same tip labels
    expect_warning(tree.bind(rtree(5), rtree(5)))
    # Too much sample
    expect_warning(tree.bind(rtree(5), rtree(5), sample = 3))

    # Testing
    expect_equal(Ntip(tree.bind(rtree(5, tip.label=LETTERS[1:5]), rtree(5))), 10)
    expect_is(tree.bind(rtree(5, tip.label=LETTERS[1:5]), rtree(5)), "phylo")
    expect_is(tree.bind(rmtree(3,5, tip.label=LETTERS[1:5]), rmtree(3,5)), "phylo")
    expect_is(tree.bind(rmtree(3,5, tip.label=LETTERS[1:5]), rmtree(3,5), sample = 2), "multiPhylo")
    expect_equal(max(node.depth.edgelength(tree.bind(rmtree(3,5, tip.label=LETTERS[1:5]), rmtree(3,5), root.age = 10))), 10)
})
