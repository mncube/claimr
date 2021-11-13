#Create three separate data frames
df1 <- data.frame(page = c(1),
                  score = rnorm(10, 7,2),
                  item = 1:10)
df2 <- data.frame(page = c(2),
                  score = rnorm(10, 6, 1.5),
                  item = 1:10)
df3 <- data.frame(page = c(3),
                  score = rnorm(10, 8, 0.5),
                  item = 1:10)

#Combine the data frames
df_combined <- rbind(df1, df2, df3)

#Randomly pull observations from df_combined
combined_out <- rs_setsoftwo(df = df_combined,
                             first_set = page,
                             second_set = item,
                             seed_number = NA,
                             audit_review = "",
                             quantity_to_generate = 10,
                             quantity_of_spares = 2,
                             first_set_low = 1,
                             first_set_high = 3,
                             second_set_low = 1,
                             second_set_high = 10)

#Test dimensions of the sample
test_that("Rows in .$output$sample equals .$input$quantity_to_generate", {
  expect_equal(nrow(combined_out$output$sample), combined_out$input$quantity_to_generate)
})

#Test dimensions of the spares
test_that("Rows in .$output$spares equals .$input$quantity_of_spares", {
  expect_equal(nrow(combined_out$output$spares), combined_out$input$quantity_of_spares)
})
