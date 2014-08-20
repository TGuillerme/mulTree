#Testing class.check

#examples
class_1<-NA ; class(class_1) <- 'class_1'
class_2<-NA ; class(class_2) <- 'class_2'
class_3<-NA ; class(class_3) <- 'class_3'
class_list<-c("class_1", "class_2")

#test
test_that('Testing check.class()', {
    #class - single
    expect_null(check.class(class_1, "class_1", 'test'))
    expect_error(check.class(class_1, "class_1", 'test', errorif=TRUE))
    expect_null(check.class(class_2, "class_2", 'test'))
    expect_error(check.class(class_2, "class_2", 'test', errorif=TRUE))
    #class - multiple
    expect_that(check.class(class_1, class_list, 'test'), equals("class_1"))
    expect_that(check.class(class_2, class_list, 'test'), equals("class_2"))
    expect_error(check.class(class_3, class_list, 'test'))
})
message('.', appendLF=FALSE)
