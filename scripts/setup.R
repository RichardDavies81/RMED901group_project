# setup ----

library(tidyverse) # loading package for cleaning of data
# install.packages("tidyverse")

library(here) # for targeting directory
here()

#dir.create("data")
#dir.create("figures")
#dir.create("processed_data")
#dir.create("results")
#dir.create("scripts")

## explore_dataset.txt and edit dataset----


my_data <- read_delim("data/exam_dataset.txt", col_names = TRUE)

# split gender and age
my_data <- my_data %>% 
  separate(col = 2, 
           into = c("gender", "age"), 
           sep = "-")

# split name and ID
my_data <- my_data %>% 
  separate(col = 1, 
           into = c("ID", "first_name", "last_name"), 
           sep = " ")

nrow(my_data)  # check length of dataset, 12344
length(unique(my_data$ID)) # check duplication of ID, 34048


# identify any pure duplications

nrow(my_data)
nrow(distinct(my_data))

my_data <- distinct(my_data, .keep_all = FALSE)


# work on widen time measurement 

my_data <- rename(my_data, time = 'time measurement', value = .value)

sum(is.na(my_data$time))
sum(is.na(my_data$value))

my_data <- my_data %>% 
  pivot_wider(names_from = time, values_from = value)

unique(my_data$ID) # 11344
nrow(my_data) # 15524

# look for duplication in ID to further assess

duplicates <- duplicated(my_data$ID)

duplicated_IDs <- my_data[duplicates, ]

x <- duplicated_IDs[duplicated_IDs$ID ==2191, ] # Indicates clinic name and patient class, likely not an issue

rm(duplicated_IDs)
rm(x)
rm(duplicates)

# noticed an issue with pan day- rename

my_data <- rename(my_data, pan_day = 'pan day', test_id = '1_test_id')


# change data types

summary(my_data) # everything is a character, OH NO!
colnames(my_data)

test <- my_data %>%
  mutate(
    ID = as.numeric(ID),
    gender = as.factor(gender),
    age = as.numeric(age),
    clinic_name = as.factor(clinic_name),
    result = as.factor(result),
    demo_group = as.factor(demo_group),
    drive_thru_ind = as.factor(drive_thru_ind),
    ct_result = as.numeric(ct_result),
    orderset = as.factor(orderset),
    payor_group = as.factor(payor_group),
    patient_class = as.factor(patient_class),
    pan_day = as.numeric(pan_day),
    test_id = as.factor(test_id),
    row = as.numeric(row),
    rec_ver_tat = as.numeric(rec_ver_tat),
    col_rec_tat = as.numeric(col_rec_tat)
    )

##### Note- issue with clinic_name, only 1 level 

# examine row to check if this is the key for exam_joindata

join_data <- read_delim("data/exam_joindata.txt", col_names = TRUE)

range(join_data$id)
range(my_data$ID)


