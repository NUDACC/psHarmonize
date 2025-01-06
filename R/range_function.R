#' Range function. To be called by harmonization function.
#'
#' @param data Data to be modified
#' @param min_max_range Range of allowed values
#' @param new_var New variable
#'
#' @return Returns a list with the new vector (values outside of range set to NA), and the number of values set to NA.
#' @export
#'
#' @importFrom dplyr case_when
#'
#' @examples
#'
#' test_data <- data.frame(val = 1:10)
#'
#' range_function(data = test_data, min_max_range = '[2,8]', new_var = 'val')
#'
range_function <- function(data = temp_dataset,
                           min_max_range = possible_range,
                           new_var = item)
{

  temp_dataset <- NULL
  possible_range <- NULL
  item <- NULL

  ## Get numbers
  min_num <- stringr::str_extract(min_max_range, '[:digit:]+(?=,)') %>%
    as.numeric()

  max_num <- stringr::str_extract(min_max_range, '(?<=,)[:digit:]+') %>%
    as.numeric()


  ## Get directions

  direction_first <- stringr::str_extract(min_max_range, '^[:punct:]')

  direction_last <- stringr::str_extract(min_max_range, '[:punct:]$')

  convert <- function(input)
  {
    case_when(input == '[' ~ '>=',
              input == '(' ~ '>',
              input == ']' ~ '<=',
              input == ')' ~ '<'
    )
  }

  direction_first <- convert(direction_first)
  direction_last <- convert(direction_last)

  range_function2 <- function(input)
  {

    text_first <- paste0(input, ' ', direction_first, ' ', min_num)
    text_last <- paste0(input, ' ', direction_last, ' ', max_num)

    case_when(

      eval(parse(text = text_first)) &
        eval(parse(text = text_last))
      ~ input

    )

  }

  new_value <- sapply(data[[new_var]], range_function2)



  ## Recording the number of values set to missing in error log

  orig_na <- sum(is.na(data[[new_var]]))

  new_value_na <- sum(is.na(new_value))

  ## Saving items into list, then return list

  range_result_list <- list(new_value = new_value,
                            range_set_to_na = (new_value_na - orig_na))

  return(range_result_list)

}



#' Possible values for categorical variables. To be called by harmonization function.
#'
#' @param data data to be modified
#' @param possible_vals_cat vector of possible values
#' @param new_var new variable
#'
#' @return Returns a list with the new vector (values outside of set to NA), and the number of values set to NA.
#' @export
#'
#' @examples
#'
#' test_data <- data.frame(val = c('a','b','j','k','c','d'))
#'
#' range_function_cat(data = test_data, possible_vals_cat = c('a','b','c','d'), new_var = 'val')
#'
range_function_cat <- function(data = temp_dataset,
                               possible_vals_cat = possible_vals,
                               new_var = item)
{

  temp_dataset <- NULL
  possible_range <- NULL
  item <- NULL
  possible_vals <- NULL

  # Split string input to create vector
  possible_vals_cat_vector <- stringr::str_split(string = possible_vals_cat, pattern = ',')
  possible_vals_cat_vector <- unlist(possible_vals_cat_vector)
  possible_vals_cat_vector <- stringr::str_trim(string = possible_vals_cat_vector, side = 'both')

  new_value <- ifelse(data[[new_var]] %in% possible_vals_cat_vector, data[[new_var]], NA)

  ## Recording the number of values set to missing in error log
  orig_na <- sum(is.na(data[[new_var]]))
  new_value_na <- sum(is.na(new_value))

  ## Saving items into list, then return list
  range_cat_result_list <- list(new_value = new_value,
                                range_set_to_na = (new_value_na - orig_na))

  return(range_cat_result_list)

}

