##
## Creating_example_data.R
##
## 1/6/2022
##
## Creating some fake datasets to harmonize
##

library(dplyr)

set.seed(seed = 20220106)

# Create three "cohorts" -----------

## Create the following variables:
##
## - ID
## - Age
## - Sex
## - Height
## - Weight
## - Education



## Cohort a ---------


### Visit 1 ---------

idvar <- seq.int(1001, 11000, 1) %>%
  as.character()


ages <- rnorm(10000, mean = 55, sd = 1) %>%
  floor()

sex <- runif(10000, min = 0, max = 1)

# 0 = Female, 1 = Male
sex <- case_when(
  sex < 0.5 ~ 0,
  sex >= 0.5 ~ 1
)


height <- rnorm(10000, mean = 65, sd = 1)

weight <- rnorm(10000, mean = 160, sd = 1)

education <- runif(10000, min = 1, max = 6)

education <- floor(education)


cohort_a_v1 <- bind_cols('idvar' = idvar,
                  'age' = ages,
                  'height_1' = height,
                  'weight_1' = weight,
                  'education' = education)



### Visit 2 ---------

height <- rnorm(10000, mean = 65, sd = 1)

weight <- rnorm(10000, mean = 160, sd = 1)

cohort_a_v2 <- bind_cols('idvar' = idvar,
                         'height_2' = height,
                         'weight_2' = weight)

### Visit 3 ---------

set.seed(seed = 202201063)

height <- rnorm(10000, mean = 65, sd = 1)

weight <- rnorm(10000, mean = 160, sd = 1)

cohort_a_v3 <- bind_cols('idvar' = idvar,
                         'height_3' = height,
                         'weight_3' = weight)


## Combine --------

cohort_a <- cohort_a_v1 %>%
  left_join(cohort_a_v2, by = 'idvar') %>%
  left_join(cohort_a_v3, by = 'idvar')


## Cohort b ---------

idvar <- seq.int(2543, (2543 + 4999), 1) %>%
  as.character()


ages <- rnorm(5000, mean = 75, sd = 1) %>%
  floor()

sex <- runif(5000, min = 0, max = 1)

sex <- case_when(
  sex < 0.5 ~ 'F',
  sex >= 0.5 ~ 'M'
)


height <- rnorm(5000, mean = 70, sd = 1)

weight <- rnorm(5000, mean = 68, sd = 1)

education <- runif(5000, min = 1, max = 5)

education <- floor(education)


cohort_b <- bind_cols('ID' = idvar,
                      'Age' = ages,
                      'hgt_in' = height,
                      'wgt_kg' = weight,
                      'edu_cat' = education)



## Cohort c ---------


idvar <- seq.int(1054, (1054 + 6999), 1) %>%
  as.character()


ages <- rnorm(7000, mean = 75, sd = 1) %>%
  floor()

sex <- runif(7000, min = 0, max = 1)

sex <- case_when(
  sex < 0.5 ~ 'F',
  sex >= 0.5 ~ 'M'
)


height <- rnorm(7000, mean = 179, sd = 1)

weight <- rnorm(7000, mean = 165, sd = 1)

education <- runif(7000, min = 1, max = 4)

education <- floor(education)

# education <- case_when(
#   education == 1 ~ 'No education',
#   education == 2 ~ 'High school',
#   education == 3 ~ 'College',
#   education == 4 ~ 'Graduate/Professional'
# )


cohort_c <- bind_cols('cohort_id' = idvar,
                      'age' = ages,
                      'height_cm' = height,
                      'weight_lbs' = weight,
                      'edu' = education)


# Looking at data -----------

head(cohort_a)

head(cohort_b)

head(cohort_c)


usethis::use_data(cohort_a)
usethis::use_data(cohort_b)
usethis::use_data(cohort_c)
