library(psHarmonize)


# Creating some test data --------

test_recode <- data.frame(test_num = c('1', '2', '3', '4'))

test_that('Testing recode function (categorical variables)', {

  expect_equal(code_modify_recode(data = test_recode,
                                  instruction = '1 = one; 2 = two; 3 = three; 4 = four',
                                  old_var = 'test_num',
                                  new_var = 'test_num_mod'),
               c('one','two','three','four'))

})


test_that('Testing recode function (swapping values)', {

  expect_equal(code_modify_recode(data = test_recode,
                                  instruction = '1 = 2; 2 = 1; 3 = 4; 4 = 3',
                                  old_var = 'test_num',
                                  new_var = 'test_num_mod'),
               c('2','1','4','3'))

})


test_that('Testing recode function (na_string option)', {

  expect_equal(code_modify_recode(data = test_recode,
                                  instruction = '1 = one; 2 = two; 3 = NA; 4 = four',
                                  old_var = 'test_num',
                                  new_var = 'test_num_mod',
                                  na_string = 'NA'),
               c('one','two',NA_character_,'four'))

})


test_that('Testing recode function (na_string option 2)', {

  expect_equal(code_modify_recode(data = test_recode,
                                  instruction = '1 = one; 2 = two; 3 = NA; 4 = four',
                                  old_var = 'test_num',
                                  new_var = 'test_num_mod',
                                  na_string = NULL),
               c('one','two','NA','four'))

})
