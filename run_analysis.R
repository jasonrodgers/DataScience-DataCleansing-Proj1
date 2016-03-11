
## download and unzip the source data
path <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(path, "dataset.zip")
unzip("dataset.zip")

## load activity labels
activityLabels <- read.table("UCI HAR Dataset\\activity_labels.txt")

## update activityLabel column names
names(activityLabels) <- c("activityId", "activityName")

## load test/training result column names
columnNames <- read.table("UCI HAR Dataset\\features.txt")

## load test data
## load test subjects
testSubjects <- read.table("UCI HAR Dataset\\test\\subject_test.txt")

## update testSubects column names
names(testSubjects) <- c("subjectId")

## load test activities
testActivities <- read.table("UCI HAR Dataset\\test\\y_test.txt")

## update testActivities names
names(testActivities) <- c("activityId")

## load test resultssou
testResults <- read.table("UCI HAR Dataset\\test\\X_test.txt")

## update testResults column names
names(testResults) <- columnNames[[2]]

## now get only the mean and std results
names <- names(testResults)
testResults <- testResults[,names[grepl("mean\\(\\)|std\\(\\)", names)]]

## add activityId to testResults
testResults$activityId <- testActivities$activityId

## add subjectId to testResults
testResults$subjectId <- testSubjects$subjectId

## add a type to testResults indicating "test"
testResults$type <- "test"

## merge in activity labels
testResultsMerged <- 
  merge(testResults, activityLabels, by.x="activityId", by.y="activityId")

## remove activity id, it is no longer needed now that we have the labels
testResultsMerged$activityId <- NULL

## load training data
## load train subjects
trainSubjects <- read.table("UCI HAR Dataset\\train\\subject_train.txt")

## update trainSubjects column names
names(trainSubjects) <- c("subjectId")

## load train activities
trainActivities <- read.table("UCI HAR Dataset\\train\\y_train.txt")

## update trainActivities names
names(trainActivities) <- c("activityId")

## load train results
trainResults <- read.table("UCI HAR Dataset\\train\\X_train.txt")

## update trainResults column names
names(trainResults) <- columnNames[[2]]

## now get only the mean and std results
names <- names(trainResults)
trainResults <- trainResults[,names[grepl("mean\\(\\)|std\\(\\)", names)]]

## add activityId to trainResults
trainResults$activityId <- trainActivities$activityId

## add subjectId to trainResults
trainResults$subjectId <- trainSubjects$subjectId

## add a type to trainResults indicating "train"
trainResults$type <- "train"

## merge in activity labels
trainResultsMerged <- 
  merge(trainResults, activityLabels, by.x="activityId", by.y="activityId")

## remove activity id, it is no longer needed now that we have the labels
trainResultsMerged$activityId <- NULL

## merge the test and train results
resultsMerged <- rbind(testResultsMerged, trainResultsMerged)

## write the merged data out to a file
## NOT NEEDED write.csv(resultsMerged, file = "testTrainMerged.csv",row.names=FALSE)

## load the dplyr library for summation
if (!("dplyr" %in% installed.packages())) install.packages("dplyr")
library(dplyr)

## summarize results by activity and subject
groupedResultsMerged <- resultsMerged %>% 
    group_by(activityName, subjectId) %>% 
    summarise_each(funs(mean), -subjectId, -type, -activityName)

## update the column names on the summarized result set
n <- names(groupedResultsMerged)
names(groupedResultsMerged) <- 
  ifelse(n %in% c('activityName', 'subjectId'), n,  paste("Mean", n, sep = "_"))

## write the summerized date out to a file
write.table(groupedResultsMerged, file = "testTrainSummerized.txt",row.names=FALSE)
