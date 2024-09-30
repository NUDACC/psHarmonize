#' Create long dataset. To be called by harmonization function.
#'
#' @param vars_interest Variable currently being harmonized
#' @param subdomain Category of variable
#' @param previous_dataset Dataframe created so far
#' @param error_log Error log
#' @param na_string Character string of final recode value to be set to NA.
#'
#' @importFrom dplyr rename mutate starts_with bind_rows
#' @importFrom rlang :=
#'
#' @return Returns a list with the harmonized long dataset, and error log.
#' @export
#'
#' @examples
#'
create_long_dataset <- function(vars_interest, subdomain, previous_dataset, error_log, na_string)
{

  vars_interest <- vars_interest[vars_interest$item == subdomain,]

  counter <- 1

  ## Loop through rows
  for(current_row in 1:nrow(vars_interest))
  {

    cohort <- vars_interest[current_row,][['study']]

    print(glue::glue('Currently on item: {subdomain}; cohort: {cohort}; visit {vars_interest[current_row,][["visit"]]} / {max(vars_interest[vars_interest$study == vars_interest[current_row,][["study"]],][["visit"]])}.'))

    ## Getting values from harmonization sheet

    ## Source dataset name
    source_dataset <- vars_interest[current_row,][['source_dataset']]

    ## Source variable name
    source_item <- vars_interest[current_row,][['source_item']]

    ## ID variable for this cohort
    id_var <- vars_interest[current_row,][['id_var']]

    ## Check to see if there are multiple variables (check for semi colon)
    ## If there are multiple variables, split into list
    if(grepl(';',source_item))
    {

      source_item <- stringr::str_split(source_item, ';')[[1]] %>%
        stringr::str_trim()

    }


    ## New variable name
    item <- vars_interest[current_row,][['item']]

    ## New name for source variable name
    ## Renaming in order to create long dataset
    source_item_long <- paste0('source_',item)


    #print(source_item_long)

    ## Coding instructions
    code_instruct <- vars_interest[current_row,][['code1']]

    ## Code type
    code_type <- vars_interest[current_row,][['code_type']]

    # Keep first character (f for function, r for recode)

    code_type <- stringr::str_trim(code_type)

    code_type <- tolower(code_type)

    code_type <- substr(code_type, 1, 1)


    ## Possible range
    possible_range <- vars_interest[current_row,][['possible_range']]



    ## Data manipulation

    ## get dataset and variable

    ## Error handling

    # error_dataset <- FALSE
    #
    # tryCatch(
    #  expr =
    #    {
    #      temp_dataset <- get(source_dataset)
    #    },
    #  error = function(e)
    #  {
    #    error_dataset <<- TRUE
    #  }
    # )
    #
    # ## See if dataset exists
    # if(error_dataset == TRUE) { next }


    if(exists(source_dataset) == FALSE)
    {
      print('Dataset not found')

      error_log[error_log$item == subdomain,][current_row,c('completed_status')] <- 'Not completed'
      error_log[error_log$item == subdomain,][current_row,c('completed_reason')] <- 'Dataset not found'

      next
    } else if(source_dataset == 'previous_dataset')
    {


      curr_cohort <- cohort

      temp_dataset <- previous_dataset %>%
        filter(visit == vars_interest[current_row,][['visit']] & cohort == curr_cohort)


    } else
    {

      temp_dataset <- get(source_dataset)

    }

    ## Keeping variables of interest

    # Checking for presence of variable name

    for(j in 1:length(source_item))
    {

      var_exists <- TRUE

      if(!(source_item[[j]] %in% names(temp_dataset)))
      {

        print('Variable not found')

        error_log[error_log$item == subdomain,][current_row,c('completed_status')] <- 'Not completed'
        error_log[error_log$item == subdomain,][current_row,c('completed_reason')] <- 'Variable not found'

        var_exists <- FALSE
      }

      if(var_exists == FALSE) {break}

    }

    if(var_exists == FALSE) {next}

    # Checking for id_var in dataset
    if(!(id_var %in% names(temp_dataset)))
    {
      message(paste0('id_var: ', id_var, ' not found in dataset.'))

      error_log[error_log$item == subdomain,][current_row,c('completed_status')] <- 'Not completed'
      error_log[error_log$item == subdomain,][current_row,c('completed_reason')] <- 'id_var not found'

      next
    }

    temp_dataset <- temp_dataset[,c(id_var,source_item)]


    # if(!(source_item %in% names(temp_dataset)))
    # {
    #
    #   print('Variable not found')
    #
    #   # error_log[error_log$subdomain == subdomain,][current_row,c('completed_status')] <- 'Not completed'
    #   # error_log[error_log$subdomain == subdomain,][current_row,c('completed_reason')] <- 'Variable not found'
    #
    #   error_log[current_row,c('completed_status')] <- 'Not completed'
    #   error_log[current_row,c('completed_reason')] <- 'Variable not found'
    #
    #   next
    # } else
    # {
    #
    #   temp_dataset <- temp_dataset[,c(id_vars[[cohort]],source_item)]
    #
    # }

    #print(head(temp_dataset))


    ## Rename variable of interest
    temp_dataset <- temp_dataset %>%
      rename({{source_item_long}} := {{source_item}})



    # if (length(source_item) == 1)
    # {
    #   temp_dataset <- temp_dataset %>%
    #     rename({{source_item_long}} := {{source_item}})
    # }
    # else if (length(source_item) > 1)
    # {
    #
    #   for (current_row in 1:length(source_item))
    #   {
    #
    #     new_var_name <- paste0(source_item_long, "_", i)
    #
    #     old_var_name <- source_item[[i]]
    #
    #     temp_dataset <- temp_dataset %>%
    #       rename({{new_var_name}} := {{old_var_name}})
    #
    #   }
    #
    # }


    ## Assign visit column
    temp_dataset$visit <- vars_interest[current_row,][['visit']]

    ## Assign cohort column
    temp_dataset$cohort <- cohort


    ## Modify values
    ## Use code type to determine what code to use
    ## function vs categorical for example


    ## Check number of arguments
    num_arguments <- stringr::str_count(code_instruct, pattern = 'x[:digit:]+')


    ## If no change is needed assign old value to new column
    if (is.na(code_type) | is.na(code_instruct) | code_type == '')
    {
      temp_dataset[,item] <- temp_dataset[,source_item_long]
    }


    else if (code_type == 'f' & num_arguments > 1)
    {

      temp_dataset[,item] <- code_modify_func_multi(temp_dataset,
                                                    code_instruct,
                                                    source_item_long,
                                                    user_args = source_item,
                                                    sourcedataset = source_dataset,
                                                    subdomain = subdomain,
                                                    cohort = cohort,
                                                    visit = vars_interest[current_row,][['visit']])


      # Recode source items to character, if new item is character


      # if(is.character(temp_dataset[[item]]) && is.character(temp_dataset[[source_item_long]]) == FALSE)
      # {
      #
      #   temp_dataset[[source_item_long]] <- as.character(temp_dataset[[source_item_long]])
      #
      # }

    }

    else if (code_type == 'f')
    {

      temp_dataset[,item] <- code_modify_func(data = temp_dataset,
                                              instruction = code_instruct,
                                              old_var = source_item_long)

      # Recode source item to character, if new item is character

      if(is.character(temp_dataset[[item]]) && is.character(temp_dataset[[source_item_long]]) == FALSE)
      {

        temp_dataset[[source_item_long]] <- as.character(temp_dataset[[source_item_long]])

      }



    }

    else if (code_type == 'r')
    {


      # 6/29/2021 Convert to character
      #
      # Was causing issues previously because some values
      # were integers, while others were character

      if (is.character(temp_dataset[[source_item_long]]) == FALSE)
      {
        temp_dataset[[source_item_long]] <- as.character(temp_dataset[[source_item_long]])
      }


      temp_dataset[,item] <- code_modify_recode(temp_dataset,
                                                code_instruct,
                                                source_item_long,
                                                new_var = item,
                                                na_string = na_string)

      # Convert to character
      #temp_dataset[[source_item_long]] <- as.character(temp_dataset[[source_item_long]])

    }


    ## Possible range
    # Set values outside of range to NA

    if (!is.na(possible_range) & possible_range != '')
    {

      if (is.numeric(temp_dataset[[item]]))
      {

        range_result <- range_function(temp_dataset, possible_range, item)
        temp_dataset[,item] <- range_result[['new_value']]
        error_log[error_log$item == subdomain,][current_row,c('range_set_to_na')] <- range_result[['range_set_to_na']]

      } else if (is.character(temp_dataset[[item]]))
      {

        range_result <- range_function_cat(temp_dataset, possible_range, item)
        temp_dataset[,item] <- range_result[['new_value']]
        error_log[error_log$item == subdomain,][current_row,c('range_set_to_na')] <- range_result[['range_set_to_na']]

      }

    }


    # Rename ID variable
    if (id_var != 'ID')
    {

      num_to_rename <- which(names(temp_dataset) == id_var)
      names(temp_dataset)[num_to_rename] <- 'ID'

    }

    temp_dataset <- temp_dataset %>%
      mutate(ID = as.character(ID))

    ## Add rows to previous dataset

    if(counter == 1){

      final_dataset <- temp_dataset


    } else if(counter > 1){

      ## Change old variable to character if new value is character
      if (
        (
          (is.character(temp_dataset[[source_item_long]]) == FALSE & is.character(temp_dataset[[item]])) |
          (is.character(final_dataset[[source_item_long]]) & is.character(temp_dataset[[source_item_long]]) == FALSE)
        ) &
        (is.na(num_arguments) | num_arguments %in% c(0,1))
      )
      {
        temp_dataset[[source_item_long]] <- as.character(temp_dataset[[source_item_long]])
      }


      # Convert to character as needed for final dataset
      names_to_check <- unique(c(names(final_dataset), names(temp_dataset)))

      for(i in 1:length(names_to_check))
        {

        current_var_name <- names_to_check[[i]]

        if(mode(final_dataset[[current_var_name]]) != mode(temp_dataset[[current_var_name]]))
        {

          # Old dataset char, new dataset numeric

          if(mode(final_dataset[[current_var_name]]) == 'character' &&
             mode(temp_dataset[[current_var_name]]) == 'numeric')
          {

            temp_dataset[[current_var_name]] <- as.character(temp_dataset[[current_var_name]])

          } else if (mode(final_dataset[[current_var_name]]) == 'numeric' &&
                     mode(temp_dataset[[current_var_name]]) == 'character')
          {

            final_dataset[[current_var_name]] <- as.character(final_dataset[[current_var_name]])

          }

        } else if (
            (
              ('Date' %in% class(final_dataset[[current_var_name]])) &&
              !('Date' %in% class(temp_dataset[[current_var_name]]))
            ) ||
            (
              !('Date' %in% class(final_dataset[[current_var_name]])) &&
              ('Date' %in% class(temp_dataset[[current_var_name]]))
            )

          )
        {

          final_dataset[[current_var_name]] <- as.character(final_dataset[[current_var_name]])

          temp_dataset[[current_var_name]] <- as.character(temp_dataset[[current_var_name]])

        }

      }

      # rbind with final dataset
      final_dataset <- bind_rows(final_dataset, temp_dataset)

    }

    counter <- counter + 1

    error_log[error_log$item == subdomain,][current_row,c('completed_status')] <- 'Completed'

  }

  return_list <- list()

  ## Returning dataset

  if(exists('final_dataset'))
  {
    return_list$final_dataset <- final_dataset
  }

  if(exists('error_log'))
  {
    return_list$error_log <- error_log
  }

  return(return_list)

}


