
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
#> 182                      182 -0.2216545              1
#> 323                      323  0.5524901              2
#> 962                      962 -0.4437616              3
#> 397                      397  0.1938254              4
#> 987                      987  0.3090879              5
#> 601                      601  0.5237141              6

#View some of the sampling frame
head(score_audit_num$output$sample_frame)
#>     sample_frame_sequence_id      score random_numbers
#> 182                      182 -0.2216545              1
#> 323                      323  0.5524901              2
#> 962                      962 -0.4437616              3
#> 397                      397  0.1938254              4
#> 987                      987  0.3090879              5
#> 601                      601  0.5237141              6

#View some of the spares
head(score_audit_num$output$spares)
#>     sample_frame_sequence_id       score random_numbers
#> 830                      830 -0.90058222            101
#> 436                      436  0.03977434            102
#> 684                      684  1.13626413            103

#Compute the relative bias
relative_bias(score_audit_num, score)
#> [1] 0.6523302
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
#> 1                182     -0.2216545
#> 2                323      0.5524901
#> 3                962     -0.4437616
#> 4                397      0.1938254
#> 5                987      0.3090879
#> 6                601      0.5237141

#Export data file needed to process "Audited Values" Unrestricted Variable Appraisals in RAT-STATS
rs_uva <- uva_info$data_file
#write.table(rs_uva, sep=",",  col.names=FALSE)
```

## Randomly select items from a two stage sampling process

``` r
#In this example let each data frame represents a score sheet (first_set) with
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

## Randomly select items from a three stage sampling process

``` r
#In this example let each data frame represents a pre-test or post-test (first_set) and 
#a score sheet (second_set) with 10 scores (third_set) on each sheet

#Create six separate data frames
df1_pre <- data.frame(time = 1,
                      page = c(1),
                      score = rnorm(10, 7,2),
                      item = 1:10)
df2_pre <- data.frame(time = 1,
                      page = c(2),
                      score = rnorm(10, 6, 1.5),
                      item = 1:10)
df3_pre <- data.frame(time = 1,
                      page = c(3),
                      score = rnorm(10, 8, 0.5),
                      item = 1:10)
df1_post <- data.frame(time = 2,
                       page = c(1),
                       score = rnorm(10, 7,2),
                       item = 1:10)
df2_post <- data.frame(time = 2,
                       page = c(2),
                       score = rnorm(10, 6, 1.5),
                       item = 1:10)
df3_post <- data.frame(time = 2,
                       page = c(3),
                       score = rnorm(10, 8, 0.5),
                       item = 1:10)

#Combine the data frames
df_combined <- rbind(df1_pre, df2_pre, df3_pre,
                     df1_post, df2_post, df3_post)

#Randomly pull observations from df_combined
combined_out <- rs_setsofthree(df = df_combined,
                               first_set = time,
                               second_set = page,
                               third_set = item,
                               seed_number = NA,
                               audit_review = "",
                               quantity_to_generate = 10,
                               quantity_of_spares = 2,
                               first_set_low = 1,
                               first_set_high = 2,
                               second_set_low = 1,
                               second_set_high = 3,
                               third_set_low = 1,
                               third_set_high = 10)

#Get head of sample
head(combined_out$output$sample, 10)
#>    time page    score item order
#> 11    1    2 5.395469    1     4
#> 21    1    3 7.548854    1     6
#> 24    1    3 8.515617    4     5
#> 28    1    3 7.855659    8     2
#> 29    1    3 8.724455    9     3
#> 30    1    3 7.073804   10     1
#> 33    2    1 9.184083    3     9
#> 34    2    1 9.684856    4     8
#> 43    2    2 5.825793    3     7
#> 52    2    3 7.818014    2    10
```
