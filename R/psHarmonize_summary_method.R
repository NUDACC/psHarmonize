#' psHarmonize summary method
#'
#' @param object psHarmonize object
#' @param ... Can provide additional arguments
#' @param verbose T/F. When TRUE, will list variables for each section.
#'
#' @return Doesn't return object. Prints status of harmonization (# of harmonizated variables, etc.)
#' @export
#'
#' @examples
#'
#' harmonization_obj <- harmonization(harmonization_sheet_example)
#'
#' summary(harmonization_obj)
#'
#' # Use verbose option to see more details
#' summary(harmonization_obj, verbose = TRUE)
#'
summary.psHarmonize <- function(object, ..., verbose = FALSE)
{

  error_log <- object$error_log

  num_total_rows <- nrow(error_log)

  num_rows_completed <- nrow(error_log[error_log$completed_status == 'Completed' & !is.na(error_log$completed_status),])

  num_rows_not_completed <- nrow(error_log[error_log$completed_status == 'Not completed' & !is.na(error_log$completed_status),])

  # Possible range rows, for numeric

  # total rows with non missing possible range
  # will use as denominator
  num_total_possible_range_num <- error_log %>%
    filter(!is.na(possible_range) & possible_range != '') %>%
    filter(stringr::str_detect(string = possible_range, pattern = '[\\[\\(\\]\\)]')) %>%
    summarise(n = n()) %>%
    pull(n)

  # rows with non missing possible range, with > 0 values set to NA
  # will use as numerator
  num_na_possible_range_num <- error_log %>%
    filter(!is.na(possible_range) & possible_range != '') %>%
    filter(stringr::str_detect(string = possible_range, pattern = '[\\[\\(\\]\\)]')) %>%
    filter(range_set_to_na > 0) %>%
    summarise(n = n()) %>%
    pull(n)


  # Possible range rows, for categorical


  # total rows with non missing possible range
  # will use as denominator
  num_total_possible_range_cat <- error_log %>%
    filter(!is.na(possible_range) & possible_range != '') %>%
    filter(stringr::str_detect(string = possible_range, pattern = '[\\[\\(\\]\\)]', negate = TRUE)) %>%
    summarise(n = n()) %>%
    pull(n)

  # rows with non missing possible range, with > 0 values set to NA
  # will use as numerator
  num_na_possible_range_cat <- error_log %>%
    filter(!is.na(possible_range) & possible_range != '') %>%
    filter(stringr::str_detect(string = possible_range, pattern = '[\\[\\(\\]\\)]', negate = TRUE)) %>%
    filter(range_set_to_na > 0) %>%
    summarise(n = n()) %>%
    pull(n)

  cat('# Harmonization status ----------------------------')
  cat('\n\n')

  cat('\n')
  cat('## Successfully harmonized ------------------------','\n')
  cat('\n')

  cat('Number of rows in harmonization sheet successfully harmonized: ', '\n', num_rows_completed, '/', num_total_rows, '\n')
  cat('\n')

  if(verbose && num_rows_completed > 0)
  {

    cat('Variables that were successfully harmonized:','\n')
    cat('\n')

    harmonized_success <- error_log %>%
      filter(completed_status == 'Completed')

    for(i in seq(1,nrow(harmonized_success)))
    {
      print(harmonized_success[i,c('item','study','visit','completed_status')])
      cat('\n')
    }

  }

  cat('\n')
  cat('## NOT successfully harmonized --------------------','\n')
  cat('\n')


  cat('Number of rows in harmonization sheet NOT successfully harmonized: ', '\n', num_rows_not_completed, '/', num_total_rows, '\n')
  cat('\n')

  if(verbose && num_rows_not_completed > 0)
  {

    cat('Variables that were NOT successfully harmonized:','\n')
    cat('\n')

    harmonized_not_success <- error_log %>%
      filter(completed_status == 'Not completed')

    for(i in seq(1,nrow(harmonized_not_success)))
    {
      print(harmonized_not_success[i,c('item','study','visit','completed_status','completed_reason')])
      cat('\n')
    }

  }

  cat('\n')
  cat('# Values outside of range -------------------------')
  cat('\n\n')

  cat('\n')
  cat('## Numeric variables ------------------------------','\n')
  cat('\n')

  cat('Number of numeric rows with values set to NA: ', '\n', num_na_possible_range_num, '/', num_total_possible_range_num, '\n')
  cat('\n')

  if(verbose && num_na_possible_range_num > 0)
  {

    cat('Variables with values out of range (numeric):','\n')
    cat('\n')

    out_of_range_num <- error_log %>%
      filter(!is.na(possible_range) & possible_range != '') %>%
      filter(stringr::str_detect(string = possible_range, pattern = '[\\[\\(\\]\\)]')) %>%
      filter(range_set_to_na > 0)

    for(i in seq(1,nrow(out_of_range_num)))
    {
      print(out_of_range_num[i,c('item','study','visit','possible_range','range_set_to_na')])
      cat('\n')
    }

  }

  cat('\n')
  cat('## Categorical variables --------------------------','\n')
  cat('\n')

  cat('Number of categorical rows with values set to NA: ', '\n', num_na_possible_range_cat, '/', num_total_possible_range_cat, '\n')
  cat('\n')

  if(verbose && num_na_possible_range_cat > 0)
  {

    cat('Variables with values out of range (categorical):','\n')
    cat('\n')

    out_of_range_cat <- error_log %>%
      filter(!is.na(possible_range) & possible_range != '') %>%
      filter(stringr::str_detect(string = possible_range, pattern = '[\\[\\(\\]\\)]', negate = TRUE)) %>%
      filter(range_set_to_na > 0)

    for(i in seq(1,nrow(out_of_range_cat)))
    {
      print(out_of_range_cat[i,c('item','study','visit','possible_range','range_set_to_na')])
      cat('\n')
    }

  }

}
