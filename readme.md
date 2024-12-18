
# psHarmonize
<hr>

(Ver. 0.3.2)

**psHarmonize** is an R package that facilitates harmonization of data from multiple different datasets.

The `harmonization()` function uses a **harmonization sheet** imported from .xlsx format as input into an R function.
This sheet catalogs variable names, domains (e.g. clinical, behavioral, outcomes), provides R code instructions for mapping or conversion of data, specifies the variable name in the harmonized data set, and tracks notes.

The R package allows the user to extract the harmonized data in the long and wide format.
The package also provides functions for report generation using the harmonized data.


## Installation
<hr>

The **psHarmonize** package can be installed from GitHub with the following command:

``` r
remotes::install_github("NUDACC/psHarmonize")
```

## Data modification
<hr>

Data modification can include:

- Numeric transformations to common units of measurement for continuous variables
- Mapping of categorical variables within individual data sets to a common set of study-wide values

## Report generation
<hr>

The package can create a few types of reports.

- Error log:
  - Gives statistics on how many variables were harmonized successfully and how many were not able to be harmonized
  - Displays reason variable was not able to be harmonized
- Summary report:
  - Knits Rmarkdown report showing summary statistics of harmonized data
- Summary comparison report:
  - Knits Rmarkdown report showing cross tabulations and comparisons of raw values and harmonized values
