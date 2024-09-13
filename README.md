RMED901group_project

Group4, members: Richard Davies, Katarina Lundervol, Pakwanja Desiree Twea


description: Learning tasks for the course RMED901 Tidy. Files provided by Julia Romanowska through mitt.uib.no. Files include a description of the data (codebook_exam_data.html), two datasets (exam.dataset.txt and exam_joindata.txt) and a description of tasks (exam.descr.md) 

description of data: The data is composed of two datasets with otherlapping patients (see ID), exam.dataset.txt consists of PCR rdts for COVID19 during the 2020 pandemic, data includes information on patientS including clinic, gender, test results week of pandemic, and exam_joindata.txt containing endpoint titer data from some of the patients (information can be found in the files codebook_exam_data.html, exam.descr.md)

# Folder structure
The folders are organized as the following
main: R_markdown.Rmd
data: exam.dataset.txt, exam_joindata.txt, codebook_exam_data.html, exam.descr.md
processed_data: complete_data.txt
figures: (if we are not using this it can be removed)
results: (consider moving the R-markdown file to here for the report)
scripts: viz.R, setup.R, analysis.R


Project information:

# 1) Data clean summary

Script use: setup.R (see folder: scripts) 

Packages used: "tidyverse", "here"
The files exam.dataset.txt and exam_joindata.txt were combined in a tidyr format, and a clean dataset was produced (see complete_data.txt, folder: processed data. 
The following changes were made to the data. 
Column "subject", separated into "ID", "first_name", "last_name"
Column "gender-age" separated into "gender", "age"
Row duplications were removed (n= 3000)
Columns were rename as per the following "test_id" = "1_test_id", "pan_day" = "pan day", "time_measurement" = "time measurement", "value" = ".value"
Two new columns were produced (rec_ver_tat and col_rec_tat) from time_measurement and value
Columns row, test_id, and demo_group were removed
Rows were arranged in accending order based on ID
New columns were produced:  rvt = rec_ver_tat > 100 are listed as "High" and < 100 as "Low"
                            dti_yes_no = drive_thru_ind == 1 listed as "yes", otherwise "no"
                            ct_orderset = ct_result multipled by orderset
Columns were ordered with ID, age, gender first (col 1, 2, 3)
exam.dataset.txt and exam_joindata.txt were joined.

Columns were assigned as the following data types:
  numeric- ID, age, ct_result, orderset, pan_day, pan_week, rec_ver_tat, col_rec_tat, ct_orderset and antibody
  factor- gender, clinic name, result, drive_thru_ind, payor_group, patient_class, rvt


# Potential issues noted

Age: many women and men at 119, and one at 138
Antibody endpoint titer data is limited (300 samples)
Data should be anonymized via removal of last and first name of patients





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
- [X] Save tidied data in a file (tidied data is meanwhile called "complete_data")
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

- [X] Analyze data
- [X] Style the script(s) using [{styler}](https://styler.r-lib.org/)
- [X] Update README if more files were created

- [ ] Create Rmd report (not updated yet)
- [ ] Check .html output and adjust Rmd to look nice; repeat if needed (not updated yet)

- [ ] Check repository if all needed files are present, clean up (not cleaned yet)
