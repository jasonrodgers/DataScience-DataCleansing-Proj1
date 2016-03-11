# DataScience-DataCleansing-Proj1
###Coursera Data Science Data Cleansing Final Project

To run the run_analysis.R script, copy it to your working directory and execute
the below command.  The dplyr package is required to run the script, but the script
will automatically install dplyr if it is not already installed.

```r
if (!("dplyr" %in% installed.packages())) install.packages("dplyr")
source("run_analysis.R")
```

The script will download the dataset.zip file from the link below, unzip the 
file, and process it.

[dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The zip file contains test and training sets of data.  These data sets are merged 
and then the mean and standard deviation variables are averaged by activity and 
subject to produce the output data set -> testTrainSummerized.txt
