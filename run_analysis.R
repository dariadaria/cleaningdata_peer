run <- function() {
  library(plyr)
  
  if(!file.exists("./data")){dir.create("./data")}
  
  fileUrl1 = "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
  #download.file(fileUrl1,destfile="./data/getdata-projectfiles-UCI HAR Dataset.zip")
  zipName <- "./data/getdata-projectfiles-UCI HAR Dataset.zip"
  X_test <<- read.table(unz(zipName, "UCI HAR Dataset/test/X_test.txt"))
  X_train <<- read.table(unz(zipName, "UCI HAR Dataset/train/X_train.txt"))
  
  features <<- read.table(unz(zipName, "UCI HAR Dataset/features.txt"))$V2
  names(X_train) <- features
  names(X_test) <- features
  
  y_test = read.table(unz(zipName, "UCI HAR Dataset/test/y_test.txt"))
  y_train = read.table(unz(zipName, "UCI HAR Dataset/train/y_train.txt"))
  names(y_train) <- "y"
  names(y_test) <- "y"
  
  X <<- rbind(X_train, X_test)
  X <<- cbind(X, rbind(y_train, y_test))
  X_test$y <<- unclass(y_test)
  #X_test <<- NULL
  #X_train <<- NULL
  
  library(reshape2)
  #XMelt <<- melt(X, id=c("y"), na.rm=TRUE)
  XMelt <<- melt(X, id=c("y"), measure.vars = features, na.rm=TRUE)
  Xdata <- cast(XMelt, y ~ variable, c(mean, sd))
  Xdata = cbind(activity_names$V2, Xdata)
  #tapply(X, X$y, c(mean, sd))
  #aggregated <<- aggregate(X, by=list(y),  
  #               FUN = function(x) 
  #                 c( mean(x, trim = 0, na.rm = T, weights=NULL), sd(x, na.rm=TRUE)))
  #t <- aggregate(X_test[, features], by=unclass(X_test$y),  FUN = 
  #                 +               function(x) c( mean(x, trim = 0, na.rm = T, weights=NULL), 
  #                                                +                              sd(x, na.rm=TRUE)))
  
  activity_names <<- read.table(unz(zipName, "UCI HAR Dataset/activity_labels.txt"))
}