#' Summary report creation
#'
#' @param harmonization_object Harmonization object
#' @param path Path of output R Markdown report
#' @param file Filename of output R Markdown report
#' @param compare Creates summary report with comparison of raw values with modified values
#'
#' @return Does not return an object, but instead knits html RMarkdown report to specified path and file name.
#' @export
#'
#' @examples
#'
#' # Examples not run
#'
#' # Creating harmonized object
#' # harmonized_obj <- harmonization(harmonization_sheet = harmonization_sheet_example)
#'
#' # Knitting summary report
#' # create_summary_report(harmonization_object = harmonized_obj, path = './', file = 'example_output.html)
#'
#' # Use `compare` option to create comparison summary report.
#' # create_summary_report(harmonization_object = harmonized_obj, path = './', file = 'example_output.html, compare = TRUE)
#'
#'
create_summary_report <- function(harmonization_object, path = './', file = 'summary_report.html', compare = FALSE)
{


  if(compare == TRUE)
  {

    rmarkdown_file_path <- system.file('Rmd','summary_compare_report.Rmd', package = "psHarmonize")

  } else if (compare == FALSE)
  {

    rmarkdown_file_path <- system.file('Rmd','summary_report.Rmd', package = "psHarmonize")

  }




  if(is.data.frame(harmonization_object) == FALSE && is.list(harmonization_object))
  {

    long_dataset <- harmonization_object$long_dataset

    harmonization_sheet <- harmonization_object$harmonization_sheet

  }

  rmarkdown::render(input = rmarkdown_file_path, output_dir = path, output_file = file, params = list(long_dataset = long_dataset, harmonization_sheet = harmonization_sheet))
}

