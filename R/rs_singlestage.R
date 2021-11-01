rs_singlestage <- function(df = NULL,
                           seed_number = 0,
                           audit_review = "",
                           quantity_to_generate = 0,
                           quantity_of_spares = 0){

  #Do you want to set a seed number?
  if (seed_number == 0){#If No:
   seed <- sample(0:1000000, 1)
  } else {#If Yes:
   seed <- seed_number
  }
  set.seed(seed)

  #Name of the Audit/Review
  audit <- audit_review

  #Enter the quantity of numbers to be generated in Sequential Order:
  quantity <- quantity_to_generate

  #Enter the quantity of spare numbers to be generated in Random Order:
  spares <- quantity_of_spares

  #Collect output
  Output <- list("samples" = df,
                 "seed_number" = seed,
                 "audit_review" = audit,
                 "quantity_to_generate" = quantity,
                 "quantity_of_spares" = spares)

  #Return output
  Output
}
