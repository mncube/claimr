gi_unrestricted_variable_appraisals <- function(samp_obj,
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
