# Script for data analysis of data from tidy data generated in setup.R script

# note- each person chooses one question

# Do your chances of getting a positive test increase with the number of tests taken? No, stronger association with less tests


positive_visits <- complete_data %>%
  mutate(positive = if_else(result == "positive", 1, 0)) %>%
  group_by(ID) %>%
  count(positive, ID)

positive_visits <- positive_visits[, -1]
positive_visits$positive <- factor(positive_visits$positive)
levels(positive_visits$positive) <- c("negative", "positive")

positive_visits %>% 
  group_by(positive) %>%
  summarize(mean(n), median(n))


ggplot(positive_visits, aes(x = positive, y = n)) +
  geom_boxplot() +
  ylim(0, 10)

positive_visits %>% 
  wilcox.test(n ~ positive, data = .) %>%
  broom::tidy()

chisq.test(x = complete_data$dti_yes_no, y = complete_data$result)


# Are there more positive tests in the drive-through?

table <- complete_data %>%
  group_by(dti_yes_no, result) %>%
  count() 

chisq.test(x = positive_visits$n, y = positive_visits$positive)


# Is the age of the individual associated with whether the test result is negative or positive?
# first check associations via plots
#create a categorical age variable

complete_data$age_cat <- cut(complete_data$age, 
                             breaks = c(0, 9, 19, 29, 39, 49, 59, 69, 79, 89, 99, Inf),
                             labels = c("0-9", "10-19", "20-29", "30-39", 
                                        "40-49", "50-59", "60-69", "70-79", 
                                        "80-89", "90-99", "100+"))

arrange(complete_data, by = ID)
complete_data %>% select(ID, age, age_cat, gender, everything())

ggplot(complete_data, 
       aes(
         x = result,
         y = age_cat,
         group = gender,
         color = gender)
) + 
  geom_point() +
  facet_wrap(vars(gender))

# ANOVA
complete_data_aov <- aov(complete_data$age~complete_data$result)
complete_data_aov
summary(complete_data_aov)


# Is there a difference in the distributions of `ct_results` between different outcome groups (`result`)?

# Does the number of positive tests depend on the `pan_day`?