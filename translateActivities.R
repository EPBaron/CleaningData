## Function to translate activity labels from the y-(train/test).txt files
## into activity names using the activity_labels.txt file

translateActivities <- function(data, col=1) {
	# create vector of labels where index = activity number
	activities <- c("Walking","Walking_Upstairs","Walking_Downstairs",
			"Sitting","Standing","Laying")
	# translate numbers into activities
	newy <- lapply(data, function(x) data[x,col] = activities[x])
	# return data frame of activity labels
	as.data.frame(newy)
}