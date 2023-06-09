.onAttach <- function(libname, pkgname) {
  packageStartupMessage(paste0('psHarmonize ver. ', utils::packageVersion(pkg = 'psHarmonize'), '\n\n',
                               "psHarmonize evaluates and runs code entered in the harmonization sheet.\nMake sure to only use harmonization sheets from authors you trust."))
}
