
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
#> 182                      182  0.3212805              1
#> 323                      323 -1.1898498              2
#> 962                      962  2.3838091              3
#> 397                      397 -0.2220511              4
#> 987                      987  2.3854219              5
#> 601                      601  1.0244089              6

#View some of the sampling frame
head(score_audit_num$output$sample_frame)
#>     sample_frame_sequence_id      score random_numbers
#> 182                      182  0.3212805              1
#> 323                      323 -1.1898498              2
#> 962                      962  2.3838091              3
#> 397                      397 -0.2220511              4
#> 987                      987  2.3854219              5
#> 601                      601  1.0244089              6

#View some of the spares
head(score_audit_num$output$spares)
#>     sample_frame_sequence_id      score random_numbers
#> 830                      830  0.1888008            101
#> 436                      436 -0.3101811            102
#> 684                      684  0.6252793            103

#Compute the relative bias
relative_bias(score_audit_num, score)
#> [1] 3.292904
```
