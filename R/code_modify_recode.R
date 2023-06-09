#' Code modify recode.
#'
#' @param data Dataframe to be modified
#' @param instruction Coding instruction from harmonization sheet
#' @param old_var Name of original variable
#' @param new_var Name of new variable
#' @param na_string Character string of final recode value to be set to NA.
#'
#' @return
#' @export
#'
#' @examples
#'
code_modify_recode <- function(data = temp_dataset,
                               instruction = code_instruct,
                               old_var = source_item_long,
                               new_var = item,
                               na_string = NULL)
{

  # Create copy of variable to modify
  data[[new_var]] <- data[[old_var]]

  ## Get instructions

  ## Split by semi colon
  code_directions <- as.list(stringr::str_split(string = instruction, pattern = ";")[[1]])

  ## Get rid of trailing spaces
  code_directions <- purrr::map(code_directions, stringr::str_trim)

  ## Split by equals sign
  code_direction_2 <- stringr::str_split(string = code_directions, pattern = "=")

  ## Get rid of trailing spaces
  code_direction_2 <- purrr::map(code_direction_2, stringr::str_trim)

  recode_pairs <- code_direction_2

  ## Loop through instructions

  data[[new_var]] <- vapply(X = data[[old_var]], FUN = function(x){

    for (i in 1:length(recode_pairs))
    {

      if (x == recode_pairs[[i]][1] && !is.na(x))
      {
        return(recode_pairs[[i]][[2]])
      }

    }

    return(x)

  },
  FUN.VALUE = character(1),
  USE.NAMES = FALSE)

  # Set to NA if requested
  if (!is.na(na_string) && !is.null((na_string)))
  {
    data[[new_var]] <- ifelse(data[[new_var]] == na_string, NA_character_, data[[new_var]])
  }

  return(data[[new_var]])

}
