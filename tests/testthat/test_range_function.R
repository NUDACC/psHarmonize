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



# Testing categorical range function ---------

test_data_cat <- data.frame(education = c('HS','None',NA,'CC','GS','Cert','HS','BS','MS','PhD',NA,'CC','Cert'))
possible_vals <- c('None , GS, HS , BS, MS, PhD')

expected_values_cat <- c('HS','None',NA,NA,'GS',NA,'HS','BS','MS','PhD',NA,NA,NA)

expected_list <- list('new_value' = expected_values_cat, 'range_set_to_na' = 4)

test_that('Testing categorical range function', {

  expect_equal(range_function_cat(data = test_data_cat, possible_vals_cat = possible_vals, new_var = 'education'), expected_list)

})

# Trying with just one value -------

possible_vals <- c('HS')

expected_values_cat <- c('HS',NA,NA,NA,NA,NA,'HS',NA,NA,NA,NA,NA,NA)

expected_list <- list('new_value' = expected_values_cat, 'range_set_to_na' = 9)

test_that('Testing categorical range function', {

  expect_equal(range_function_cat(data = test_data_cat, possible_vals_cat = possible_vals, new_var = 'education'), expected_list)

})

# Testing with space in value -----------

# Testing categorical range function ---------

test_data_cat <- data.frame(education = c('High School','None',NA,'Community College','Grade School','Cert','High School','BS','MS','PhD',NA,'Community College','Cert'))
possible_vals <- c('None , Grade School, High School , BS, MS, PhD')

expected_values_cat <- c('HS','None',NA,NA,'GS',NA,'HS','BS','MS','PhD',NA,NA,NA)

expected_list <- list('new_value' = expected_values_cat, 'range_set_to_na' = 4)

test_that('Testing categorical range function', {

  expect_equal(range_function_cat(data = test_data_cat, possible_vals_cat = possible_vals, new_var = 'education'), expected_list)

})

