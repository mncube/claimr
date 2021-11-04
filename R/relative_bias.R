relative_bias <- function(obj = NULL, var = NULL, ...){

  #Get column name
  var <- deparse(substitute(var))

  #Get the mean of var for the sample and sampling frame
  sample_mean <- mean(obj$output$output_options$sample[[var]], ...)
  frame_mean <- mean(obj$output$output_options$sample_frame[[var]], ...)

  #Calculate the relative bias
  rbias <- abs((sample_mean - frame_mean)/frame_mean)

  #Return the relative bias
  rbias
}
