% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/factor_reorder_function.R
\name{reorder_factors_df}
\alias{reorder_factors_df}
\title{Reorder factors data.frame}
\usage{
reorder_factors_df(data, sheet)
}
\arguments{
\item{data}{Harmonized data.frame}

\item{sheet}{Factor reorder sheet}
}
\value{
Returns harmonized data.frame.
}
\description{
Reorder factors data.frame
}
\examples{

# Creating example dataframe of variables, the order, and the values
# The function will reorder the factor using these values in the order
# provided.

# This would typically be created in an excel or CSV file outside of R,
# and then imported into R.
test_sheet <- data.frame(
  variable = c(rep('Education',4),rep('Class',3)),
  order = c(1,2,3,4,1,2,3),
  values = c('None','Grade','HS','College','A','B','C')
)

# I'm creating some test data to demonstrate
set.seed(1234)
test_data <- data.frame(
  ID = 1:20,
  Education = sample(c('None','Grade','HS','College'), size = 20, replace = TRUE),
  Class = sample(c('A','B','C'), size = 20, replace = TRUE)
)

# Creating factors in the test data
test_data$Education <- factor(test_data$Education)
test_data$Class <- factor(test_data$Class)

table(test_data$Education, useNA = 'ifany')
table(test_data$Class, useNA = 'ifany')


# Now reordering factors based on the sheet
test_data_mod <- reorder_factors_df(data = test_data, sheet = test_sheet)

table(test_data_mod$Education, useNA = 'ifany')
table(test_data_mod$Class, useNA = 'ifany')

}
