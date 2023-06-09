library(psHarmonize)


# Creating some test data --------

test_func <- data.frame(test_num = 1:10)


expected_data <- test_func[['test_num']] ** 2


test_that('Testing modify function (numeric variables)', {

  expect_equal(code_modify_func(data = test_func, instruction = 'x**2', old_var = 'test_num'), expected_data)

})




set.seed(123)
test_func <- data.frame(test_num = rnorm(n = 300))


expected_data <- (test_func[['test_num']] * 8) + 5


test_that('Testing modify function (numeric variables)', {

  expect_equal(code_modify_func(data = test_func, instruction = '(x * 8) + 5', old_var = 'test_num'), expected_data)

})


