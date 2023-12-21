#' Harmonization Function
#'
#' This is the main function in the psHarmonize package. Takes a harmonization
#' sheet as input, and returns a harmonization object (list with S3 class of
#' 'psHarmonize'). Requires source data.frames to be in the global environment.
#'
#' **Note:** psHarmonize evaluates and runs code entered in the harmonization sheet.
#' Make sure to only use harmonization sheets from authors you trust.
#'
#' @param harmonization_sheet Harmonization sheet input. Set of coding
#'   instructions
#' @param long_dataset (TRUE/FALSE) Should the function return a long dataset?
#' @param wide_dataset (TRUE/FALSE) Should the function return a wide dataset?
#' @param error_log (TRUE/FALSE) Should the function return an error log?
#' @param source_variables (TRUE/FALSE) Should the output datasets contain the original non
#'   modified values?
#' @param na_string Character string of final recode value to be set to missing.
#'   Default is 'NA'. For example, if you use `code_type` of 'recode', and some of
#'   your final values are 'NA', they will be set to missing.
#'
#' @return List of return objects with S3 class of 'psHarmonize'. Can be used
#'   as input for report function [create_summary_report()] and
#'   [create_error_log_report()].
#' @export
#'
#' @importFrom dplyr select filter group_by summarise pull n ungroup count
#'   starts_with all_of left_join relocate distinct
#'
#' @examples
#'
#' # Running harmonization function with example harmonization sheet
#' harmonization_obj <- harmonization(harmonization_sheet = harmonization_sheet_example)
#'
#' # Extracting harmonized long dataset (each row is a visit)
#' long_dataset <- harmonization_obj$long_dataset
#'
#' # Extracting harmonized wide dataset (each row is a person)
#' # Visits are expressed in multiple columns
#' wide_dataset <- harmonization_obj$wide_dataset
#'
#'
harmonization <- function(harmonization_sheet,
                          long_dataset = TRUE,
                          wide_dataset = TRUE,
                          error_log = TRUE,
                          source_variables = TRUE,
                          na_string = 'NA')
{

  # Warning prompt
  if(interactive())
  {
    cat("psHarmonize evaluates and runs code entered in the harmonization sheet.\n\n")

    menu_response <- utils::menu(choices = c('Yes','No'),
                                 title = "Do you trust the author of this harmonization sheet?")
    if (menu_response != 1)
    {
      stop("Exiting program")
    }
  }

  ## Checking input file

  ## Making sure one one row per grouping of:
  ##
  ## Study
  ## Visit
  ## Item

  max_row_per_group <- harmonization_sheet %>%
    group_by(study, item, visit) %>%
    summarise(n_rows = n()) %>%
    ungroup() %>%
    count(n_rows) %>%
    summarise(max_rows = max(n_rows)) %>%
    pull(max_rows)

  # stopifnot(max_row_per_group == 1)

  if (max_row_per_group > 1)
  {
    stop("Error: The harmonization sheet should only have one row per Study, visit, Item combination.")
  }

  ## Checking that code_type is entered correctly if there is code in code1:

  # num_rows_incorrectly_entered <- harmonization_sheet %>%
  #   filter((is.na(code1) == FALSE | code1 != '') & (!(code_type %in% c('function','recode category')))) %>%
  #   nrow()

  num_rows_incorrectly_entered <- harmonization_sheet %>%
    filter((is.na(code1) == FALSE | code1 != '') &
           (!(substr(tolower(stringr::str_trim(code_type)),1,1) %in% c('f','r')))) %>%
    nrow()

  if (num_rows_incorrectly_entered > 0)
  {
    stop("Error: There appears to be an error with code1 and/or code_type. Valid code_type values are \"function\" and \"recode\".")
  }


  # Creating "shell". This is a long dataset to merge on other elements
  # Visits that are not NA
  combined_long_dataset <- cohort_shell_func(sheet = harmonization_sheet[!is.na(harmonization_sheet$visit),])


  # Creating "shell" for time invariant dataset.

  combined_time_invariant <- combined_long_dataset %>%
    distinct(cohort, ID)

  # Creating error log

  error_log_dataset <- harmonization_sheet %>%
    select(item, study, visit, possible_range)

  error_log_dataset$completed_status <- NA_character_

  error_log_dataset$completed_reason <- NA_character_

  error_log_dataset$range_set_to_na <- NA_integer_

  error_log_dataset$range_out_of_range_warning <- NA



  # Loops through subdomain (variable)
  for(i in unique(harmonization_sheet$item)){


    intermediate_list <- create_long_dataset(vars_interest = harmonization_sheet,
                                        subdomain =  i,
                                        previous_dataset = combined_long_dataset,
                                        error_log = error_log_dataset,
                                        na_string = na_string)

    # Update error log
    error_log_dataset <- intermediate_list$error_log

    # Dataset for subdomain
    # For data with non missing visit
    intermediate <- intermediate_list$final_dataset 

    # Joining onto longitudinal dataset
    if(exists('intermediate') & !is.null(intermediate))
    {
      intermediate <- intermediate %>%
        filter(!is.na(visit))
      if(nrow(intermediate) > 0)
      {
        oldNrows=nrow(combined_long_dataset)
        combined_long_dataset <- combined_long_dataset %>%
          left_join(y = intermediate, by = c('cohort' = 'cohort', 'ID' = 'ID', 'visit' = 'visit')) %>%
          relocate(cohort, ID, visit)
        newNrows=nrow(combined_long_dataset)
        if(newNrows>oldNrows) {
          combined_long_dataset<<-combined_long_dataset
          intermediate <<- intermediate
          stop('Many-to-many merge detected; check data for duplicated IDs')
        }

      }
    }

    # Dataset for subdomain
    # For data with missing visit (time invariant)
    intermediate_time_invariant <- intermediate_list$final_dataset 

    # Joining onto time invariant dataset
    if(exists('intermediate_time_invariant') & !is.null(intermediate_time_invariant))
    {
      intermediate_time_invariant <- intermediate_time_invariant %>%
        filter(is.na(visit))
      if(nrow(intermediate_time_invariant) > 0)
      {
        combined_time_invariant <- combined_time_invariant %>%
          left_join(y = intermediate_time_invariant, by = c('cohort' = 'cohort', 'ID' = 'ID')) %>%
          select(-visit) %>%
          relocate(cohort, ID)

      }
    }

    if(i == unique(harmonization_sheet$item)[length(unique(harmonization_sheet$item))]) {print('Finished!')}

  }


  # Source variables

  if(source_variables == FALSE)
  {

    combined_long_dataset <- combined_long_dataset %>%
      select( - starts_with('source_'))

    combined_time_invariant <- combined_time_invariant %>%
      select( - starts_with('source_'))

  }



  # Returning objects

  num_return_objects <- sum(long_dataset, wide_dataset, error_log, 1)

  return_list <- list()

  # Long dataset
  if(long_dataset == TRUE)
  {
    return_list$long_dataset <- combined_long_dataset
  }


  # Wide dataset
  if(wide_dataset == TRUE)
  {

    vars_to_transform <- names(combined_long_dataset)[grepl('cohort|ID|visit',names(combined_long_dataset), ignore.case = TRUE) == FALSE]

    combined_wide_dataset <- combined_long_dataset %>%
      tidyr::pivot_wider(id_cols = c('cohort', 'ID'), names_from = 'visit', values_from = all_of(vars_to_transform))

    return_list$wide_dataset <- combined_wide_dataset

  }


  # Time invariant dataset
  if (nrow(combined_time_invariant) > 0)
  {
    return_list$time_invariant_dataset <- combined_time_invariant
  }


  # Error log
  if(error_log == TRUE)
  {
    return_list$error_log <- error_log_dataset
  }


  # Harmonization sheet
  return_list$harmonization_sheet <- harmonization_sheet

  # Return list
  # If object hasn't been returned yet, return list

  # Create psHarmonize class
  class(return_list) <- c('psHarmonize', class(return_list))

  return(return_list)

}
