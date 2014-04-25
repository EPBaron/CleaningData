run_analysis <- function() {
	## script to do the following:
	## 
        ## 1) Merges the training and the test sets to create one data set.
        # Start with training data
        # fetch training data values file
        traindf <- read.delim("./UCI HAR Dataset/train/X_train.txt", header=F, sep="")
        # fetch training activity subject file
        trainsubject <- read.delim("./UCI HAR Dataset/train/subject_train.txt", header=F, sep="")
        # fetch training activity type file
        trainactivity <- read.delim("./UCI HAR Dataset/train/y_train.txt", header=F, sep="")
        
        # Now get test data
        # fetch test data values file
        testdf <- read.delim("./UCI HAR Dataset/test/X_test.txt", header=F, sep="")
        # fetch test activity subject file
        testsubject <- read.delim("./UCI HAR Dataset/test/subject_test.txt", header=F, sep="")
        # fetch test activity type file
        testactivity <- read.delim("./UCI HAR Dataset/test/y_test.txt", header=F, sep="")
        
        # merge training and test data frames
        datamerge <- rbind(traindf, testdf)			# values
        subjectmerge <- rbind(trainsubject, testsubject)	# subjects
        activitymerge <- rbind(trainactivity, testactivity)	# activities
        
        ## 2) Extracts only the measurements on the mean and standard deviation
        ##    for each measurement.
        # source and call function for extracting mean and std fields
        source("./meanstd.R")
        statsdf <- meanstd("features.txt")
        # extract indices from fields of interest
        indices <- as.numeric(statsdf[,1])
        measurements <- as.character(statsdf[,2])
        # subset data to extract only fields of interest
        dataset <- datamerge[,indices]
        
        ## 3) Uses descriptive activity names to name the activities in the data set
        # source and call function for translating activity names into descriptive names
        source("./translateActivities.R")
        activities <- translateActivities(activitymerge, 1)
        # merge subject, activity, and test data
        datasubset <- cbind(subjectmerge, activities, dataset)
        
        ## 4) Appropriately labels the data set with descriptive activity names. 
        # Create vector of data names
        datanames <- c("subject", "activity", measurements)
        # label columns of dataset
        colnames(datasubset) <- datanames
        
        ## 5) Creates a second, independent tidy data set with the average of each 
        ##    variable for each activity and each subject. 
        # First look for missing values
        if(all(colSums(is.na(datasubset))==0)) {cat("no values are NA")}
        # convert data to data.table structure
        library(data.table)
        dt <- data.table(datasubset)
        # make sure subject is treated as a number for future tidying
        datasubset$subject <- as.numeric(datasubset$subject)
        # count number of columns in datatable
        cols <- ncol(dt)
        # summarize datatable over the subject and activities columns
        datasummary <- dt[, lapply(.SD, mean), by=list(subject, activity),
                          .SDcols=3:cols]
        # order data, first by subject then by activity
        # use plyr package for simpler syntax
        library(plyr)
        tidydata <- arrange(datasummary, subject, activity)
        # write output file
        write.table(tidydata, file="./tidydata.txt", sep="\t", row.names=F)
                
}
