#Generate sampling frame  with an index id from 1 to N
math_test <- data.frame("sample_frame_sequence_id" = 1:1000,
                        "math" = rnorm(1000, mean = 75, sd = 15))

#Take random samples from sampling frame and get output and input in lists
math_test_cobj <- rs_singlestage(df = math_test,
                                 seed_number = 100,
                                 audit_review = "Math Sample",
                                 quantity_to_generate = 20,
                                 quantity_of_spares = 5,
                                 frame_low = 1,
                                 frame_high = 1000)

#Pull the "samples" data frame for claimr::runstest_w
math_test_samples <- math_test_cobj$output$sample

#Get the "math" vector for the snpar::runs.test
temp_data <- math_test_samples[order(math_test_samples[["random_numbers"]]),]
snpar_runs <- temp_data$math

#Use runs test using snpar::runs.test
snpar_runs_p <- snpar::runs.test(snpar_runs)

#Use runs test using claimr::runstest_w
claimr_runs_p <- runstest_w(data = math_test_samples, x_test = math, x_order = random_numbers)

#Test p-values
test_that("Check that claimr::runstest_w gives same p-value as snpar::runs.test", {
  expect_equal(snpar_runs_p$p.value, claimr_runs_p$p.value)
})
