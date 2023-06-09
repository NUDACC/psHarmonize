library(dplyr)
library(psHarmonize)


# Testing for previous dataset; one input item ---------

to_add <- harmonization_sheet_example[1,] %>%
  mutate(id_var = 'ID',
         item = 'weight_mod',
         source_item = 'weight',
         source_dataset = 'previous_dataset',
         subdomain = 'weight_mod',
         code1 = 'x**2',
         code_type = 'function',
         coding_notes = 'testing',
         possible_range = '')

harmonization_sheet_example_mod <- bind_rows(harmonization_sheet_example, to_add)


## Testing expect error NA
## This tests that function runs without error

test_that('Testing harmonized items using previous variables (one item)', {

  expect_error(harmonization(harmonization_sheet = harmonization_sheet_example_mod, long_dataset = TRUE, wide_dataset = TRUE, error_log = TRUE, source_variables = TRUE), NA)

})




# Testing for previous dataset; two input items ---------

to_add <- harmonization_sheet_example[1,] %>%
  mutate(id_var = 'ID',
         item = 'bmi',
         source_item = 'weight; height',
         source_dataset = 'previous_dataset',
         subdomain = 'bmi',
         code1 = 'x1 / ((x2 / 100)**2)',
         code_type = 'function',
         coding_notes = 'testing',
         possible_range = '')

harmonization_sheet_example_mod <- bind_rows(harmonization_sheet_example, to_add)

## Testing expect error NA
## This tests that function runs without error

test_that('Testing harmonized items using previous variables (two items)', {

  expect_error(harmonization(harmonization_sheet = harmonization_sheet_example_mod, long_dataset = TRUE, wide_dataset = TRUE, error_log = TRUE, source_variables = TRUE), NA)

})
