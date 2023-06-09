library(psHarmonize)

# Creating some test data --------

test_range <- data.frame(test_num = 100:500)


## Test 1 ------------

expected_data <- ifelse(test_range$test_num < 200 | test_range$test_num > 300, NA, test_range$test_num )

expected_list <- list('new_value' = expected_data, 'range_set_to_na' = 300)

test_that('Testing range function', {

  expect_equal(range_function(data = test_range, min_max_range = '[200,300]', new_var = 'test_num'), expected_list)

})




## Test 2 ------------

expected_data <- ifelse(test_range$test_num <= 200 | test_range$test_num > 300, NA, test_range$test_num )

expected_list <- list('new_value' = expected_data, 'range_set_to_na' = 301)

test_that('Testing range function', {

  expect_equal(range_function(data = test_range, min_max_range = '(200,300]', new_var = 'test_num'), expected_list)

})




## Test 3 ------------

expected_data <- ifelse(test_range$test_num < 200 | test_range$test_num >= 300, NA, test_range$test_num )

expected_list <- list('new_value' = expected_data, 'range_set_to_na' = 301)

test_that('Testing range function', {

  expect_equal(range_function(data = test_range, min_max_range = '[200,300)', new_var = 'test_num'), expected_list)

})




