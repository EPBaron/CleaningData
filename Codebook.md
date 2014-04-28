# Codebook for Peer Assessment
For reference, this is when I downloaded the data set:
> datedownloaded <- date()
> datedownloaded
[1] "Fri Apr 18 12:15:45 2014"

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

I would have liked to reformat the tidy data table into these dimensions.  Instead, I left them in their original form for the reasons below.

domain	area	device	axis	stat	dim     measure
time	Body	Accelerometer	Mag	mean	tBodyAccMag-mean()
time	Body	Accelerometer	X	mean	tBodyAcc-mean()-X
time	Body	Accelerometer	Y	mean	tBodyAcc-mean()-Y
time	Body	Accelerometer	Z	mean	tBodyAcc-mean()-Z
time	Body	Accelerometer	Mag	std	tBodyAccMag-std()
time	Body	Accelerometer	X	std	tBodyAcc-std()-X
time	Body	Accelerometer	Y	std	tBodyAcc-std()-Y
time	Body	Accelerometer	Z	std	tBodyAcc-std()-Z
time	Body	Gyroscope	Mag	mean	tBodyGyroMag-mean()
time	Body	Gyroscope	X	mean	tBodyGyro-mean()-X
time	Body	Gyroscope	Y	mean	tBodyGyro-mean()-Y
time	Body	Gyroscope	Z	mean	tBodyGyro-mean()-Z
time	Body	Gyroscope	Mag	std	tBodyGyroMag-std()
time	Body	Gyroscope	X	std	tBodyGyro-std()-X
time	Body	Gyroscope	Y	std	tBodyGyro-std()-Y
time	Body	Gyroscope	Z	std	tBodyGyro-std()-Z
time	BodyJerk	Accelerometer	Mag	mean	tBodyAccJerkMag-mean()
time	BodyJerk	Accelerometer	X	mean	tBodyAccJerk-mean()-X
time	BodyJerk	Accelerometer	Y	mean	tBodyAccJerk-mean()-Y
time	BodyJerk	Accelerometer	Z	mean	tBodyAccJerk-mean()-Z
time	BodyJerk	Accelerometer	Mag	std	tBodyAccJerkMag-std()
time	BodyJerk	Accelerometer	X	std	tBodyAccJerk-std()-X
time	BodyJerk	Accelerometer	Y	std	tBodyAccJerk-std()-Y
time	BodyJerk	Accelerometer	Z	std	tBodyAccJerk-std()-Z
time	BodyJerk	Gyroscope	Mag	mean	tBodyGyroJerkMag-mean()
time	BodyJerk	Gyroscope	X	mean	tBodyGyroJerk-mean()-X
time	BodyJerk	Gyroscope	Y	mean	tBodyGyroJerk-mean()-Y
time	BodyJerk	Gyroscope	Z	mean	tBodyGyroJerk-mean()-Z
time	BodyJerk	Gyroscope	Mag	std	tBodyGyroJerkMag-std()
time	BodyJerk	Gyroscope	X	std	tBodyGyroJerk-std()-X
time	BodyJerk	Gyroscope	Y	std	tBodyGyroJerk-std()-Y
time	BodyJerk	Gyroscope	Z	std	tBodyGyroJerk-std()-Z
time	Gravity	Accelerometer	Mag	mean	tGravityAccMag-mean()
time	Gravity	Accelerometer	X	mean	tGravityAcc-mean()-X
time	Gravity	Accelerometer	Y	mean	tGravityAcc-mean()-Y
time	Gravity	Accelerometer	Z	mean	tGravityAcc-mean()-Z
time	Gravity	Accelerometer	Mag	std	tGravityAccMag-std()
time	Gravity	Accelerometer	X	std	tGravityAcc-std()-X
time	Gravity	Accelerometer	Y	std	tGravityAcc-std()-Y
time	Gravity	Accelerometer	Z	std	tGravityAcc-std()-Z
frequency	Body	Accelerometer	Mag	mean	fBodyAccMag-mean()
frequency	Body	Accelerometer	X	mean	fBodyAcc-mean()-X
frequency	Body	Accelerometer	Y	mean	fBodyAcc-mean()-Y
frequency	Body	Accelerometer	Z	mean	fBodyAcc-mean()-Z
frequency	Body	Accelerometer	Mag	std	fBodyAccMag-std()
frequency	Body	Accelerometer	X	std	fBodyAcc-std()-X
frequency	Body	Accelerometer	Y	std	fBodyAcc-std()-Y
frequency	Body	Accelerometer	Z	std	fBodyAcc-std()-Z
frequency	Body	Gyroscope	Mag	mean	fBodyBodyGyroMag-mean()
frequency	Body	Gyroscope	X	mean	fBodyGyro-mean()-X
frequency	Body	Gyroscope	Y	mean	fBodyGyro-mean()-Y
frequency	Body	Gyroscope	Z	mean	fBodyGyro-mean()-Z
frequency	Body	Gyroscope	Mag	std	fBodyBodyGyroMag-std()
frequency	Body	Gyroscope	X	std	fBodyGyro-std()-X
frequency	Body	Gyroscope	Y	std	fBodyGyro-std()-Y
frequency	Body	Gyroscope	Z	std	fBodyGyro-std()-Z
frequency	BodyJerk	Accelerometer	Mag	mean	fBodyBodyAccJerkMag-mean()
frequency	BodyJerk	Accelerometer	X	mean	fBodyAccJerk-mean()-X
frequency	BodyJerk	Accelerometer	Y	mean	fBodyAccJerk-mean()-Y
frequency	BodyJerk	Accelerometer	Z	mean	fBodyAccJerk-mean()-Z
frequency	BodyJerk	Accelerometer	Mag	std	fBodyBodyAccJerkMag-std()
frequency	BodyJerk	Accelerometer	X	std	fBodyAccJerk-std()-X
frequency	BodyJerk	Accelerometer	Y	std	fBodyAccJerk-std()-Y
frequency	BodyJerk	Accelerometer	Z	std	fBodyAccJerk-std()-Z
frequency	BodyJerk	Gyroscope	Mag	mean	fBodyBodyGyroJerkMag-mean()
frequency	BodyJerk	Gyroscope	Mag	std	fBodyBodyGyroJerkMag-std()


### Thoughts on Data Labels and Tidy Data
My goal was to create a data table for my tidy data set with the following columns:

| subject | activity | domain | area | device | axis | statistic | value |
| ------- | -------- | ------ | ---- | ------ | ---- | --------- | ----- |

This would produce a very tall, skinny data set with that would better satisfy the rules for tidy data as outlined in http://vita.had.co.nz/papers/tidy-data.pdf.  
Unfortunately, I'm not proficient enough with R to accomplish this task.  I consulted the tutorials provided in the class notes, including http://www.slideshare.net/jeffreybreen/reshaping-data-in-r as well as function help for *melt()* and *dcast()*, but it was still beyond my current skill level.