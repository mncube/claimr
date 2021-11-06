runstest_w <- function(data = NULL, x_test, x_order = NULL){

  #If data frame is not provided, run test on x_test
  if (is.null(data)) {
    rt_results <- snpar::runs.test(x_test)
  } else {

    #Convert column names to strings
    x_test <- deparse(substitute(x_test))
    x_order <- deparse(substitute(x_order))

    #Test if a sorting variable was provided then run runs test
    if (!is.null(data[[x_order]])){
      data <- data[order(data[[x_order]]),]
      rnd_proc <- data[[x_test]]
      rt_results <- snpar::runs.test(rnd_proc)
    } else {
      rnd_proc <- data[[x_test]]
      rt_results <- snpar::runs.test(rnd_proc)
      warning("Make sure test variable is sorted in the order in which the random samples were drawn.")
    }

  }

 #Return output
 return(rt_results)
}


