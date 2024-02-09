#' Continuous or categorical
#'
#' @param data Data frame
#' @param var Variable
#'
#' @return Returns "continuous" or "categorical"
#' @export
#'
#' @examples
#'
#' # Function can help determine which kind of output is
#' # most appropriate
#'
#'cont_or_cat(data = cohort_a, var = 'height_1')
#'
#'cont_or_cat(data = cohort_a, var = 'education')
#'
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
