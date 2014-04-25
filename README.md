# Peer Assessment Assignment for Getting and Cleaning Data
============

This repository contains data files and R scripts for the Peer Assessment assignment which is part of the Johns Hopkins Coursera class on Getting and Cleaning Data.  The assignment instructions were as follows:

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

 You should create one R script called run_analysis.R that does the following. 

    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive activity names. 
    5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Approach and Scripts
For this assignment, it is assumed that the current working directory contains the R scripts and that the data have been downloaded using the link above.  They should be uncompressed into a folder called "UCI HAR Dataset" that is a subdirectory of the script directory.
The following are descriptions of the scripts and their related dependencies.

## Main script run_analysis.R
This is the master script for processing the data set.  It requires packages:
data.table
plyr

### Task 1
The script starts by reading and merging trainig and test data sets in three parts:
Observations from files "X_train.txt" and "X_test.txt" in the train and test directories, respectively
Identification numbers of the 30 test subjects for each observation from files "subject_train.txt" and "subject_test.txt".
Activity numbers for each observation from files "y_train.txt" and "y_test.txt".
Each file combination is then merged using the rbind() command to create files of a single data set.

### Task 2
The script calls another script, meanstd.R (described below), to parse activity names to find only mean and standard deviation values.  It then uses the returned column indices to create a subset data frame.

### Task 3
The script calls another script, translateActivites.R (described below), to translate activity numbers into activity names.  It then merges subject, activity, and observation information into a single data frame.

### Task 4
The script relabels the columns of the data set.  For observations it uses the names from the "features.txt" file.  [See below for additional discussion on data labels.]

### Task 5
The script does a quick check for missing values in the combined data set.  It then converts the data frame to a data table for ease of processing.  It uses the capabilitis of the data.table library to summarize observation values for each combination of subject and activity.  The data is then sorted by subject using the arrange() function in the plyr package.
The resulting data set is considered tidy for the purposes of this assignment.  [See below for further discussion.]  The resulting file, "tidydata.txt", is then output in tab-delimited format.

## Supporting Scripts
In the course of execution, the run_analysis.R script calls the follwing scripts:

### meanstd.R
This is a script that extracts 66 fields containing mean and standard deviation measurements from among the 561 measures for each row of the corresponding data sets.  [Note: it does not include measures containing meanFreq() since these seemed to be related more to raw data rather than summary data.]
The script is called with the "features.txt" file and does a regular expression search for field names containing the strings mean() and std().  It records their indices within the features list and returns a data frame containing row indices and descriptions of each of the fields.

### translateActivities.R
This script is used as a lookup table to translate activity numbers to names, as described in the file "activity_labels.txt" within the data set.  It creates a character vector with the activity names in the same index order as the corresponding number.  The script is called within the run_analysis.R script with a list created by merging the files "y_train.txt" andn "y_test.txt" that contains activity numbers or each observation of the training and test data sets, respectively.  It then uses lapply and an anonymous function to translate activity numbers into activity names for an input file.  It returns a data frame of activity names.

## Thoughts on Data Labels and Tidy Data

