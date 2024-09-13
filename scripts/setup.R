
# setup ----

library(tidyverse) # loading package for cleaning of data
# install.packages("tidyverse")

library(here) # for targeting directory
here()

# file structure

dir.create("data")
dir.create("figures")
dir.create("processed_data")
dir.create("results")
dir.create("scripts")

## explore_dataset.txt and convert to tidy dataset----


my_data <- read_delim("data/exam_dataset.txt", col_names = TRUE)

# split gender and age
my_data <- my_data %>%
  separate(
    col = 2,
    into = c("gender", "age"),
    sep = "-"
  )

# split name and ID
my_data <- my_data %>%
  separate(
    col = 1,
    into = c("ID", "first_name", "last_name"),
    sep = " "
  )




# identify any pure duplications and remove

nrow(my_data) # check length of dataset, n = 34048
nrow(my_data) - nrow(distinct(my_data)) # duplications = 3000

my_data <- distinct(my_data, .keep_all = FALSE)
nrow(my_data) # n = 31048


# Examine instances of the same ID

duplicates <- duplicated(my_data$ID)

duplicated_IDs <- my_data[duplicates, ]

x <- duplicated_IDs[duplicated_IDs$ID == 2191, ] # duplications are multiple tests 

rm(duplicated_IDs)
rm(x)
rm(duplicates)




# Convert .value and time measurement needs to be pivoted wider

my_data <- rename(my_data, time = "time measurement", value = .value)

sum(is.na(my_data$time))  # checking for potential NAs that may affect process
sum(is.na(my_data$value))

my_data <- my_data %>%
  pivot_wider(names_from = time, values_from = value)


# Fix issues with column names

my_data <- rename(my_data, pan_day = "pan day", test_id = "1_test_id")


# Fix column types

summary(my_data) 
colnames(my_data)

my_data <- my_data %>%
  mutate(
    ID = as.numeric(ID),
    gender = as.factor(gender),
    age = as.numeric(age),
    clinic_name = as.factor(clinic_name),
    result = as.factor(result),
    demo_group = as.factor(demo_group),
    drive_thru_ind = as.factor(drive_thru_ind),
    ct_result = as.numeric(ct_result),
    orderset = as.numeric(orderset),
    payor_group = as.factor(payor_group),
    patient_class = as.factor(patient_class),
    pan_day = as.numeric(pan_day),
    test_id = as.factor(test_id),
    row = as.numeric(row),
    rec_ver_tat = as.numeric(rec_ver_tat),
    col_rec_tat = as.numeric(col_rec_tat)
  )



# Remove unnecessary columns from your dataframe: `row, test_id, demo_group` 

colnames(my_data)

my_data <- my_data %>%
  select(-row, -test_id, -demo_group)


# Add new columns, 
  # rec_ver_tat is higher than 100 or not: values High/Low (rvt)
  # numeric column showing `pan_day` (pan_weeks)
  # column showing `drive_thru_ind` as Yes/No
  # A numeric column showing multiplication of `ct_result` and `orderset` for each person

my_data <- my_data %>%
  mutate(rvt = if_else(rec_ver_tat > 100, "High", "Low") %>%
           factor())

my_data <- my_data %>%
  mutate(pan_week = pan_day / 7)

my_data <- my_data %>%
  mutate(dti_yes_no = if_else(drive_thru_ind == 1, "Yes", "No") %>% 
           factor())


my_data <- my_data %>%
  mutate(ct_orderset = ct_result * orderset)


# Set the order of columns as: `id, age, gender` and other columns

my_data <- my_data %>%
  select(ID, age, gender, everything())

# Arrange ID column of your dataset in order of increasing number or alphabetically.

my_data <- my_data %>%
  arrange(ID)


# Read and join the antibody dataset via ID to my_data

join_data <- read_delim("data/exam_joindata.txt", col_names = TRUE)
join_data <- rename(join_data, ID = id) # renamed to match full_join


complete_data <- my_data %>%
  full_join(join_data, join_by(ID))


########## Clean up code with pipes ##########
my_data <- read_delim("data/exam_dataset.txt", col_names = TRUE)

my_data <- my_data %>%
  separate(col = "subject", into = c("ID", "first_name", "last_name"), sep = " ") %>%
  separate(col = "gender-age", into = c("gender", "age"), sep = "-") %>%
  rename("test_id" = "1_test_id", "pan_day" = "pan day", "time_measurement" = "time measurement", "value" = ".value") %>%
  mutate(col_rec_tat = if_else(time_measurement == "col_rec_tat", value, NA)) %>%
  mutate(rec_ver_tat = if_else(time_measurement == "rec_ver_tat", value, NA)) %>%
  mutate(
    ID = as.numeric(ID), gender = as.factor(gender), age = as.numeric(age), clinic_name = as.factor(clinic_name), result = as.factor(result),
    demo_group = as.factor(demo_group), drive_thru_ind = as.factor(drive_thru_ind), ct_result = as.numeric(ct_result), orderset = as.numeric(orderset),
    payor_group = as.factor(payor_group), patient_class = as.factor(patient_class), pan_day = as.numeric(pan_day), test_id = as.factor(test_id),
    row = as.numeric(row), rec_ver_tat = as.numeric(rec_ver_tat), col_rec_tat = as.numeric(col_rec_tat)
  )

# pipe starts failing here - initiating another pipe
my_data <- my_data %>%
  select(-time_measurement, -value, -row, -test_id, -demo_group) %>%
  arrange(ID) %>%
  mutate(rvt = if_else(rec_ver_tat > 100, "High", "Low")) %>%
  mutate(pan_week = pan_day / 7) %>%
  mutate(dti_yes_no = if_else(drive_thru_ind == 1, "Yes", "No")) %>%
  mutate(ct_orderset = ct_result * orderset) %>%
  select(ID, age, gender, everything())

my_data_nd <- unique(my_data)

my_data_nd


## explore combined data sets ----

# comment on the missing variables.

nrow(complete_data) # n = 155524
summary(complete_data) # NAs in ct_results and ct_orderset; lots in payor_group, patient_class, antibody
skimr::skim(complete_data)
naniar::gg_miss_var(complete_data)

# complete cases

percent_complete <- (sum(complete.cases(complete_data)) / nrow(complete_data)) * 100 # 0.83% complete cases, due to antibody data



# Stratify your data by a categorical column and report min, max, mean and sd of a numeric column.

complete_data %>%
  group_by(gender) %>%
  summarise(
    mean(age, na.rm = T),
    max(age),
    min(age),
    sd(age)
  )


# Stratify your data by a categorical column and report min, max, mean and sd of a numeric column for a defined set of observations


# Only for persons with `patient_class == inpatient`

complete_data %>%
  filter(patient_class == "inpatient") %>%
  group_by(gender) %>%
  summarise(
    mean(age, na.rm = T),
    max(age),
    min(age),
    sd(age)
  )


# Only for persons with `ct_result == 45`

complete_data %>%
  filter(ct_result == 45) %>%
  group_by(gender) %>%
  summarise(
    mean(age, na.rm = T),
    max(age),
    min(age),
    sd(age)
  )


# Only for persons tested `pan_day` later than 50

complete_data %>%
  filter(pan_day > 50) %>%
  group_by(gender) %>%
  summarise(
    mean(age, na.rm = T),
    max(age),
    min(age),
    sd(age)
  )


# Only for persons with `drive_thru_ind == 0` and `ct_result` lower than 35

complete_data %>%
  filter(drive_thru_ind == 0 & ct_result < 35) %>%
  group_by(gender) %>%
  summarise(
    mean(age, na.rm = T),
    max(age),
    min(age),
    sd(age)
  )



# Use two categorical columns in your dataset to create a table (hint: ?count)

complete_data %>%
  group_by(gender, dti_yes_no) %>%
  count()


## save tidy data ----
fileName <- paste0("complete_data", ".txt")

write_delim(complete_data, 
            file = here("processed_data", fileName), delim="\t")









