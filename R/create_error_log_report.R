#' Error log report creation
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
