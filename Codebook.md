# Codebook for Peer Assessment

# Approach and Scripts
For this assignment, it is assumed that the current working directory contains the R scripts and that the data have been downloaded using the link above.  They should be uncompressed into a folder called "UCI HAR Dataset" that is a subdirectory of the script directory.
The following are descriptions of the scripts and their related dependencies.

## Main script run_analysis.R
This is the master script for processing the data set.  It requires packages:

+ data.table
+ plyr

### Task 1
The script starts by reading and merging trainig and test data sets in three parts:

- Observations from files "X_train.txt" and "X_test.txt" in the train and test directories, respectively
- Identification numbers of the 30 test subjects for each observation from files "subject_train.txt" and "subject_test.txt".
- Activity numbers for each observation from files "y_train.txt" and "y_test.txt".

Each file combination is then merged using the rbind() command to create files of a single data set.

### Task 2
The script calls another script, meanstd.R (described below), to parse activity names to find only mean and standard deviation values.  It then uses the returned column indices to create a subset data frame.

### Task 3
The script calls another script, translateActivites.R (described below), to translate activity numbers into activity names.  It then merges subject, activity, and observation information into a single data frame.

### Task 4
The script relabels the columns of the data set.  For observations it uses the names from the "features.txt" file.  [See below for additional discussion on data labels.]

### Task 5
The script does a quick check for missing values in the combined data set.  It then converts the data frame to a data table for ease of processing.  It uses the capabilitis of the data.table library to summarize observation values for each combination of subject and activity.  The data is then sorted by subject using the *arrange()* function in the plyr package.
The resulting data set is considered tidy for the purposes of this assignment.  [See below for further discussion.]  The resulting file, "tidydata.txt", is then output in tab-delimited format.
 

## Supporting Scripts
In the course of execution, the run_analysis.R script calls the follwing scripts:

### meanstd.R
This is a script that extracts 66 fields containing mean and standard deviation measurements from among the 561 measures for each row of the corresponding data sets.  [Note: it does not include measures containing meanFreq() since these seemed to be related more to raw data rather than summary data.]
The script is called with the "features.txt" file and does a regular expression search for field names containing the strings mean() and std().  It records their indices within the features list and returns a data frame containing row indices and descriptions of each of the fields.

### translateActivities.R
This script is used as a lookup table to translate activity numbers to names, as described in the file "activity_labels.txt" within the data set.  It creates a character vector with the activity names in the same index order as the corresponding number.  The script is called within the run_analysis.R script with a list created by merging the files "y_train.txt" andn "y_test.txt" that contains activity numbers or each observation of the training and test data sets, respectively.  It then uses lapply and an anonymous function to translate activity numbers into activity names for an input file.  It returns a data frame of activity names.
 
## Variables
In the tidy data file, I included the 66 data measures of mean and standard deviation from the original data file.  I did not include meanFreq() measures since they seemed to be a different type of measure.  The axial measures mean|std()-[X,Y,X] were derived from raw accelerometer and gyroscope readings, but I included them anyway.  These could be further decomposed into the following dimensions:

| Dimension |        Values            |
| --------- | ------------------------ |
| domain    | time, frequency          |
| area      | Body, BodyJerk, Gravity  |
| device    | accelerometer, gyroscope |
| axis      | X, Y, Z, Magnitude       |
| statistic | mean, std                |

I would have liked to reformat the tidy data table into these dimensions.

### Thoughts on Data Labels and Tidy Data
My goal was to create a data table for my tidy data set with the following columns:

| subject | activity | domain | area | device | axis | statistic | value |
| ------- | -------- | ------ | ---- | ------ | ---- | --------- | ----- |

This would produce a very tall, skinny data set with that would better satisfy the rules for tidy data as outlined in http://vita.had.co.nz/papers/tidy-data.pdf.  
Unfortunately, I'm not proficient enough with R to accomplish this task.  I consulted the tutorials provided in the class notes, including http://www.slideshare.net/jeffreybreen/reshaping-data-in-r as well as function help for *melt()* and *dcast()*, but it was still beyond my current skill level.