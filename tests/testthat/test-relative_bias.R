#Set up claimr sample object for testing
#Generate sampling frame  with an index id from 1 to N
df_sample_frame_num <- data.frame("sample_frame_sequence_id" = 1:1000,
                                  "score" = rnorm(1000))

#Get output and input in lists
score_audit_num <- rs_singlestage(df = df_sample_frame_num,
                                  seed_number = 100,
                                  audit_review = "Score Audit",
                                  quantity_to_generate = 100,
                                  quantity_of_spares = 3,
                                  frame_low = 1,
                                  frame_high = 1000)

#Manually obtain relative bias of score_audit_num
sample_mean <- mean(score_audit_num$output$sample$score)
frame_mean <- mean(score_audit_num$output$sample_frame$score)
manual_rel_bias <- abs((sample_mean - frame_mean)/frame_mean)

#Use claimr's relative bias function to obtain relative bias of score_audit_num
claimr_rel_bias <- relative_bias(obj = score_audit_num, var = score)


test_that("Relative bias computed manually (manual_rel_bias) givs the same result
          as the relative bias computed from claimr's relative_bias function", {
  expect_equal(claimr_rel_bias, manual_rel_bias)
})
