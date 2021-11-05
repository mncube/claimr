#' Relative Bias
#'
#' Get the relative bias of a sample obtained from a claimr sampling function
#'
#' @param obj An object obtained from a claimr sampling function
#' @param var A variable for the relative bias computation
#' @param ... Extra arguments associated with the mean function
#'
#' @return A number obtained from computing the relative bias of var computed
#' using the sample data frame and sample frame data frame from an object
#' obtained from a claimr sampling function
#' @export
#'
#' @examples
#' #Generate sampling frame  with an index id from 1 to N
#' df_sample_frame_num <- data.frame("sample_frame_sequence_id" = 1:1000,
#'                                  "score" = rnorm(1000))
#'
#' #Get output and input in lists
#' score_audit_num <- rs_singlestage(df = df_sample_frame_num,
#'                                   seed_number = 100,
#'                                   audit_review = "Score Audit",
#'                                   quantity_to_generate = 100,
#'                                   quantity_of_spares = 3,
#'                                   frame_low = 1,
#'                                   frame_high = 1000)
#'
#' #Compute relative bias of sample stored in score_audit_num
#'
#' relative_bias(obj = score_audit_num, var = score)
relative_bias <- function(obj = NULL, var = NULL, ...){

  #Get column name
  var <- deparse(substitute(var))

  #Get the mean of var for the sample and sampling frame
  sample_mean <- mean(obj$output$sample[[var]], ...)
  frame_mean <- mean(obj$output$sample_frame[[var]], ...)

  #Calculate the relative bias
  rbias <- abs((sample_mean - frame_mean)/frame_mean)

  #Return the relative bias
  rbias
}
