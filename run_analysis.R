
fetchData <- function(url, dir, zipFileName) {
    if (!file.exists(zipFileName)) {
        download.file(url, zipFileName)
    }
    
    if (!file.exists(dir)) {
        unzip(zipFileName)
    }
}


loadAndMergeData <- function(dir) {
    column_names <- read.table(paste(dir, "/features.txt", sep=""))[,2]
    train <- loadAndMergeXAndY(dir, column_names, paste(dir, "/train/X_train.txt", sep=""), paste(dir, "/train/y_train.txt", sep=""))
    test <- loadAndMergeXAndY(dir, column_names, paste(dir, "/test/X_test.txt", sep=""), paste(dir, "/test/y_test.txt", sep=""))
    
    # 1. Merges the training and the test sets to create one data set.
    rbind(train, test)
}


loadAndMergeXAndY <- function(dir, columnNames, XPath, yPath) {
    X <- read.table(XPath, col.names = columnNames)
    y <- read.table(yPath, header=FALSE)
    X$activity <- activityToName(dir, y)
    X
}

activityToName <- function(dir, y) {
    # 3. Uses descriptive activity names to name the activities in the data set
    activityLabels <- read.table(paste(dir, "/activity_labels.txt", sep=""))
    yNames <- left_join(y, activityLabels, by=("V1"="V1"))[,2]
}

extractMeanStdColumns <- function(data) {
    # 2. Extracts only the measurements on the mean and standard deviation for each measurement.
    meanAndStdColumns <- grep("mean|std", names(data))
    activityColumnNumber <- which("activity" == names(data))
    columnsToKeep <- c(meanAndStdColumns, activityColumnNumber)
    data[, columnsToKeep]
}

prettifyVariableNames <- function(columnNames) {
    # 4. Appropriately labels the data set with descriptive variable names.
    gsub("mean", "Mean", columnNames) %>%
    gsub("std", "Std", .) %>%
    gsub("\\.", "", .)
}

createAvgOfEachVariableAndActivity <- function(data) {
    # 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    avgOfEachVariableAndActivity <- data %>% group_by(activity) %>% summarise_all(funs(mean))
    names(avgOfEachVariableAndActivity) <- paste("Avg", names(avgOfEachVariableAndActivity), sep="")
    avgOfEachVariableAndActivity
}


main <- function() {
    url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    dir <- "./UCI HAR Dataset"
    zipFileName <- "UCIdata.zip"
    
    fetchData(url, dir, zipFileName)
    allData <- loadAndMergeData(dir) # This fixes task 1 and 3.
    meanStdData <- extractMeanStdColumns(allData) # Fixes task 2.
    names(meanStdData) <- prettifyVariableNames(names(meanStdData)) # Fixes task 4.
    
    tidyData <- createAvgOfEachVariableAndActivity(meanStdData) # Fixes task 5.
    write.table(tidyData, file="./tidy_data.txt", row.name=FALSE)
}

main()
