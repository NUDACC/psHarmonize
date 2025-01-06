
<!-- README.md is generated from README.Rmd. Please edit that file -->

# psHarmonize

<!-- badges: start -->
<!-- badges: end -->

**psHarmonize** is an R package that facilitates harmonization of data
from multiple different datasets.

The `harmonization()` function uses a **harmonization sheet** imported
from .xlsx format as input into an R function. This sheet catalogs
variable names, domains (e.g. clinical, behavioral, outcomes), provides
R code instructions for mapping or conversion of data, specifies the
variable name in the harmonized data set, and tracks notes.

The R package allows the user to extract the harmonized data in the long
and wide format. The package also provides functions for report
generation using the harmonized data.

## Installation

You can install the development version of psHarmonize from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("NUDACC/psHarmonize")
```

## Example

### Harmonization sheet

A harmonization sheet gives instructions to the `harmonization()`
function. It can be created in an excel spreadsheet, or within R as a
data.frame. It has a row for each combination of variable, cohort, and
visit.

An example harmonization sheet is provided with the package.

``` r
library(psHarmonize)
#> psHarmonize ver. 0.3.2
#> 
#> psHarmonize evaluates and runs code entered in the harmonization sheet.
#> Make sure to only use harmonization sheets from authors you trust.

head(harmonization_sheet_example)
#>   id_var   item    study       domain subdomain source_dataset source_item
#> 1  idvar    age Cohort A Demographics       Age       cohort_a         age
#> 2  idvar height Cohort A Demographics    Height       cohort_a    height_1
#> 3  idvar height Cohort A Demographics    Height       cohort_a    height_2
#> 4  idvar height Cohort A Demographics    Height       cohort_a    height_3
#> 5  idvar weight Cohort A Demographics    Weight       cohort_a    weight_1
#> 6  idvar weight Cohort A Demographics    Weight       cohort_a    weight_2
#>   visit     code1 code_type              coding_notes possible_range
#> 1     1      <NA>      <NA>          No change needed           <NA>
#> 2     1  x * 2.54  function Convert from inches to cm           <NA>
#> 3     2  x * 2.54  function Convert from inches to cm           <NA>
#> 4     3  x * 2.54  function Convert from inches to cm           <NA>
#> 5     1 x / 2.205  function Converting from lbs to kg           <NA>
#> 6     2 x / 2.205  function Converting from lbs to kg           <NA>
```

### Import source datasets

In order for the harmonization function to harmonize our data, the
source datasets must be read into the global environment of your R
session.

### Harmonize data

Once your harmonization sheet is created, and your data is loaded, you
can call the `harmonization()` function with the harmonization sheet as
the input.

(In the following example, the source datasets are already loaded with
the R package)

``` r

harmoniz_obj <- harmonization(harmonization_sheet = harmonization_sheet_example)
#> Currently on item: age; cohort: Cohort A; visit 1 / 1.
#> Currently on item: age; cohort: Cohort B; visit 1 / 1.
#> Currently on item: age; cohort: Cohort C; visit 1 / 1.
#> Currently on item: height; cohort: Cohort A; visit 1 / 3.
#> Currently on item: height; cohort: Cohort A; visit 2 / 3.
#> Currently on item: height; cohort: Cohort A; visit 3 / 3.
#> Currently on item: height; cohort: Cohort B; visit 1 / 1.
#> Currently on item: height; cohort: Cohort C; visit 1 / 1.
#> Currently on item: weight; cohort: Cohort A; visit 1 / 3.
#> Currently on item: weight; cohort: Cohort A; visit 2 / 3.
#> Currently on item: weight; cohort: Cohort A; visit 3 / 3.
#> Currently on item: weight; cohort: Cohort B; visit 1 / 1.
#> Currently on item: weight; cohort: Cohort C; visit 1 / 1.
#> Currently on item: education; cohort: Cohort A; visit 1 / 1.
#> Currently on item: education; cohort: Cohort B; visit 1 / 1.
#> Currently on item: education; cohort: Cohort C; visit 1 / 1.
#> [1] "Finished!"
#> 
#> # Harmonization status ----------------------------
#> 
#> 
#> ## Successfully harmonized ------------------------ 
#> 
#> Number of rows in harmonization sheet successfully harmonized:  
#>  16 / 16 
#> 
#> 
#> ## NOT successfully harmonized -------------------- 
#> 
#> Number of rows in harmonization sheet NOT successfully harmonized:  
#>  0 / 16 
#> 
#> 
#> # Values outside of range -------------------------
#> 
#> 
#> ## Numeric variables ------------------------------ 
#> 
#> Number of numeric rows with values set to NA:  
#>  0 / 0 
#> 
#> 
#> ## Categorical variables -------------------------- 
#> 
#> Number of categorical rows with values set to NA:  
#>  0 / 0
```

It will create an harmonization object, that will contain a long
harmonized dataset (rows for each visit), a wide harmonized dataset
(rows for each participant), the input harmonization sheet, and an error
log.

The harmonization sheet has an associated `summary()` method which gives
some general stats on whether the harmonization was successful.

``` r

summary(harmoniz_obj)
#> # Harmonization status ----------------------------
#> 
#> 
#> ## Successfully harmonized ------------------------ 
#> 
#> Number of rows in harmonization sheet successfully harmonized:  
#>  16 / 16 
#> 
#> 
#> ## NOT successfully harmonized -------------------- 
#> 
#> Number of rows in harmonization sheet NOT successfully harmonized:  
#>  0 / 16 
#> 
#> 
#> # Values outside of range -------------------------
#> 
#> 
#> ## Numeric variables ------------------------------ 
#> 
#> Number of numeric rows with values set to NA:  
#>  0 / 0 
#> 
#> 
#> ## Categorical variables -------------------------- 
#> 
#> Number of categorical rows with values set to NA:  
#>  0 / 0
```

### Extract dataset(s)

The harmonized dataset can then be extracted from the harmonization
object.

``` r

# Extracting long dataset
harmoniz_long_dataset <- harmoniz_obj$long_dataset

# Extracting wide dataset
harmoniz_wide_dataset <- harmoniz_obj$wide_dataset
```

### Create report(s)

There are a few types of reports that can be created from the
harmonization object.

#### Error log report

A report from the error log can be created with the
`create_error_log_report()` function. This function will create an html
file to the path specified.

#### Summary report

A summary report can be created in a similar manner with the
`create_summary_report()` function, This function will create
descriptive tables and plots of your harmonized data.

#### Summary compare report

If you want to see comparisons between the raw non-harmonized data, and
the harmonized data, you can use the argument `compare = TRUE` with the
`create_summary_report()` function.

## Reference Paper

Stephen JJ, Carolan P, Krefman AE, et al. psHarmonize: Facilitating
reproducible large-scale pre-statistical data harmonization and
documentation in R. Patterns (N Y). 2024;5(8):101003.
<doi:10.1016/j.patter.2024.101003>
