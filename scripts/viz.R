
# Script for visualization of data from tidy data generated in setup.R script

# note- each person chooses min.one question



# Are there any correlated measurements?




# Does the time spent waiting for the test result improve during these 100 days that the dataset includes?


# Were there more females than males that took the test at a drive through?


# Does the distribution of the `ct_result` differ with sex group?



# Does the distribution of the `ct_result` differ with `payor_group`?



# Were there more tests in any of the sex groups?

# Script for visualization of data from tidy data generated in setup.R script

# note- each person chooses min.one question

# Are there any correlated measurements?

library(rstatix)
library(corrplot)

numeric_data <- complete_data %>% select(where(is.numeric))
numeric_data <- numeric_data[, c(-1, -8, -9)] # ID, ct_orderset, pan_week removed) 

correlation <- round(cor(numeric_data, use = "complete.obs"), 1)

cor_pmat(numeric_data) # p values
corrplot(correlation)


# Does the time spent waiting for the test result improve during these 100 days that the dataset includes?

ggplot(data = complete_data, aes(x = pan_day, y = rec_ver_tat)) +
  geom_point() +
  geom_smooth(method = "lm")



# Were there more females than males that took the test at a drive through?
dt_by_gender <- complete_data %>%
  group_by(gender) %>%
  count(drive_thru_ind)

dt_by_gender

ggplot(data = dt_by_gender, aes(x = drive_thru_ind, y = n, fill = gender)) +
  geom_bar(stat = "identity", color="black", position=position_dodge())+
  theme_minimal()
p + scale_fill_manual(values=c('#999999','#E69F00'))
# Use brewer color palettes
p + scale_fill_brewer(palette="Blues")

# Does the distribution of the `ct_result` differ with sex group?



# Does the distribution of the `ct_result` differ with `payor_group`?



# Were there more tests in any of the sex groups?
tests_by_gender <- complete_data %>%
  group_by(gender) %>%
  count(result)

tests_by_gender

ggplot(data = tests_by_gender, aes(x = result, y = n, fill = gender)) +
  geom_bar(stat = "identity", color="black", position=position_dodge())+
  theme_minimal()
p + scale_fill_manual(values=c('#999999','#E69F00'))
# Use brewer color palettes
p + scale_fill_brewer(palette="Blues")


