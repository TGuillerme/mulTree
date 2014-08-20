#Testing rTreeBind function

#Make examples
set.seed(1)
x.1<-rtree(5)
y.1<-rtree(5)


#Sanitizing
test_that()

st.x.1<-single.tree(x.1)
st.x.2<-single.tree(x.2)
st.y.1<-single.tree(y.1)
st.y.2<-single.tree(y.2)

test_that('Is x a tree?', {
    expect_is(x.1, "phylo")
    expect_true(st.x.1)
    expect_is(x.2, "multiPhylo")
    expect_false(st.x.2)
})

test_that('Is y a tree?', {
    expect_is(y.1, "phylo")
    expect_true(st.y.1)
    expect_is(y.2, "multiPhylo")
    expect_false(st.y.2)
})



test_that('bla'),{
    expect_that(fun(1), equals(1))
}

