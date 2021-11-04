#Set up a data frame to test dimensions of data frame

#Generate sampling frame  with an index id from 1 to N
df_sample_frame <- data.frame("sample_frame_sequence_id" = 1:1000,
                              "score" = sample(c("A", "B"), size = 1000, replace = TRUE))

#Get output and input in lists
score_audit <- rs_singlestage(df = df_sample_frame,
                              seed_number = 100,
                              audit_review = "Score Audit",
                              quantity_to_generate = 20,
                              quantity_of_spares = 3,
                              frame_low = 1,
                              frame_high = 1000,
                              output_options = c("data.frame"))

test_that("The sample data frame has the same amount of samples as the
quantity_to_generate input", {
  expect_equal(nrow(score_audit$output$output_options$sample),
               score_audit$input$quantity_to_generate)
})

test_that("The spares data frame has the same amount of samples as the
quantity_of_spares input", {
  expect_equal(nrow(score_audit$output$output_options$spares),
               score_audit$input$quantity_of_spares)
})
