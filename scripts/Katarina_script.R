install.packages("readr")
install.packages("tidyr")
library(readr)
library(tidyr)


#Import txt file
data <- read_delim("C:/Users/Katarina/Documents/RMED901group_project/data/exam_dataset.txt", delim = "\t", col_names = TRUE)
head(data)
tail(data)

#Checklist:
#Are there only unique observations in the dataset?
any(duplicated(data)) # TRUE
sum(duplicated(data)) # 3000
any(duplicated(data$subject)) #TRUE


#Are there any column names starting with a number, containing spaces etc.?
# List all column names
colnames(data)
# 1_test_id and .value and pan day should be changed:
# Rename columns
data <- data %>%
  dplyr::rename(
    test_id = `1_test_id`,
    value = `.value`,
    pan_day = `pan day`  # Fix: `pan day` needs to be in backticks
  )

# Gives an error "1_test_id" because change has already been performed on original data.
# Now making a test dataset for coming changes:

test <- data


# View the updated data
colnames(data)
#pan day is still not changed to pan_day

# Rename columns in the original data
data <- data %>%
  dplyr::rename(
    pan_day = `pan day`  # Rename pan day, no need to rename 1_test_id again
  )

# Now make a test dataset for further changes
test <- data

# View the updated column names to confirm changes
colnames(data)


# Separate gender-age into separate columns

# Separate gender-age into Gender and Age columns
data <- data %>%
  tidyr::separate(`gender-age`, into = c("Gender", "Age"), sep = "-")


# Put the ID and names from the column "subject" into its own columns

# Separate the 'subject' column into 'ID' and 'Name'
data <- data %>%
  tidyr::separate(subject, into = c("ID", "Name"), sep = " ", extra = "merge")


#Are all variables present as columns?
#Are there any columns containing combined variables?

# Reshape the data using pivot_wider

library(dplyr)

# Transform time measurement into separate columns
data_wide <- data %>%
  group_by(row) %>%  # Assuming 'row' is the unique identifier
  mutate(
    rec_ver_tat = ifelse(`time measurement` == "rec_ver_tat", value, NA),
    col_rec_tat = ifelse(`time measurement` == "col_rec_tat", value, NA)
  ) %>%
  summarize(
    rec_ver_tat = max(rec_ver_tat, na.rm = TRUE),
    col_rec_tat = max(col_rec_tat, na.rm = TRUE)
  )


# Merge the wide format back to the original data based on 'row' (or any other unique key)
data_combined <- data %>%
  left_join(data_wide, by = "row")


# From now use the data_combined (and test with the test dataset first)
# Check variable types - comment on any changes you would like to make but do not make any changes
# Check the structure of the dataset and the types of variables
str(data_combined)

# Check the type of each column
sapply(data_combined, class)

# ID column: If "ID" is not used in calculations and is just a unique identifier, it could be converted into a factor or character to save memory.
# Age column: Ensure "Age" is numeric. If it's stored as a character, it should be converted to numeric.
# Name column: This column is a character and could remain as such, but if there are many repeated names, you could consider converting it to a factor.
# Height column: It is correctly numeric, so no changes are necessary unless it’s incorrectly stored as a character.

# Day 6: Tidy, adjust, and explore. 
#Remove unnecessary columns from your dataframe: `row, test_id, demo_group`

# Remove the 'row', 'test_id', and 'demo_group' columns
data_combined <- data %>% select(-row, -test_id, -demo_group)

# View the updated dataframe
head(data_combined)

# Make necessary changes in variable types
# Create a set of new columns:
# A column showing whether `rec_ver_tat` is higher than 100 or not: values High/Low

# Create a new column 'rec_ver_tat_status' showing whether 'rec_ver_tat' is High (>100) or Low (<=100)
#test <- data_combined %>%
#  mutate(rec_ver_tat_status = ifelse(rec_ver_tat > 100, "High", "Low"))

# View the updated data
#colnames(data_combined)

# Check if 'rec_ver_tat' exists and inspect the first few rows
head(data_combined$rec_ver_tat)

# Check the type of the 'rec_ver_tat' column
class(data_combined$rec_ver_tat)

# Convert 'rec_ver_tat' to numeric (if needed) and create the new column
data_combined <- data_combined %>%
  mutate(rec_ver_tat = as.numeric(rec_ver_tat),  # Ensure the column is numeric
         rec_ver_tat_status = ifelse(rec_ver_tat > 100, "High", "Low"))

# Check the first few rows of the updated dataset
head(data_combined)


# A numeric column showing `pan_day` in weeks


# Create a new numeric column 'pan_day_weeks' that shows 'pan_day' in weeks
data_combined <- data_combined %>%
  mutate(pan_day_weeks = pan_day / 7)

# View the first few rows of the updated data
head(data_combined)


# A column showing `drive_thru_ind` as Yes/No

# Create a new column 'drive_thru_ind_status' with Yes/No based on 'drive_thru_ind'
data_combined <- data_combined %>%
  mutate(drive_thru_ind_status = ifelse(drive_thru_ind == 1, "Yes", "No"))


# A numeric column showing multiplication of `ct_result` and `orderset` for each person

# Create a new numeric column 'ct_orderset_multiplication'
data_combined <- data_combined %>%
  mutate(ct_orderset_multiplication = ct_result * orderset)



# Set the order of columns as: `id, age, gender` and other columns
# Arrange ID column of your dataset in order of increasing number or alphabetically.
# Read and join the additional dataset to your main dataset.
# Connect above steps with pipe.
# Explore your data.
# Explore and comment on the missing variables.
# Stratify your data by a categorical column and report min, max, mean and sd of a numeric column.
# tratify your data by a categorical column and report min, max, mean and sd of a numeric column for a defined set of observations - use pipe!
#  Only for persons with `patient_class == inpatient`
# Only for persons with `ct_result == 45`
# Only for persons tested `pan_day` later than 50
# Only for persons with `drive_thru_ind == 0` and `ct_result` lower than 35
# Use two categorical columns in your dataset to create a table (hint: ?count)


# Save the tidy data and explore it

