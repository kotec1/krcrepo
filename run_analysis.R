library(dplyr)
# Read into R the activity files
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",header = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",header = FALSE)
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt",header = FALSE)
activity_test <- read.table("UCI HAR Dataset/test/y_test.txt",header = FALSE)
measurements_test <- read.table("UCI HAR Dataset/test/X_test.txt",header = FALSE)
measurements_train <- read.table("UCI HAR Dataset/train/X_train.txt",header = FALSE)

##merge the tain and test data sets vertically
subjectData <- rbind(subject_train, subject_test)
activityData <- rbind(activity_train, activity_test)
measurementData <- rbind(measurements_test, measurements_train)

##use desciptive names for the variables
names(subjectData) <- c("subject_ID")
names(activityData) <- c("activity_ID")
measurementDataNames <- read.table("UCI HAR Dataset/features.txt",header = FALSE)
names(measurementData) <- measurementDataNames$V2

## merge data and variable names
merge_ID_Data <- cbind(subjectData, activityData)
Data <- cbind(measurementData, merge_ID_Data)

##Extract the data containig mean and std dev
pmeasurementDataNames <- measurementDataNames$V2[grep("mean\\(\\)|std\\(\\)", measurementDataNames$V2)]
namesLst <- c(as.character(pmeasurementDataNames), "subject_ID", "activity_ID")
fData <- subset(Data, select = namesLst)

## use descriptive names for variables
names(fData)<- gsub("^t", "time", names(fData))
names(fData)<- gsub("^f", "frequency", names(fData))
names(fData)<- gsub("Acc", "Accelorometer", names(fData))
names(fData)<- gsub("Gyro", "Gyroscope", names(fData))
names(fData)<- gsub("Mag", "Magnitude", names(fData))
names(fData)<- gsub("BodyBody", "Body", names(fData))

tidy_data <- aggregate(. ~subject_ID + activity_ID, fData, mean)
tidy_data <- tidy_data[order(tidy_data$subject_ID, tidy_data$activity_ID),]
write.table(tidy_data, file = "tidydata.txt", row.name = FALSE)

