library(dplyr)

#Downloading the file

url<-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

if(!file.exists("./data")){dir.create("./data")}
download.file(url,destfile="./data/smarthphones.zip")

unzip("./data/smarthphones.zip",list = TRUE)

#Reading training files

ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
xtrain <- read.table("UCI HAR Dataset/train/x_train.txt")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")


#Reading test files

ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
xtest <- read.table("UCI HAR Dataset/test/x_test.txt")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Reading other files

features <- read.table("UCI HAR Dataset/features.txt")
act <- read.table("UCI HAR Dataset/activity_labels.txt")

#Renaming (putting the names of the features into the data)

names(xtrain)<-features$V2
names(xtest)<-features$V2

#Renaming the columns before binding

names(ytrain)<-"activity"
names(ytest)<-"activity"

names(sub_train)<-"subject"
names(sub_test)<-"subject"

#Binding and ajusting the labels in the train data 

total_train <-cbind(sub_train,ytrain,xtrain)
total_train <- merge(act,total_train,by.y="activity",by.x="V1", all = TRUE)
total_train <- rename(total_train, "activity" = "V2")
total_train <- select(total_train, c(2:564))

#Binding and ajusting the labels in the test data 

total_test <-cbind(sub_test,ytest,xtest)
total_test <- merge(act,total_test,by.y="activity",by.x="V1", all = TRUE)
total_test <- rename(total_test, "activity" = "V2")
total_test <- select(total_test, c(2:564))

#Merging the training and testing data

total_base <-rbind(total_train,total_test)

#Extracting only the mesuraments on the mean and standard deviation for each measurement

mean_std_base <-total_base%>%select(matches('mean|std'))

#Summarizing the mean of each activity ans subject

tidy_data <- total_base%>%group_by(subject,activity)%>%summarise_all(mean)





