#' Continuous or categorical
#'
#' @param data
#' @param var
#'
#' @return
#' @export
#'
#' @examples
cont_or_cat <- function(data, var)
{
  if(!(var %in% names(data)))
    stop('Variable not in dataset')

  if(is.numeric(data[[var]]) && length(unique(data[[var]])) > 10)
  {
    return_value <- 'continuous'
  } else if (is.numeric(data[[var]]) && length(unique(data[[var]])) <= 10)
  {
    return_value <- 'categorical'
  } else if (is.character(data[[var]]))
  {
    return_value <- 'categorical'
  }
  return(return_value)
}
