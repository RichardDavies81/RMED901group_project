# Script for data analysis of data from tidy data generated in setup.R script

# note- each person chooses one question

# Do your chances of getting a positive test increase with the number of tests taken?

test <- complete_data %>%
  count(ID)
  




# Are there more positive tests in the drive-through?


dt_results <- complete_data %>%
  select(dti_yes_no, result) %>%
  mutate(dti_yes_no = factor(dti_yes_no))

unique(dt_results$result)

table <- dt_results %>%
  group_by(dti_yes_no, result) %>%
  count() 

chisq.test(x = dt_results$dti_yes_no, y = dt_results$result)




# Is the age of the individual associated with whether the test result is negative or positive?



# Is there a difference in the distributions of `ct_results` between different outcome groups (`result`)?



# Does the number of positive tests depend on the `pan_day`?