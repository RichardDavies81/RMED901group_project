# Script for data analysis of data from tidy data generated in setup.R script

# note- each person chooses one question

# Do your chances of getting a positive test increase with the number of tests taken?



positive_visits <- complete_data %>%
  mutate(positive = if_else(result == "positive", 1, 0)) %>%
  group_by(ID) %>%
  count(positive, ID)


chisq.test(x = complete_data$dti_yes_no, y = complete_data$result)


# Are there more positive tests in the drive-through?


table <- complete_data %>%
  group_by(dti_yes_no, result) %>%
  count() 

chisq.test(x = positive_visits$n, y = positive_visits$positive)


# Is the age of the individual associated with whether the test result is negative or positive?



# Is there a difference in the distributions of `ct_results` between different outcome groups (`result`)?



# Does the number of positive tests depend on the `pan_day`?