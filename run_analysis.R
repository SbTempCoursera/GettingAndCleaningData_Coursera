# run_analysis.R

# Read the data features and extract names and measurement labels
measurements <- read.table("./UCI HAR Dataset/features.txt") 
measurements <- measurements[c(grep('mean()', measurements$V2),grep('std()', measurements$V2)),]
mynames <- as.character(measurements_selected$V2)
measurements <- measurements$V1
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") 

# read data for test and train
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") 
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
X_test <- X_test[,measurements] 
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_data <- cbind(data_set="test", subject_test, y_test, X_test) 

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") 
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt") 
X_train <- X_train[,measurements] 
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") 
train_data <- cbind(data_set="train", subject_train, y_train, X_train) 

#merge and name the data
mydata <- rbind(test_data, train_data) 
names(mydata) <- c("Set", "Subject", "y", mynames) 
mydata$y <- as.character((factor(mydata$y, labels = activity_labels$V2))) 
write.table(mydata, "Cleaned_data.txt", row.names=FALSE) 

#extract means
mean_by_subj_act <- aggregate(mydata[,4:82], by=list(mydata$Subject, mydata$y),FUN=mean) 
names(mean_by_subj_act)[1:2] <- c("Subject", "y") 
write.table(mean_by_subj_act, "Cleaned_data_means.txt", row.names=FALSE) 
