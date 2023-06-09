#' Code modify function. To be called by the harmonization function.
#'
#' @param data Dataframe to be modified
#' @param instruction Coding instruction from harmonization sheet
#' @param old_var Name of original variable
#'
#' @return
#' @export
#'
#' @examples
#'
code_modify_func <- function(data = temp_dataset,
                             instruction = code_instruct,
                             old_var = source_item_long)
{

  ## Create function
  mod_function <- function(x){}

  body(mod_function) <- parse(text = instruction)

  ## Modify values using function
  return(mod_function(data[[old_var]]))

}
