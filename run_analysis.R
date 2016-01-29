
# Load all necessary libraries

library(dplyr)
library(tidyr)
library(data.table)

#
# Load all data (train, test, subject id, features id)
# and transform to data table which are readable using dplyr package
#
X_train <- fread("./UCI HAR Dataset/train/X_train.txt")
y_train <- fread("./UCI HAR Dataset/train/y_train.txt")
subject_train <- fread("./UCI HAR Dataset/train/subject_train.txt")

X_test <- fread("./UCI HAR Dataset/test/X_test.txt")
y_test <- fread("./UCI HAR Dataset/test/y_test.txt")
subject_test <- fread("./UCI HAR Dataset/test/subject_test.txt")

X_train_data <- tbl_df(X_train)
y_train_data <- tbl_df(y_train)
subject_train_data <- tbl_df(subject_train)

X_test_data <- tbl_df(X_test)
y_test_data <- tbl_df(y_test)
subject_test_data <- tbl_df(subject_test)

#
# Merge data by row (row binding) train and test data (measures, activities and subjects)
# and merge by columns to have one data set.
# Merging by columns is made using columns addition
# The resulting merged dataset is merge_data
#
X <- bind_rows(X_train_data, X_test_data)
y <- bind_rows(y_train_data, y_test_data)
subject <- bind_rows(subject_train_data, subject_test_data)

merge_data <- X
merge_data$activities <- y$V1
merge_data$subjects <- subject$V1

#
# Get measures label dataset
# and extract using grep the labels corresponding to mean and standard deviation.
# filtered_features stores the resulting extracted labels.
# The column containing extracted feature labels is used to select the columns we need
# to extract in the merged dataset.
# The resulting merged dataset with filtered measure is extracted_measures
#
features <- fread("./UCI HAR Dataset/features.txt")
features_data <- tbl_df(features)

filtered_features <- features_data %>%
  mutate(grpmean = grepl("^.*-mean\\(\\)-.*", as.character(V2))) %>%
  mutate(grpstd = grepl("^.*-std\\(\\)-.*", as.character(V2))) %>%
  filter(grpmean==TRUE | grpstd==TRUE)

extracted_measures <- select(merge_data, filtered_features$V1, activities:subjects)

#
# Get activities dataset (ids and label)
# Change the activity ids in extracted_measures dataset to activity labels using activities dataset as hash array
#
activities <- fread("./UCI HAR Dataset/activity_labels.txt")
activities_data <- tbl_df(activities)

extracted_measures <- mutate(extracted_measures, activities = activities_data$V2[extracted_measures$activities])


#
# Add two more row to filtered_features. These rows correspond to activities and subjects column name
# Replace all column names of extracted_measures by the new filtered_features.
# extracted_measures is the dataset.
# Save the dataset in csv file.
#
filtered_features <- rbind(filtered_features, c("activities", "activities"))
filtered_features <- rbind(filtered_features, c("subjects", "subjects"))
names(extracted_measures) <- filtered_features$V2

write.csv(extracted_measures, file = "./extracted_measures.csv", row.names = FALSE)

#
# Group extracted_measures by activites and subjects
# and use each group to compute for each column the mean of each measure
#
d <- group_by(extracted_measures, activities, subjects)
mn <- summarise_each(d, funs(mean))

#
# Write the tidy data to tidydata.csv file without the row numbers (row.names = FALSE)
#
write.csv(mn, file = "./tidydata.csv", row.names = FALSE)


