


get_and_merge_data <- function(data_folder) {
    column_names <- read.table(paste(data_folder, "/features.txt", sep=""))[,2]
    
    train <- get_and_merge_X_and_y(column_names, paste(data_folder, "/train/X_train.txt", sep=""), paste(data_folder, "/train/y_train.txt", sep=""))
    test <- get_and_merge_X_and_y(column_names, paste(data_folder, "/test/X_test.txt", sep=""), paste(data_folder, "/test/y_test.txt", sep=""))
    
    rbind(train, test)
}

get_and_merge_X_and_y <- function(column_names, X_path, y_path) {
    X <- read.table(X_path, col.names = column_names)
    y <- read.csv(y_path, header=FALSE)
    X$activity <- activity_to_name(y)
    X
}

activity_to_name <- function(y) {
    new_y <- sapply(y[,1], function(x) switch(x, "LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS"))
}

extract_mean_std_columns <- function(data) {
    mean_columns <- grep("mean", names(data))
    std_columns <- grep("std", names(data))
    activity_column <- which("activity" == n)
    columns_to_keep <- c(mean_columns, std_columns, activity_column)
    data[, columns_to_keep]
}

prettify_variable_names <- function(column_names) {
    gsub("\\.", "", tolower(column_names))
}

main() {
    data_folder <- "./UCI HAR Dataset"
    all_data <- get_and_merge_data(data_folder)
    mean_std_data <- extract_mean_std_columns(all_data)
    names(mean_std_data) <- prettify_variable_names(names(mean_std_data))
    
    average_of_data <- mean_std_data %>% group_by(activity) %>% summarise_all(funs(mean))
    names(average_of_data) <- paste("avg", names(average_of_data), sep="")
}

main()