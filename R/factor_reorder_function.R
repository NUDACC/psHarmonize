#' Reorder factors
#'
#' @param data Harmonization object, or harmonized data.frame.
#' @param sheet Factor reorder sheet.
#'
#' @return Returns harmonization object, or harmonized data.frame.
#' @importFrom rlang .data
#' @export
#'
#' @examples
#'
#' # Running harmonization function with example harmonization sheet
#' harmonization_obj <- harmonization(harmonization_sheet = harmonization_sheet_example)
#'
#' long_dataset <- harmonization_obj$long_dataset
#'
#' table(long_dataset$education)
#'
#' # College
#' # 5643
#' #
#' # Graduate/Professional
#' # 1287
#' #
#' # High school
#' # 7562
#' #
#' # No education/grade school
#' # 7508
#'
#' # Creating factor reorder sheet
#' edu_order <- data.frame(
#'  variable = 'education',
#'  values = c('No education/grade school', 'High school', 'College', 'Graduate/Professional'),
#'  order = 1:4
#' )
#'
#' # Reorder factors
#' harmonization_obj <- reorder_factors(data = harmonization_obj, sheet = edu_order)
#'
#' long_dataset <- harmonization_obj$long_dataset
#'
#' table(long_dataset$education)
#'
#' # No education/grade school
#' # 7508
#' #
#' # High school
#' # 7562
#' #
#' # College
#' # 5643
#' #
#' # Graduate/Professional
#' # 1287
#'
#'
reorder_factors <- function(data, sheet)
{

  if ('psHarmonize' %in% class(data))
  {

    # Long dataset modification

    long_dataset <- data[['long_dataset']]

    long_dataset_mod <- reorder_factors_df(data = long_dataset, sheet = sheet)

    data[['long_dataset']] <- long_dataset_mod


    # Wide dataset modification
    harm_sheet <- data[['harmonization_sheet']]

    harm_items <- unique(harm_sheet[['item']])

    vars_to_modify <- unique(sheet[['variable']])

    # Variables not in harmonization sheet
    vars_not_in <- setdiff(vars_to_modify, harm_items)

    if (length(vars_not_in) > 0)
    {
      for(i in vars_not_in)
      {
        warning(paste0('Variable ', i, ' not in harmonization sheet.'))
      }
    }

    # Only keeping vars in harmonization sheet
    vars_to_modify <- intersect(vars_to_modify, harm_items)


    datasets_visits <- unique(harm_sheet[harm_sheet$item %in% vars_to_modify, c('visit', 'item')])

    datasets_visits$wide_vars <- paste(datasets_visits$item, datasets_visits$visit, sep = '_')

    # Create new sheet

    sheet_wide <- merge(x = sheet, y = datasets_visits, by.x = 'variable', by.y = 'item')

    sheet_wide <- sheet_wide[,c('wide_vars','values','order')]

    names(sheet_wide) <- c('variable','values','order')

    wide_dataset <- data[['wide_dataset']]

    wide_dataset_mod <- reorder_factors_df(data = wide_dataset, sheet = sheet_wide)

    data[['wide_dataset']] <- wide_dataset_mod

    # Return object
    return(data)

  } else if ('data.frame' %in% class(data))
  {

    to_return <- reorder_factors_df(data = data, sheet = sheet)

    return(to_return)

  } else
  {
    stop('Data must be a psHarmonize object or data.frame')
  }


}


#' Reorder factors data.frame
#'
#' @param data Harmonized data.frame
#' @param sheet Factor reorder sheet
#'
#' @importFrom dplyr arrange
#'
#' @return Returns harmonized data.frame.
#' @export
#'
#' @examples
#'
#' # Creating example dataframe of variables, the order, and the values
#' # The function will reorder the factor using these values in the order
#' # provided.
#'
#' # This would typically be created in an excel or CSV file outside of R,
#' # and then imported into R.
#' test_sheet <- data.frame(
#'   variable = c(rep('Education',4),rep('Class',3)),
#'   order = c(1,2,3,4,1,2,3),
#'   values = c('None','Grade','HS','College','A','B','C')
#' )
#'
#' # I'm creating some test data to demonstrate
#' set.seed(1234)
#' test_data <- data.frame(
#'   ID = 1:20,
#'   Education = sample(c('None','Grade','HS','College'), size = 20, replace = TRUE),
#'   Class = sample(c('A','B','C'), size = 20, replace = TRUE)
#' )
#'
#' # Creating factors in the test data
#' test_data$Education <- factor(test_data$Education)
#' test_data$Class <- factor(test_data$Class)
#'
#' table(test_data$Education, useNA = 'ifany')
#' table(test_data$Class, useNA = 'ifany')
#'
#'
#' # Now reordering factors based on the sheet
#' test_data_mod <- reorder_factors_df(data = test_data, sheet = test_sheet)
#'
#' table(test_data_mod$Education, useNA = 'ifany')
#' table(test_data_mod$Class, useNA = 'ifany')
#'
reorder_factors_df <- function(data, sheet)
{

  variable <- NULL
  values <- NULL

  for (current_var in unique(sheet$variable))
  {

    ## Checking if var is in data
    if (!(current_var %in% names(data)))
    {
      warning(paste0('Variable ', current_var, ' not in dataset.'))
      next
    }


    ## Checking for duplicate values
    value_vector <- sort(sheet[sheet$variable == current_var,][['values']])

    if (length(unique(value_vector)) != length(value_vector))
    {
      warning(paste0('Variable ', current_var, ' has duplicate values.'))
      next
    }


    ## Checking for duplicate order numbers
    order_vector <- sort(sheet[sheet$variable == current_var,][['order']])

    if (length(unique(order_vector)) != length(order_vector))
    {
      warning(paste0('Variable ', current_var, ' order has duplicate values.'))
      next
    }


    ## Get values in order
    factor_order <- sheet %>%
      filter(.data$variable == current_var) %>%
      arrange(.data$order) %>%
      pull(.data$values)


    ## Reorder factor
    data[[current_var]] <- factor(data[[current_var]], levels = factor_order)

  }

  ## Return df
  return(data)

}
