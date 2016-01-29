


tidydata.csv
-----------

Variables
---

Average of the Mean and standard deviation of the following signals:
tBodyAcc-XYZ            Body acceleration measures
tGravityAcc-XYZ         Gravity acceleration measures
tBodyAccJerk-XYZ        Jerk signals
tBodyGyro-XYZ           Body gyro measure
tBodyGyroJerk-XYZ       Jerk signals
fBodyAcc-XYZ            FFT
fBodyAccJerk-XYZ        FFT
fBodyGyro-XYZ           FFT
activities              Activity type (labels) [WALKING|WALKING_UPSTAIRS|WALKING_DOWNSTAIRS|SITTING|STANDING|LAYING]
subjects                Subject id


extracted_measures.csv
-----------

Variables
---

Mean and standard deviation of the following signals:
tBodyAcc-XYZ            Body acceleration measures
tGravityAcc-XYZ         Gravity acceleration measures
tBodyAccJerk-XYZ        Jerk signals
tBodyGyro-XYZ           Body gyro measure
tBodyGyroJerk-XYZ       Jerk signals
fBodyAcc-XYZ            FFT
fBodyAccJerk-XYZ        FFT
fBodyGyro-XYZ           FFT
activities              Activity type (labels) [WALKING|WALKING_UPSTAIRS|WALKING_DOWNSTAIRS|SITTING|STANDING|LAYING]
subjects                Subject id


Program design
run_analysis.R 
-----------

1. Load all data (train, test, subject id, features id)
and transform to data table which are readable using dplyr package

Merge data by row (row binding) train and test data 
and merge by columns (measures, activities and subjects) to have one data set.
Merging by columns is made using columns addition
The resulting merged dataset is stored in variable merge_data


2. Get measures label dataset
and extract using grep the labels corresponding to mean and standard deviation.
Variable filtered_features stores the resulting extracted labels.
The column containing extracted feature labels is used to select the columns we need
to extract in the merged dataset.
The resulting merged dataset with filtered measure is stored in variable extracted_measures


3. Get activities dataset (ids and label)
Change the activity ids in extracted_measures dataset to activity labels using activities dataset as hash array.


4. Add two more row to filtered_features.
These rows correspond to activities and subjects column name.
Replace all column names of extracted_measures by the new filtered_features.
The resulting dataset is stored in extracted_measures.
Save the dataset in csv file => extracted_measures.csv


5. Group extracted_measures by activites and subjects
and use each group to compute for each column the mean of each measure
Write the tidy data to tidydata.csv file without the row numbers (row.names = FALSE)
