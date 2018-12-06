data <- function(path) {
  column_names <- read.table(paste(path, "/features.txt", sep=""))[,2]
  #activity_labels <- read.table(paste(path, "/activity_labels.txt", sep=""))[,2]
  
  train <- read.table(paste(path, "/train/X_train.txt", sep=""), col.names = column_names)
  y_train <- read.csv(paste(path, "/train/y_train.txt", sep=""))
  train$activity <- activity_to_name(y_train)
  
  test <- read.csv(paste(path, "/test/X_test.txt", sep=""), col.names = column_names)
  y_test <- read.csv(paste(path, "/test/y_test.txt", sep=""))
  test$activity <- activity_to_name(y_test)
  
  # X_data <- merge(X_train, X_test)
  # print(head(X_data))
}


activity_to_name <- function(y) {
  new_y <- sapply(y[,1], function(x) switch(x, "LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS"))
}


path <- "./UCI HAR Dataset"
