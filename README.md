
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
#> 182                      182 -0.2228876              1
#> 323                      323  1.2110544              2
#> 962                      962 -0.4987969              3
#> 397                      397 -0.4757420              4
#> 987                      987 -1.4205520              5
#> 601                      601  2.4985965              6

#View some of the sampling frame
head(score_audit_num$output$sample_frame)
#>     sample_frame_sequence_id      score random_numbers
#> 182                      182 -0.2228876              1
#> 323                      323  1.2110544              2
#> 962                      962 -0.4987969              3
#> 397                      397 -0.4757420              4
#> 987                      987 -1.4205520              5
#> 601                      601  2.4985965              6

#View some of the spares
head(score_audit_num$output$spares)
#>     sample_frame_sequence_id      score random_numbers
#> 830                      830 -1.3597070            101
#> 436                      436  2.8460599            102
#> 684                      684 -0.3411627            103

#Compute the relative bias
relative_bias(score_audit_num, score)
#> [1] 3.638445
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
#> 1                182     -0.2228876
#> 2                323      1.2110544
#> 3                962     -0.4987969
#> 4                397     -0.4757420
#> 5                987     -1.4205520
#> 6                601      2.4985965

#Export data file needed to process "Audited Values" Unrestricted Variable Appraisals in RAT-STATS
rs_uva <- uva_info$data_file
#write.table(rs_uva, sep=",",  col.names=FALSE)
```

## Randomly select items from a two stage sampling process

``` r
#In this example let each data frame represent a score sheet (first_set) with
#10 scores (second_set) on each sheet

#Create three separate score sheets 
df1 <- data.frame(page = c(1),
                  score = rnorm(10, 7,2),
                  item = 1:10)
df2 <- data.frame(page = c(2),
                  score = rnorm(10, 6, 1.5),
                  item = 1:10)
df3 <- data.frame(page = c(3),
                  score = rnorm(10, 8, 0.5),
                  item = 1:10)

#Combine the score sheets
df_combined <- rbind(df1, df2, df3)

#Randomly pull observations from the combined score sheet
combined_out <- rs_setsoftwo(df = df_combined,
                       first_set = page,
                       second_set = item,
                       seed_number = NA,
                       audit_review = "",
                       quantity_to_generate = 10,
                       quantity_of_spares = 2,
                       first_set_low = 1,
                       first_set_high = 3,
                       second_set_low = 1,
                       second_set_high = 10)

#Get head of sample
head(combined_out$output$sample)
#>    page    score item order
#> 6     1 7.374505    6     9
#> 10    1 8.781231   10     5
#> 11    2 3.784050    1     7
#> 12    2 9.013616    2     4
#> 13    2 7.357762    3     8
#> 14    2 6.944575    4     6

#Get the mean of the sample
mean(unlist(combined_out$output$sample))
#> [1] 4.961096
```
