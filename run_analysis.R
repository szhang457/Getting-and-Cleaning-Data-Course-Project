library(reshape2)

#Merges the training and the test sets to create one data set.
train_allfeature<-read.table("UCI HAR Dataset/train/X_train.txt")
train_label<-read.table("UCI HAR Dataset/train/Y_train.txt")
train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt")
train<-cbind(train_allfeature,train_label,train_subject)

test_allfeature<-read.table("UCI HAR Dataset/test/X_test.txt")
test_label<-read.table("UCI HAR Dataset/test/Y_test.txt")
test_subject<-read.table("UCI HAR Dataset/test/subject_test.txt")
test<-cbind(test_allfeature,test_label,test_subject)

alldata<-rbind(test,train)

#Extracts only the mean and standard deviation for each measurement.
features<-read.table("UCI HAR Dataset/features.txt")
features[,2]<-as.character(features[,2])
need<-grep(".*mean.*|.*std.*", features[,2])

train_need<-read.table("UCI HAR Dataset/train/X_train.txt")[need]
test_need<-read.table("UCI HAR Dataset/test/X_test.txt")[need]

train_modified<-cbind(train_need,train_label,train_subject)
test_modified<-cbind(test_need,test_label,test_subject)

data<-rbind(test_modified,train_modified)

#Appropriately labels the data set with descriptive variable names.
features_need<-features[need,2]
colnames(data)<-c(features_need,"activity","subject")

#Uses descriptive activity names to name the activities in the data set
activity<-read.table("UCI HAR Dataset/activity_labels.txt")
activity[,2]<-as.character(activity[,2])

data$activity<-factor(data$activity,levels=activity[,1],labels=activity[,2])
data$subject<-as.factor(data$subject)

#creates a tidy data set with the average of each variable 
#for each activity and each subject.
data1<-melt(data,id=c("subject", "activity"))
result<-dcast(data1,subject+activity~variable,mean)
write.table(result,"tidy.txt",row.names=FALSE,quote=FALSE)
