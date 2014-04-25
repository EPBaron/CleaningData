meanstd <- function(inputfile) {
## function to extract the variables that describe mean and standard deviation values
## from description of dataset fields
  	# read list of fields and split into index/field pairs
	fieldlist <- read.delim(file=inputfile, header=F, sep = " ")
  
  	# extract lines ending in either "mean()" or "std()"
  	meanlines <- grep("mean()", fieldlist[,2], fixed=T)
  	stdlines <- grep("std()", fieldlist[,2], fixed=T)
  
  	# combine lines and sort into index list
	index <- sort(c(meanlines, stdlines))
  
  	# return a dataframe with fields and their indices
  	fieldlist[index,]
}