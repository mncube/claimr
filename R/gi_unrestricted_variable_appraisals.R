#' Get Input Information for RAT-STATS Style Unrestricted Variable Appraisals
#'
#' This function takes a nested list from a claimr sampling function and returns
#' the information needed to perform a RAT-STATS' Unrestricted Variable Appraisals
#'
#' @param samp_obj A nested list returned from a claimr sampling function
#' @param data_file_format "Data File Format" for RAT-STATS extrapolation
#' @param audited_values Column with "number being reviewed by the user"
#' @param sample_item_number Column with "sample item number"
#'
#' @return Information and dataset required for a RAT-STATS Unrestricted Variable Appraisals
#' @export
#'
#' @examples
#' #Generate sampling frame  with an index id from 1 to N
#' math_test <- data.frame("sample_frame_sequence_id" = 1:1000,
#'                         "math" = rnorm(1000, mean = 75, sd = 15))
#'
#' #Get output and input in lists
#' math_test_cobj <- rs_singlestage(df = math_test,
#'                                  seed_number = 100,
#'                                  audit_review = "Math Sample",
#'                                  quantity_to_generate = 20,
#'                                  quantity_of_spares = 5,
#'                                  frame_low = 1,
#'                                  frame_high = 1000)
#'
#' gi_unrestricted_variable_appraisals(samp_obj = math_test_cobj,
#'                                     data_file_format = c("Audited Values"),
#'                                     audited_values = math,
#'                                     sample_item_number = sample_frame_sequence_id)
gi_unrestricted_variable_appraisals <- function(samp_obj,
                                                data_file_format,
                                                audited_values,
                                                sample_item_number){
  UseMethod("gi_unrestricted_variable_appraisals")
}

#' Get Input Information for RAT-STATS Style Unrestricted Variable Appraisals
#'
#' This function takes a nested list from a claimr sampling function and returns
#' the information needed to perform a RAT-STATS' Unrestricted Variable Appraisals
#'
#' @param samp_obj A nested list returned from a claimr sampling function
#' @param data_file_format "Data File Format" for RAT-STATS extrapolation
#' @param audited_values Column with "number being reviewed by the user"
#' @param sample_item_number Column with "sample item number"
#'
#' @return Information and dataset required for a RAT-STATS Unrestricted Variable Appraisals
#' @export
#'
#' @examples
#' #Generate sampling frame  with an index id from 1 to N
#' math_test <- data.frame("sample_frame_sequence_id" = 1:1000,
#'                         "math" = rnorm(1000, mean = 75, sd = 15))
#'
#' #Get output and input in lists
#' math_test_cobj <- rs_singlestage(df = math_test,
#'                                  seed_number = 100,
#'                                  audit_review = "Math Sample",
#'                                  quantity_to_generate = 20,
#'                                  quantity_of_spares = 5,
#'                                  frame_low = 1,
#'                                  frame_high = 1000)
#'
#' gi_unrestricted_variable_appraisals(samp_obj = math_test_cobj,
#'                                     data_file_format = c("Audited Values"),
#'                                     audited_values = math,
#'                                     sample_item_number = sample_frame_sequence_id)
gi_unrestricted_variable_appraisals.rs_singlestage <- function(samp_obj,
                                                data_file_format = c("Audited Values"),
                                                audited_values = NULL,
                                                sample_item_number
                                                ){

  #Name of the Audit/Review
  audit_review <- samp_obj$input$audit_review

  #Frame Size
  frame_size <- samp_obj$input$frame_high - samp_obj$input$frame_low + 1

  #Sample Size
  sample_size <- samp_obj$input$quantity_to_generate

  #Data File Format
  data_file_format <- data_file_format

  #output file
  #Convert column names to strings
  sample_item_number <- deparse(substitute(sample_item_number))
  audited_values <- deparse(substitute(audited_values))

  if (!is.null(audited_values)){
  data_file <- data.frame("sample_item_number" = samp_obj$output$sample[[sample_item_number]],
                                 "audited_values" = samp_obj$output$sample[[audited_values]])
  }

  #Collect output in list
  Output <- list("audit_review" = audit_review,
                 "frame_size" = frame_size,
                 "sample_size" = sample_size,
                 "data_file_format" = data_file_format,
                 "data_file" = data_file)

  #Return output
  return(Output)

}
