#Generate sampling frame  with an index id from 1 to N
df_sample_frame_num <- data.frame("sample_frame_sequence_id" = 1:1000,
                                  "score" = rnorm(1000, 75, 10))

#Get output and input in lists
score_audit_num <- rs_singlestage(df = df_sample_frame_num,
                                  seed_number = 100,
                                  audit_review = "Score Audit",
                                  quantity_to_generate = 100,
                                  quantity_of_spares = 3,
                                  frame_low = 1,
                                  frame_high = 1000)

#Get sample
score_samp <- score_audit_num$output$sample

#Add random audit results to sample
score_samp$audit_results <- sample(0:1, 100, replace = TRUE)

#Get sampling frame
score_frame <- score_audit_num$output$sample_frame

#Set size of sampling frame (Npop), sample size (nsamp), and number of sample items in error (ne, where ne = sum(score_samp$audit_results == 1) for this example
Npop = 1000
nsamp = 100
ne = 100

#Get LMS output lists
LMS_out <- LMS(score_samp, score_frame, var = score, sub_var = sample_frame_sequence_id,
               flag = audit_results, Npop, nsamp, ne)

#Get number of rows in df_NLE_minus_ne
nrow_NLE_minus_ne <- LMS_out$data$df_NLE_minus_ne

#Get output returned from Ne_low_minus_ne(Npop, nsamp, ne)
num_Ne_low_minus_ne <- Ne_low_minus_ne(Npop, nsamp, ne)


#Run test
test_that("Number of rows in the df_NLE_minus_ne data frame equals number returned from Ne_low_minus_ne()", {
  expect_equal(nrow(nrow_NLE_minus_ne), num_Ne_low_minus_ne)
})
