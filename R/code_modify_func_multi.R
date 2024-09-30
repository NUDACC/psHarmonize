#' Code modify function (multiple variables). To be called by the harmonization function.
#'
#' @param data Dataframe to be modified
#' @param instruction Coding instruction from harmonization sheet
#' @param old_var Name of original variable
#' @param user_args Character vector of input variables
#' @param sourcedataset Dataframe created so far
#' @param subdomain Category of variable
#' @param visit Visit number
#' @param cohort Cohort name
#'
#' @return Vector of length equal to `old_var`
#' @export
#'
#' @examples
#'
#' # Example calculating BMI in cohort a for visit 1
#'
#' code_modify_func_multi(data = cohort_a,
#'                      instruction = '(x1 / 2.205)/((x2 / 39.37)**2)',
#'                      old_var = 'weight_1; height_1',
#'                      user_args = c('weight_1','height_1'),
#'                      sourcedataset = 'cohort_a',
#'                      subdomain = 'clinical',
#'                      visit = 1,
#'                      cohort = 'cohort_a')
#'
code_modify_func_multi <- function(data = temp_dataset,
                                   instruction = code_instruct,
                                   old_var = source_item_long,
                                   user_args = source_item,
                                   sourcedataset = source_dataset,
                                   subdomain = subdomain,
                                   visit = visit,
                                   cohort = cohort)
{
  ## Create empty function
  mod_function <- function(...){}


  user_args <- as.list(user_args)


  data_args <- list()

  if(sourcedataset == 'previous_dataset')
  {
    intermediate <- data %>%
      filter(visit == visit & cohort == cohort)


    # Renaming user args if previous dataset

    for(k in 1:length(user_args))
    {
      user_args[[k]] <- paste0('source_', subdomain, k)
    }


  } else {
    intermediate <- get(sourcedataset)
  }

  #intermediate <- get(sourcedataset)

  for(i in 1:length(user_args)){

    data_args[[i]] <- intermediate[[user_args[[i]] ]]

  }


  ## Replace x with ..
  ## R uses the ..# syntax to refer to an argument by position
  ## So ..1 means first argument, ..2 means second...

  func_text <- gsub(x = instruction,
                    pattern = 'x',
                    replacement = '..',
                    ignore.case = TRUE)


  ## Add text to body of function
  body(mod_function) <- parse(text = func_text)

  ## Call function with user args list
  return(do.call(mod_function, data_args))


}
