#' Code modify function. To be called by the harmonization function.
#'
#' @param data Dataframe to be modified
#' @param instruction Coding instruction from harmonization sheet
#' @param old_var Name of original variable
#'
#' @return Vector of length equal to `old_var`
#' @export
#'
#' @examples
#'
#'# Allows the user to define a function with `instruction`
#'# The `old_var` in `data` will be used in place of `x` in `instruction`.
#'
#'code_modify_func(data = cohort_a, instruction = 'x + 5', old_var = 'age')
#'
code_modify_func <- function(data = temp_dataset,
                             instruction = code_instruct,
                             old_var = source_item_long)
{
  temp_dataset <- NULL
  code_instruct <- NULL
  source_item_long <- NULL

  ## Create function
  mod_function <- function(x){}

  body(mod_function) <- parse(text = instruction)

  ## Modify values using function
  return(mod_function(data[[old_var]]))

}
