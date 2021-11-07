
<!-- README.md is generated from README.Rmd. Please edit that file -->

# claimr

<!-- badges: start -->
<!-- badges: end -->

The goal of claimr is to streamline claim audits

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mncube/claimr")
```

## Example

``` r
#Load claimr
library(claimr)

#Generate sampling frame  with an index id from 1 to N
df_sample_frame_num <- data.frame("sample_frame_sequence_id" = 1:1000,
                                  "score" = rnorm(1000))

#Take a simple random sample from the sampling frame
#And return the output (sample, sample frame, spares) and input in lists
score_audit_num <- rs_singlestage(df = df_sample_frame_num,
                                  seed_number = 100,
                                  audit_review = "Score Audit",
                                  quantity_to_generate = 100,
                                  quantity_of_spares = 3,
                                  frame_low = 1,
                                  frame_high = 1000)

#View some of the samples
head(score_audit_num$output$sample)
#>     sample_frame_sequence_id      score random_numbers
#> 182                      182 0.70608872              1
#> 323                      323 0.02439735              2
#> 962                      962 1.33277511              3
#> 397                      397 0.12652721              4
#> 987                      987 0.37722300              5
#> 601                      601 0.46760209              6

#View some of the sampling frame
head(score_audit_num$output$sample_frame)
#>     sample_frame_sequence_id      score random_numbers
#> 182                      182 0.70608872              1
#> 323                      323 0.02439735              2
#> 962                      962 1.33277511              3
#> 397                      397 0.12652721              4
#> 987                      987 0.37722300              5
#> 601                      601 0.46760209              6

#View some of the spares
head(score_audit_num$output$spares)
#>     sample_frame_sequence_id     score random_numbers
#> 830                      830 -1.542488            101
#> 436                      436 -0.699992            102
#> 684                      684  1.447209            103

#Compute the relative bias
relative_bias(score_audit_num, score)
#> [1] 1.058029
```

## Get information for RAT-STATS Unrestricted Variable Appraisals

``` r
#Get info
uva_info <- gi_unrestricted_variable_appraisals(samp_obj = score_audit_num,
                                     data_file_format = c("Audited Values"),
                                     audited_values = score,
                                     sample_item_number = sample_frame_sequence_id)
#Look at the data_file
uva_info$audit_review
#> [1] "Score Audit"
uva_info$frame_size
#> [1] 1000
uva_info$sample_size
#> [1] 100
uva_info$data_file_format
#> [1] "Audited Values"
head(uva_info$data_file)
#>   sample_item_number audited_values
#> 1                182     0.70608872
#> 2                323     0.02439735
#> 3                962     1.33277511
#> 4                397     0.12652721
#> 5                987     0.37722300
#> 6                601     0.46760209

#Export data file needed to process "Audited Values" Unrestricted Variable Appraisals in RAT-STATS
rs_uva <- uva_info$data_file
#write.table(rs_uva, sep=",",  col.names=FALSE)
```
