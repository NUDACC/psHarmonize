#' Error log report creation
#'
#' @description
#' This function will create an RMarkdown error log. It takes the harmonization
#' object as the input, and will knit an RMarkdown html file to the path
#' specified.
#'
#' **Note:** The error log will only be able to detect "processing" errors, and
#' not "content" errors. For example, if the user enters coding instructions
#' that are nonsensical or incorrect, but are still able to be executed, this
#' function will not be able to detect it.
#'
#' @param harmonization_object Harmonization object
#' @param path Path of output R Markdown report
#' @param file Filename of output R Markdown report
#'
#' @return
#' @export
#'
#' @examples
#'
create_error_log_report <- function(harmonization_object, path = './', file = 'error_log_report.html')
{
  rmarkdown_file_path <- system.file('Rmd','error_log_report.Rmd', package = "psHarmonize")

  rmarkdown::render(input = rmarkdown_file_path, output_dir = path, output_file = file, params = list(error_log = harmonization_object$error_log))
}
