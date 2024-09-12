# RMED901group_project

Comments on the project:

# Added columns

rvt = rec_ver_tat, over 100 = High
                 , under 100 = Low
                 
pan_weeks = pan_days/7

dti_yes_no = drive_thru_ind converted to yes (=1) or no (=0)

ct_orderset = ct_result x orderset

# Removed columns

row

test_id

demo_group

# New dataframes

Data frames

Supplied datasets combined by ID as a full join into "complete_data"

# Potential issues

Age, many women and men at 119, and one at 138!!!

# Plots

Correlation matrix heatmap

Boxplot

# Checklist for the final project:
- [X] Create GitHub repo and Rprojects
- [X] Tidy the data
  - [x] Each row is one observation, each column is one variable
  - [x] Names of columns do not have punctuation signs
  - [x] Names of columns do not start with numbers
  - [x] Names of columns are meaningful
- [x] Explore data
- [x] Save tidied data in a file (tidied data is meanwhile called "complete_data")
- [x] Update README
- [x] Create updated codebook for tidy data
- [X] Style the script(s) using [{styler}](https://styler.r-lib.org/)

- [X] Manipulate/wrangle data
  - [X] Some columns were deleted
  - [X] Some columns were added
- [X] Save manipulated data in a file
- [X] Update README
- [X] Create updated codebook for tidy data
- [x] Style the script(s) using [{styler}](https://styler.r-lib.org/)

- [X] Create plots
- [X] Style the script(s) using [{styler}](https://styler.r-lib.org/)
- [X] Update README

- [ ] Analyze data
- [ ] Style the script(s) using [{styler}](https://styler.r-lib.org/)
- [ ] Update README if more files were created

- [ ] Create Rmd report
- [ ] Check .html output and adjust Rmd to look nice; repeat if needed

- [ ] Check repository if all needed files are present, clean up
