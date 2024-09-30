library(psHarmonize)

# Creating some test data -------------

# Introducing incorrect idvar value
error_sheet <- harmonization_sheet_example
error_sheet[3,c('id_var')] <- 'id_var'

test_that(desc = 'Testing cohort shell function',
          {
            expect_message(object = cohort_shell_func(error_sheet), regexp = 'id_var: id_var in dataset: cohort_a not found')
          })
