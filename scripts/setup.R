# setup ----

library(tidyverse) # loading package for cleaning of data
# install.packages("tidyverse")

library(here) # for targeting directory
here()

dir.create("data")
dir.create("figures")
dir.create("processed_data")
dir.create("results")
dir.create("scripts")

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

nrow(my_data)  # check length of dataset
unique(my_data$ID) # check duplication of dataset


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

