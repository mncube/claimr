#' Rat-Stats Style Single Stage Random Numbers
#'
#' @param df A data frame containing an index or id column sequenced from
#' frame_low to frame_high
#' @param seed_number "Do you want to provide seed number?" Provide a seed number.
#' If the default (seed_number = NA) is retained then the seed number will be set
#' to sample(0:1000000, 1) and the result will be returned in the output.
#' @param audit_review "Name of the Audit/Review"
#' @param quantity_to_generate "Enter the quantity of numbers to be generated in
#' Random Order."
#' @param quantity_of_spares "Enter the quantity of Spare numbers to be generated
#' in Random Order:"
#' @param frame_low "Enter the sampling frame Low Number: (default = 1)"
#' @param frame_high "Enter the sampling frame High Number: (default = 1)"
#'
#' @return A nested list with "output" and "input" lists.  The output list contains three
#' data frames: the sample, the sample frame, and the spares.  Each data frame
#' includes the random numbers and each has been sorted by random number.  The input list
#' returns input parameters and the random number seed.
#' @export
#'
#' @examples
#' #Generate sampling frame  with an index id from 1 to N (where N is the number
#' #of observation on the sampling frame)
#' df_sample_frame <- data.frame("sample_frame_sequence_id" = 1:1000,
#'                              "score" = sample(c("A", "B"), size = 1000, replace = TRUE))
#'
#' #Run rs_singlestage function to obtain output and input lists
#' rs_singlestage(df = df_sample_frame,
#'                seed_number = 100,
#'                audit_review = "Score Audit",
#'                quantity_to_generate = 20,
#'                quantity_of_spares = 3,
#'                frame_low = 1,
#'                frame_high = 1000)
rs_singlestage <- function(df = NULL,
                           seed_number = NA,
                           audit_review = "",
                           quantity_to_generate = 0,
                           quantity_of_spares = 0,
                           frame_low = 1,
                           frame_high = 1){

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

  #Enter the sampling frame Low Number:
  low <- frame_low

  #Enter the sampling frame High Number:
  high <- frame_high

  #Add random numbers to dataframe

  #Copy df
  df_sample_frame <-  df

  #Add random_numbers to sample frame
  df_sample_frame$random_numbers <- sample(x = low:high, size = high - low + 1,
                                     replace = FALSE)

  #Order sample frame by random_numbers
  df_sample_frame <- df_sample_frame[order(df_sample_frame$random_numbers),]

  #Create the data frame containing the sample
  if (quantity == 0){
    df_sample <- NULL
  } else {
    df_sample <- df_sample_frame[1:quantity,]
  }

  #Get indices for spares
  spare_start <- quantity + 1
  spare_end <- spare_start + spares - 1

  #Create data frame containing the spares
  if (spares == 0 | quantity == 0){
    df_spare <- NULL
  } else {
    df_spare <- df_sample_frame[spare_start:spare_end,]
  }


  #Gather output in list
  output <- list("sample" = df_sample,
                 "sample_frame" = df_sample_frame,
                 "spares" = df_spare)

  #Collect output
  Output <- list("output" = output,
                 "input"  = list(
                   "samples" = df,
                   "seed_number" = seed,
                   "audit_review" = audit,
                   "quantity_to_generate" = quantity,
                   "quantity_of_spares" = spares,
                   "frame_low" = low,
                   "frame_high" = high,
                   "obj_style" = "rs_singlestage"))

  #Return output
  Output

}
