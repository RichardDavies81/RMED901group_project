# Script for visualization of data from tidy data generated in setup.R script

# note- each person chooses min.one question

# Are there any correlated measurements?
library(rstatix)
library(corrplot)
library(ggplot2)

numeric_data <- complete_data %>% select(where(is.numeric))
numeric_data <- numeric_data[, c(-1, -8, -9)] # ID, ct_orderset, pan_week removed due to inderpendence) 

round(cor(numeric_data, use = "complete.obs"), 1) # Makes object 
cor_pmat(numeric_data) # p values
corrplot(correlation) # Note large skew for age

ggplot(data = numeric_data, aes(x = age, y = pan_day)) +
  geom_point()



# Does the time spent waiting for the test result improve during these 100 days that the dataset includes?

ggplot(data = complete_data, aes(x = pan_week, y = rec_ver_tat)) +
  geom_point() +
  geom_smooth(method = "lm")

wait_stats <- complete_data %>%
  select(pan_week, rec_ver_tat) %>%
  mutate(pan_week = round(pan_week)) %>%
  group_by(pan_week) %>%
  summarize(mean_value = mean(rec_ver_tat), std = sd(rec_ver_tat), median(rec_ver_tat))
  
by_week <- complete_data %>%
  select(pan_week, rec_ver_tat) %>%
  mutate(pan_week = round(pan_week)) %>%
  group_by(pan_week) 

mean_by_week <- by_week %>%
  group_by(pan_week) %>%
  summarise(mean_y = mean(rec_ver_tat))

ggplot(data = by_week, aes(x=as.factor(pan_week), y=rec_ver_tat)) +
  geom_violin() +
  ylim(0, 50)


# Were there more females than males that took the test at a drive through?
dt_by_gender <- complete_data %>%
  group_by(gender) %>%
  count(drive_thru_ind)

dt_by_gender

ggplot(data = dt_by_gender, aes(x = drive_thru_ind, y = n, fill = gender)) +
  geom_bar(stat = "identity", color="black", position=position_dodge())+
  theme_minimal() + 
  scale_fill_manual(values=c('#999999','#E69F00')) +
# Use brewer color palettes
  scale_fill_brewer(palette="Blues")

# Does the distribution of the `ct_result` differ with sex group?
ct_result_dist <- complete_data %>%
  group_by(gender) %>%
  count(ct_result)

ggplot(ct_result_dist, 
       aes(
         x = 1:nrow(ct_result_dist),
         y = ct_result,
         group = gender,
         color = gender)
       ) + 
  geom_point() +
  facet_wrap(vars(gender))


# Does the distribution of the `ct_result` differ with `payor_group`?
# Subset the data
ct_result_dist_pg <- complete_data %>%
  group_by(payor_group) %>%
  count(ct_result)

ggplot(
  ct_result_dist_pg,
  aes(
    x = 1:nrow(ct_result_dist_pg),
    y = ct_result,
    group = payor_group,
    color = payor_group
    )
  ) +
  geom_point() +
  facet_wrap(vars(payor_group))


# Were there more tests in any of the sex groups?
tests_by_gender <- complete_data %>%
  group_by(gender) %>%
  count(result)

tests_by_gender

ggplot(data = tests_by_gender, aes(x = result, y = n, fill = gender)) +
  geom_bar(stat = "identity", color="black", position=position_dodge())+
  theme_minimal() +
  scale_fill_manual(values=c('#999999','#E69F00')) +
# Use brewer color palettes
  scale_fill_brewer(palette="Blues")
