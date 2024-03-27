##
## Creating_error_example_harmonization_sheet.R
##
## Creating a harmonization sheet with errors to demonstrate the error log report.
##

library(dplyr)

## Creating the following columns:


## item
## study
## domain
## subdomain
## source_dataset
## source_item
## visit
## source_labels
## code1
## code_type
## coding_notes
## possible_range
## source_code_mapping
## source_units
## final_units
## notes


# Instructions for cohort a ---------------



## Age --------


harm_sheet_cohort_a <- data.frame()

to_add <- data.frame(
  id_var= 'idvar',
  item = 'age',
  study = 'Cohort A',
  domain = 'Demographics',
  subdomain = 'Age',
  source_dataset = 'cohort_a',
  source_item = 'age',
  visit = 1,
  code1 = NA_character_,
  code_type = NA_character_,
  coding_notes = 'No change needed',
  possible_range = NA_character_

)

harm_sheet_cohort_a <- bind_rows(harm_sheet_cohort_a, to_add)

## Height -----------

to_add <- data.frame(
  id_var= 'idvar',
  item = 'height',
  study = 'Cohort A',
  domain = 'Demographics',
  subdomain = 'Height',
  source_dataset = 'cohort_a',
  source_item = 'height_1',
  visit = 1,
  code1 = 'x * 2.54',
  code_type = 'function',
  coding_notes = 'Convert from inches to cm',
  possible_range = NA_character_

)

harm_sheet_cohort_a <- bind_rows(harm_sheet_cohort_a, to_add)



to_add <- data.frame(
  id_var= 'idvar',
  item = 'height',
  study = 'Cohort A',
  domain = 'Demographics',
  subdomain = 'Height',
  source_dataset = 'cohort_a',
  source_item = 'height_2',
  visit = 2,
  code1 = 'x * 2.54',
  code_type = 'function',
  coding_notes = 'Convert from inches to cm',
  possible_range = NA_character_

)

harm_sheet_cohort_a <- bind_rows(harm_sheet_cohort_a, to_add)



to_add <- data.frame(
  id_var= 'idvar',
  item = 'height',
  study = 'Cohort A',
  domain = 'Demographics',
  subdomain = 'Height',
  source_dataset = 'cohort_a',
  source_item = 'height_3',
  visit = 3,
  code1 = 'x * 2.54',
  code_type = 'function',
  coding_notes = 'Convert from inches to cm',
  possible_range = NA_character_

)

harm_sheet_cohort_a <- bind_rows(harm_sheet_cohort_a, to_add)

## Weight -------

# Error: using 'weight_v_1' as the source item, instead of 'weight_1'

to_add <- data.frame(
  id_var= 'idvar',
  item = 'weight',
  study = 'Cohort A',
  domain = 'Demographics',
  subdomain = 'Weight',
  source_dataset = 'cohort_a',
  source_item = 'weight_v_1',
  visit = 1,
  code1 = 'x / 2.205',
  code_type = 'function',
  coding_notes = 'Converting from lbs to kg',
  possible_range = NA_character_

)

harm_sheet_cohort_a <- bind_rows(harm_sheet_cohort_a, to_add)


to_add <- data.frame(
  id_var= 'idvar',
  item = 'weight',
  study = 'Cohort A',
  domain = 'Demographics',
  subdomain = 'Weight',
  source_dataset = 'cohort_a',
  source_item = 'weight_2',
  visit = 2,
  code1 = 'x / 2.205',
  code_type = 'function',
  coding_notes = 'Converting from lbs to kg',
  possible_range = NA_character_

)

harm_sheet_cohort_a <- bind_rows(harm_sheet_cohort_a, to_add)


to_add <- data.frame(
  id_var= 'idvar',
  item = 'weight',
  study = 'Cohort A',
  domain = 'Demographics',
  subdomain = 'Weight',
  source_dataset = 'cohort_a',
  source_item = 'weight_3',
  visit = 3,
  code1 = 'x / 2.205',
  code_type = 'function',
  coding_notes = 'Converting from lbs to kg',
  possible_range = NA_character_

)

harm_sheet_cohort_a <- bind_rows(harm_sheet_cohort_a, to_add)


## Education ---------


to_add <- data.frame(
  id_var= 'idvar',
  item = 'education',
  study = 'Cohort A',
  domain = 'Demographics',
  subdomain = 'Education',
  source_dataset = 'cohort_a',
  source_item = 'education',
  visit = 1,
  code1 = '1 = No education/grade school; 2 = No education/grade school; 3 = High school; 4 = High school; 5 = College; 6 = Graduate/Professional',
  code_type = 'recode category',
  coding_notes = 'Coding values to harmonized educational categories',
  possible_range = NA_character_
)


harm_sheet_cohort_a <- bind_rows(harm_sheet_cohort_a, to_add)


# Cohort b -----------


## Age --------

# Error: Using 'cohort_B' instead of 'cohort_b'

harm_sheet_cohort_b <- data.frame()

to_add <- data.frame(
  id_var= 'ID',
  item = 'age',
  study = 'Cohort B',
  domain = 'Demographics',
  subdomain = 'Age',
  source_dataset = 'cohort_B',
  source_item = 'Age',
  visit = 1,
  code1 = NA_character_,
  code_type = NA_character_,
  coding_notes = 'No change needed',
  possible_range = NA_character_

)

harm_sheet_cohort_b <- bind_rows(harm_sheet_cohort_b, to_add)

## Height -----------

# Using possible range as example

to_add <- data.frame(
  id_var= 'ID',
  item = 'height',
  study = 'Cohort B',
  domain = 'Demographics',
  subdomain = 'Height',
  source_dataset = 'cohort_b',
  source_item = 'hgt_in',
  visit = 1,
  code1 = 'x * 2.54',
  code_type = 'function',
  coding_notes = 'Convert from inches to cm',
  possible_range = '[150,180]'

)

harm_sheet_cohort_b <- bind_rows(harm_sheet_cohort_b, to_add)

## Weight -------


to_add <- data.frame(
  id_var= 'ID',
  item = 'weight',
  study = 'Cohort B',
  domain = 'Demographics',
  subdomain = 'Weight',
  source_dataset = 'cohort_b',
  source_item = 'wgt_kg',
  visit = 1,
  code1 = NA_character_,
  code_type = NA_character_,
  coding_notes = 'No change needed',
  possible_range = NA_character_

)

harm_sheet_cohort_b <- bind_rows(harm_sheet_cohort_b, to_add)


## Education ---------


to_add <- data.frame(
  id_var= 'ID',
  item = 'education',
  study = 'Cohort B',
  domain = 'Demographics',
  subdomain = 'Education',
  source_dataset = 'cohort_b',
  source_item = 'edu_cat',
  visit = 1,
  code1 = '1 = No education/grade school; 2 = High school; 3 = College; 4 = Graduate/Professional',
  code_type = 'recode category',
  coding_notes = 'Coding values to harmonized educational categories',
  possible_range = NA_character_
)


harm_sheet_cohort_b <- bind_rows(harm_sheet_cohort_b, to_add)




# Cohort c -----------


## Age --------


harm_sheet_cohort_c <- data.frame()

to_add <- data.frame(
  id_var= 'cohort_id',
  item = 'age',
  study = 'Cohort C',
  domain = 'Demographics',
  subdomain = 'Age',
  source_dataset = 'cohort_c',
  source_item = 'age',
  visit = 1,
  code1 = NA_character_,
  code_type = NA_character_,
  coding_notes = 'No change needed',
  possible_range = NA_character_

)

harm_sheet_cohort_c <- bind_rows(harm_sheet_cohort_c, to_add)

## Height -----------

to_add <- data.frame(
  id_var= 'cohort_id',
  item = 'height',
  study = 'Cohort C',
  domain = 'Demographics',
  subdomain = 'Height',
  source_dataset = 'cohort_c',
  source_item = 'height_cm',
  visit = 1,
  code1 = NA_character_,
  code_type = NA_character_,
  coding_notes = 'No change needed',
  possible_range = NA_character_

)

harm_sheet_cohort_c <- bind_rows(harm_sheet_cohort_c, to_add)

## Weight -------


to_add <- data.frame(
  id_var= 'cohort_id',
  item = 'weight',
  study = 'Cohort C',
  domain = 'Demographics',
  subdomain = 'Weight',
  source_dataset = 'cohort_c',
  source_item = 'weight_lbs',
  visit = 1,
  code1 = 'x / 2.205',
  code_type = 'function',
  coding_notes = 'Converted from lbs to kg',
  possible_range = NA_character_

)

harm_sheet_cohort_c <- bind_rows(harm_sheet_cohort_c, to_add)


## Education ---------

# Using possible range here for example

to_add <- data.frame(
  id_var= 'cohort_id',
  item = 'education',
  study = 'Cohort C',
  domain = 'Demographics',
  subdomain = 'Education',
  source_dataset = 'cohort_c',
  source_item = 'edu',
  visit = 1,
  code1 = '1 = Unknown; 2 = High school; 3 = College',
  code_type = 'recode category',
  coding_notes = 'Coding values to harmonized educational categories',
  possible_range = 'No education/grade school, High school, College'
)


harm_sheet_cohort_c <- bind_rows(harm_sheet_cohort_c, to_add)


# Combine -----------
error_harmonization_sheet_example <- bind_rows(harm_sheet_cohort_a, harm_sheet_cohort_b, harm_sheet_cohort_c)

# Saving ------------

usethis::use_data(error_harmonization_sheet_example)
