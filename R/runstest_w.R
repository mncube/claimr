#' The Runs Test
#'
#' Wrapper around snpar::runs.test.  When using this function with a dataframe
#' and the x_order parameter set to NULL, the output includes a warning that x_test
#' must be sorted in the order in which samples were drawn.  Use ?snpar::runs.test
#' for technical documentation.
#'
#' @param data A data frame.  Set to NULL if testing a vector x_test.
#' @param x_test A data frame column or a vector if data is set to NULL.
#' @param x_order A variable listing the order in which samples were drawn.
#'
#' @return snpar::runs.test output (with a warning if using dataframe with x_order = NULL)
#' @export
#'
#' @examples
#' #Generate sampling frame  with an index id from 1 to N
#' math_test <- data.frame("sample_frame_sequence_id" = 1:1000,
#'                        "math" = rnorm(1000, mean = 75, sd = 15))
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
#' #Pull the "samples" data frame
#' math_test_samples <- math_test_cobj$output$sample
#'
#' #Use runs test to check if data were generated from a random process
#' runstest_w(data = math_test_samples, x_test = math, x_order = random_numbers)
#'
#' #Test a vector (must use data = NULL which is the default)
#' runstest_w(x_test = rnorm(100, 50, 10))
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
      warning("Make sure x_test is sorted in the order in which the random samples were drawn.")
    }

  }

 #Return output
 return(rt_results)
}


