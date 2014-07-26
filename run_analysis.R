run <- function() {
  library(plyr)
  
  if(!file.exists("./data")) {
    dir.create("./data")
    fileUrl1 = "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
    download.file(fileUrl1,destfile="./data/getdata-projectfiles-UCI HAR Dataset.zip")
  }
  
  zipName <- "./data/getdata-projectfiles-UCI HAR Dataset.zip"
  X_test <<- read.table(unz(zipName, "UCI HAR Dataset/test/X_test.txt"))
  X_train <<- read.table(unz(zipName, "UCI HAR Dataset/train/X_train.txt"))
  
  # Appropriately labels the data set with descriptive variable names. 
  all_features <- read.table(unz(zipName, "UCI HAR Dataset/features.txt"))$V2
  mean_sd_indexes <- grep('mean|std', all_features)
  names(X_train) <- all_features
  names(X_test) <- all_features
  
  y_test = read.table(unz(zipName, "UCI HAR Dataset/test/y_test.txt"))
  y_train = read.table(unz(zipName, "UCI HAR Dataset/train/y_train.txt"))
  names(y_train) <- "y"
  names(y_test) <- "y"
  
  # Merges the training and the test sets to create one data set.
  # Extracts only the measurements on the mean and standard deviation for each measurement. 
  X <- rbind(X_train[, mean_sd_indexes], X_test[,mean_sd_indexes])
  X <- cbind(X, rbind(y_train, y_test))
  
  # Uses descriptive activity names to name the activities in the data set
  activity_names <- read.table(unz(zipName, "UCI HAR Dataset/activity_labels.txt"))
  names(activity_names) <- c('y', 'activity_name')
  X <<- join(activity_names, X, by='y')
  
  # Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  write.csv(X, "./data/clean.csv")
}