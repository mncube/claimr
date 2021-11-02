rs_singlestage <- function(df = NULL,
                           seed_number = NA,
                           audit_review = "",
                           quantity_to_generate = 0,
                           quantity_of_spares = 0,
                           frame_low = 1,
                           frame_high = 1,
                           output_options = c("data.frame")){

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
  df_sample_frame <-  df
  df_sample_frame$random_numbers <- sample(x = low:high, size = high - low + 1,
                                     replace = FALSE)
  df_sample_frame <- df_sample_frame[order(df_sample_frame$random_numbers),]

  if (quantity == 0){
    df_sample <- NULL
  } else {
    df_sample <- df_sample_frame[1:quantity,]
  }

  spare_start <- quantity + 1
  spare_end <- spare_start + spares - 1

  if (spares == 0 | quantity == 0){
    df_spare <- NULL
  } else {
    df_spare <- df_sample_frame[spare_start:spare_end,]
  }

  #File output options
  if ("data.frame" %in% output_options){

    #Gather output in list
    output <- list("sample" = df_sample,
                   "sample_frame" = df_sample_frame,
                   "spares" = df_spare)

  } else {
    output <- list("sample" = "Invalid Output Format Provided",
                   "sample_frame" = "Invalid Output Format Provided",
                   "spares" = "Invalid Output Format Provided")
  }

  #Collect output
  Output <- list("output" = list(
                   "output_options" = output),
                 "input"  = list(
                   "samples" = df,
                   "seed_number" = seed,
                   "audit_review" = audit,
                   "quantity_to_generate" = quantity,
                   "quantity_of_spares" = spares,
                   "frame_low" = low,
                   "frame_high" = high))

  #Return output
  Output


}
