#' Cohort sheet create. To be called by harmonization function.
#'
#' Created dataframe "shell" of IDs, study/cohort name, and visit. Harmonized
#' variables will be joined onto this dataset.
#'
#' @param sheet Harmonization sheet
#'
#' @importFrom dplyr distinct bind_rows mutate
#'
#' @return Data.frame with IDs, study/cohort name, and visit.
#' @export
#'
#' @examples
#'
#' # Using example harmonization sheet
#' cohort_shell_func(harmonization_sheet_example)
#'
cohort_shell_func <- function(sheet)
{

  # Call function with data from harmonization sheet
  sheet <- sheet %>%
    filter(!(source_dataset == 'previous_dataset')) %>%
    distinct(source_dataset, id_var, study, visit)


  # Checking for dataset and id_var

  for(i in unique(sheet[['source_dataset']]))
  {

    if(exists(i) == FALSE)
    {

      sheet <- sheet %>%
        filter(!(source_dataset == i))
      message(paste0('Dataset ', i, ' not found'))

      next
    }

    for(j in unique(sheet[sheet$source_dataset == i,][['id_var']]))
    {

      if(!(j %in% names(get(i))))
      {

        sheet <- sheet %>%
          filter(!(source_dataset == i & id_var == j))
        message(paste0('id_var: ', j, ' in dataset: ', i, ' not found'))

      }

    }

  }


  # Using harmonization sheet as parameters in pmap
  input_list <- list(
    sheet[['source_dataset']],
    sheet[['id_var']],
    sheet[['study']],
    sheet[['visit']]
  )

  # Function that will retain ID and create visit number
  cohort_shell_func_2 <- function(data, id_var, cohort_var, visit_var)
  {

    intermediate <- get(data)

    intermediate <- intermediate %>%
      select(ID = id_var) %>%
      distinct() %>%
      mutate(cohort = cohort_var,
             visit = visit_var,
             ID = as.character(ID))

    return(intermediate)

  }

  # Calling function using input list as input values
  cohort_shell_list <- purrr::pmap(.l = input_list,
                            .f = ~ cohort_shell_func_2(data = ..1, id_var = ..2, cohort_var = ..3, visit_var = ..4))

  # Creating a dataframe from this list
  cohort_shell <- bind_rows(cohort_shell_list) %>%
    distinct()

  # Returning cohort shell
  return(cohort_shell)


}
