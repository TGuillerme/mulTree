# TEST as.mulTree
context("as.mulTree")

# Testing select.tip.labels
test_that("select.tip.labels works", {
    # Errors
    expect_error(
    	select.tip.labels("a")
    	)
    expect_error(
    	select.tip.labels(1)
    	)
    # Output is character vector...
    expect_is(
    	select.tip.labels(rtree(5)), "character"
    	)
    # ... of 5 elements: t1, to t5
    expect_equal(
    	select.tip.labels(rtree(5)), c("t1", "t2", "t3", "t4", "t5")
    	)
})


# Testing specimen.transform
data1 <- data.frame("sp.col" = LETTERS[1:5], var1 = rnorm(5), var2 = c(rep("a",2), rep("b",3)))
data2 <- rbind(data1, data1)
test_that("specimen.transform works", {
    # Errors
    expect_error(
    	specimen.transform("a")
    	)
    expect_error(
    	specimen.transform(matrix(NA, 5,5))
    	)
    #No modification
    expect_equal(
    	specimen.transform(data1), data1
    	)
    #Only 5 rows out instead of 10
    expect_equal(
    	nrow(data2), 10
    	)
    expect_equal(
    	nrow(specimen.transform(data2)), 5
    	)
    #Only unique sp.col names
    expect_equal(
    	length(unique(data2$sp.col)), 5
    	)
    expect_equal(
    	length(specimen.transform(data2)$sp.col), 5
    	)
})


# # Testing comparative.data.test
# data <- data.frame("sp.col" = LETTERS[1:5], var1 = rnorm(5), var2 = c(rep("a",2), rep("b",3)))
# tree1 <- rmtree(1,5, tip.label = LETTERS[1:5])
# tree2 <- tree1 ; tree2[[2]] <- rtree(5)
# test_that("comparative.data.test works", {
#     # Errors
#     expect_error(
#     	comparative.data.test("a")
#     	)
#     expect_error(
#     	comparative.data.test(tree1)
#     	)
#     expect_error(
#     	comparative.data.test(data)
#     	)
#     # Must be TRUE
#     expect_true(
#     	comparative.data.test(data, tree1)
#     	)
#     # Must be FALSE
#     expect_false(
#     	comparative.data.test(data, tree2)
#     	)
#     expect_false(
#     	comparative.data.test(tree1, tree2)
#     	)
# })


# Testing example
data_table <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5), var2 = c(rep("a",2), rep("b",3)))
tree_list <- rmtree(5,5, tip.label = LETTERS[1:5])
data_table_sp1 <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5), var2 = c(rep("a",2), rep("b",3)), specimen = c(rep("spec1", 5)))
data_table_sp2 <- data.frame(taxa = LETTERS[1:5], var1 = rnorm(5), var2 = c(rep("a",2), rep("b",3)), specimen = c(rep("spec2", 5)))
data_table2 <- rbind(data_table_sp1, data_table_sp2)
test_that("example works", {
    # Errors
    #taxa not found
    expect_error(
    	as.mulTree(data_table, tree_list, taxa = "WRONGNAME")
    	)
    #tree not a tree
    expect_error(
    	as.mulTree(data_table, 1, taxa = "taxa")
    	)
    #table not a table
    expect_error(
    	as.mulTree("bla", tree_list, taxa = "taxa")
    	)

    #Example 1
    # outputs a mulTree...
    expect_is(
    	as.mulTree(data_table, tree_list, taxa = "taxa"), "mulTree"
    	)
    # ...of for objects:
    expect_equal(
    	length(as.mulTree(data_table, tree_list, taxa = "taxa")), 4
    	) 
    # first being a multiphylo object
    expect_is(
    	as.mulTree(data_table, tree_list, taxa = "taxa")$phy, "multiPhylo"
    	) 
    # second being a data.frame object
    expect_is(
    	as.mulTree(data_table, tree_list, taxa = "taxa")$data, "data.frame"
    	)
    # third being a call (formula) object
    expect_is(
    	as.mulTree(data_table, tree_list, taxa = "taxa")$random.terms, "call"
    	)
    # forth being some text
    expect_is(
    	as.mulTree(data_table, tree_list, taxa = "taxa")$taxa.column, "character"
    	)

    #Example 2
    # outputs a mulTree...
    test2 <- suppressMessages(as.mulTree(data_table2, tree_list, taxa = "taxa", rand.terms = ~taxa+specimen))
    expect_is(
    	test2, "mulTree"
    	)
    # ...of for objects:
    expect_equal(
    	length(test2), 4
    	) 
    # first being a multiphylo object
    expect_is(
    	test2$phy, "multiPhylo"
    	) 
    # second being a data.frame object
    expect_is(
    	test2$data, "data.frame"
    	)
    expect_equal(
    	dim(test2$data), c(10,5)
    	)
    # third being a formula object
    expect_is(
    	test2$random.terms, "formula"
    	)
    expect_equal(
    	test2$random.terms, ~animal + specimen
    	)
    # forth being some text
    expect_is(
    	test2$taxa.column, "character"
    	)


    #Example 3 (with correlation)
    # outputs a mulTree...
    test3 <- suppressMessages(as.mulTree(data_table2, tree_list, taxa = "taxa", rand.terms = ~taxa+specimen+var2:us(var1)))
    test3.1 <- suppressMessages(as.mulTree(data_table2, tree_list, taxa = "taxa", rand.terms = ~taxa+specimen+us(var1):var2))
    expect_is(
        test3, "mulTree"
        )
    # ...of for objects:
    expect_equal(
        length(test3), 4
        ) 
    # first being a multiphylo object
    expect_is(
        test3$phy, "multiPhylo"
        ) 
    # second being a data.frame object
    expect_is(
        test3$data, "data.frame"
        )
    expect_equal(
        dim(test3$data), c(10,5)
        )
    # third being a formula object
    expect_is(
        test3$random.terms, "formula"
        )
    expect_equal(
        test3$random.terms, ~animal + specimen + var2:us(var1)
        )
    expect_equal(
        test3.1$random.terms, ~animal + specimen + us(var1):var2
        )    
    # forth being some text
    expect_is(
        test3$taxa.column, "character"
        )
})
