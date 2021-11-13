#' Rat-Stats Style Sets of Three Random Numbers
#'
#' @param df A data frame containing an index for the first, second, and third set of numbers
#' @param first_set Column name for first set of numbers (i.e., time, volumne)
#' @param second_set Column name for second set of numbers (i.e., page, source, or data frame id)
#' @param third_set Column name for third set of numbers (i.e., line, observation, or row id)
#' @param seed_number "Do you want to provide seed number?" Provide a seed number.
#' If the default (seed_number = NA) is retained then the seed number will be set
#' to sample(0:1000000, 1) and the result will be returned in the output.
#' @param audit_review "Name of the Audit/Review"
#' @param quantity_to_generate "Enter the quantity of numbers to be generated in
#' Random Order."
#' @param quantity_of_spares "Enter the quantity of Spare numbers to be generated
#' in Random Order:"
#' @param first_set_low Enter the low number for the sampling frame's first set
#' @param first_set_high Enter the high number for the sampling frame's first set
#' @param second_set_low Enter the low number for the sampling frame's second set
#' @param second_set_high Enter the high number for the sampling frame's second set
#' @param third_set_low Enter the low number for the sampling frame's third set
#' @param third_set_high Enter the high number for the sampling frame's third set
#'
#' @return A nested list with "output" and "input" lists.  The output list contains three
#' data frames: the sample, the sample frame, and the spares.  Each data frame
#' includes the random numbers (in the order variable) and each has been sorted by first_set, second_set, and third_set.
#' The input list returns input parameters and the random number seed.
#' @export
#'
#' @examples
#' #Create six separate data frames
#'df1_pre <- data.frame(time = 1,
#'                      page = c(1),
#'                      score = rnorm(10, 7,2),
#'                      item = 1:10)
#'df2_pre <- data.frame(time = 1,
#'                      page = c(2),
#'                      score = rnorm(10, 6, 1.5),
#'                      item = 1:10)
#'df3_pre <- data.frame(time = 1,
#'                      page = c(3),
#'                      score = rnorm(10, 8, 0.5),
#'                      item = 1:10)
#'df1_post <- data.frame(time = 2,
#'                       page = c(1),
#'                       score = rnorm(10, 7,2),
#'                       item = 1:10)
#'df2_post <- data.frame(time = 2,
#'                       page = c(2),
#'                       score = rnorm(10, 6, 1.5),
#'                       item = 1:10)
#'df3_post <- data.frame(time = 2,
#'                       page = c(3),
#'                       score = rnorm(10, 8, 0.5),
#'                       item = 1:10)
#'
#'#Combine the data frames
#'df_combined <- rbind(df1_pre, df2_pre, df3_pre,
#'                     df1_post, df2_post, df3_post)
#'
#'#Randomly pull observations from df_combined
#'combined_out <- rs_setsofthree(df = df_combined,
#'                               first_set = time,
#'                               second_set = page,
#'                               third_set = item,
#'                               seed_number = NA,
#'                               audit_review = "",
#'                               quantity_to_generate = 10,
#'                               quantity_of_spares = 2,
#'                               first_set_low = 1,
#'                               first_set_high = 2,
#'                               second_set_low = 1,
#'                               second_set_high = 3,
#'                               third_set_low = 1,
#'                               third_set_high = 10)
rs_setsofthree <- function(df = NULL,
                           first_set,
                           second_set,
                           third_set,
                           seed_number = NA,
                           audit_review = "",
                           quantity_to_generate = 0,
                           quantity_of_spares = 0,
                           first_set_low = 1,
                           first_set_high = 1,
                           second_set_low = 1,
                           second_set_high = 1,
                           third_set_low = 1,
                           third_set_high = 1){
  #Save original data set
  df_temp <- df

  #Do you want to set a seed number?
  if (is.na(seed_number)){#If No:
    seed <- sample(0:1000000, 1)
  } else {#If Yes:
    seed <- seed_number
  }
  set.seed(seed)

  #Name of the Audit/Review
  audit <- audit_review

  #Enter the quantity of numbers to be generated in Sequential Order:
  quantity <- quantity_to_generate

  #Enter the quantity of spare numbers to be generated in Random Order:
  spares <- quantity_of_spares

  #Enter the sampling frame Low Number for the First Set:
  first_low <- first_set_low

  #Enter the sampling frame High Number for the First Set:
  first_high <- first_set_high

  #Enter the sampling frame Low Number for the Second Set:
  second_low <- second_set_low

  #Enter the sampling frame High Number for the Second Set:
  second_high <- second_set_high

  #Enter the sampling frame Low Number for the Third Set:
  third_low <- third_set_low

  #Enter the sampling frame High Number for the Third Set:
  third_high <- third_set_high

  #Create lists of random numbers
  first_frame <- list(first_low:first_high)
  second_frame <- list(second_low:second_high)
  third_frame <- list(third_low:third_high)

  #Get length of dataframe
  frame_length <- (first_high - first_low + 1)*(second_high - second_low + 1)*(third_high - third_low + 1)

  #Add values and random numbers ("order") to a data frame
  frame <- expand.grid(first_value = first_low:first_high,
                       second_value = second_low:second_high,
                       third_value = third_low:third_high)

  frame$order <- sample(x = 1:frame_length, size = frame_length,
                        replace = FALSE)

  #Convert index names to strings
  first_set <- deparse(substitute(first_set))
  second_set     <- deparse(substitute(second_set))
  third_set <- deparse(substitute(third_set))

  #Change column names in preparaion for merge
  colnames(df)[which(names(df) == first_set)] <- "first_value"
  colnames(df)[which(names(df) == second_set)] <- "second_value"
  colnames(df)[which(names(df) == third_set)] <- "third_value"


  #Merge df with random numbers
  df <- dplyr::left_join(df, frame, by = c("first_value", "second_value", "third_value"))

  #Order sampling frame by order
  df <- df[order(df[["order"]]),]

  #Create the data frame containing the sample
  if (quantity == 0){
    df_sample <- NULL
  } else {
    df_sample <- df[1:quantity,]
    #order data frames by values then reset names
    df_sample <- df_sample[with(df_sample, order(first_value, second_value, third_value)), ]
    colnames(df_sample)[which(names(df_sample) == "first_value")] <- first_set
    colnames(df_sample)[which(names(df_sample) == "second_value")] <- second_set
    colnames(df_sample)[which(names(df_sample) == "third_value")] <- third_set
  }

  #Get indices for spares
  spare_start <- quantity + 1
  spare_end <- spare_start + spares - 1

  #Create data frame containing the spares
  if (spares == 0 | quantity == 0){
    df_spare <- NULL
  } else {
    df_spare <- df[spare_start:spare_end,]
    #order data frames by values then reset names
    df_spare <- df_spare[with(df_spare, order(first_value, second_value, third_value)), ]
    colnames(df_spare)[which(names(df_spare) == "first_value")] <- first_set
    colnames(df_spare)[which(names(df_spare) == "second_value")] <- second_set
    colnames(df_spare)[which(names(df_spare) == "third_value")] <- third_set

  }

  #order data frames by values then reset names
  df <- df[with(df, order(first_value, second_value, third_value)), ]
  colnames(df)[which(names(df) == "first_value")] <- first_set
  colnames(df)[which(names(df) == "second_value")] <- second_set
  colnames(df)[which(names(df) == "third_value")] <- third_set


  #Gather output in list
  output <- list("sample" = df_sample,
                 "sample_frame" = df,
                 "spares" = df_spare)

  #Collect output
  Output <- list("output" = output,
                 "input"  = list(
                   "samples" = df_temp,
                   "seed_number" = seed,
                   "audit_review" = audit,
                   "quantity_to_generate" = quantity,
                   "quantity_of_spares" = spares,
                   "first_set_low" = first_low,
                   "first_set_high" = first_high,
                   "second_set_low" = second_low,
                   "second_set_high" = second_high,
                   "third_set_low" = third_low,
                   "third_set_high" = third_high,
                   "obj_style" = "rs_setsoftwo"))

  #Return results
  return(Output)
}
