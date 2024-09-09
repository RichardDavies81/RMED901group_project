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

## explore_dataset.txt ----

my_data <- read_delim("data/exam_dataset.txt", col_names = TRUE)

my_data <- my_data %>% 
  separate(col = 2, 
           into = c("gender", "age"), 
           sep = "-")

my_data <- my_data %>% 
  separate(col = 1, 
           into = c("ID", "first_name", "last_name"), 
           sep = " ")


# separate gender and age
