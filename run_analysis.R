library(data.table)
###################################################
# Load   Activity labels &  Features
Activity_labels<-fread("UCI HAR Dataset/activity_labels.txt", col.names = c("Class_labels", "Activity_names"))

Features<-fread("UCI HAR Dataset/features.txt", col.names=c("Indexes", "Feature_names"))
###################################################
# Extracts only the measurements on the mean and standard deviation for each measurement.
Selected_features<-grep("(mean|std)\\(\\)", Features[ , Feature_names])

Measurements<-Features[Selected_features, Feature_names]
Measurements<-gsub('[()]', '', Measurements)

###################################################
# Loead train datasets
Train<-fread("UCI HAR Dataset/train/X_train.txt")
Train<-Train[ , Selected_features, with=FALSE]
setnames(Train, colnames(Train), Measurements)

Train_activities<- fread("UCI HAR Dataset/train/Y_train.txt", col.names = c("Activity"))
Train_subjects<-fread("UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject_num"))

Train<-cbind(Train_subjects,Train_activities, Train)

# Load test datasets
Test<-fread("UCI HAR Dataset/test/X_test.txt")
Test<-Test[ , Selected_features, with=FALSE]
setnames(Test, colnames(Test), Measurements)

Test_activities<- fread("UCI HAR Dataset/test/Y_test.txt", col.names = c("Activity"))
Test_subjects<-fread("UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject_num"))

Test<-cbind(Test_subjects,Test_activities, Test)

# Merge train and test data sets
Merged_data<-rbind(Train,Test)

###################################################

# Appropriately labels the data set with descriptive variable names.
Merged_data[["Activity"]]<- factor(Merged_data[, Activity],
                                 levels = Activity_labels[["Class_labels"]],
                                 labels = Activity_labels[["Activity_names"]] 
                                  )

Merged_data[["Subject_num"]]<- as.factor(Merged_data[,Subject_num])
Merged_data<-melt(data = Merged_data, id= c("Subject_num", "Activity"))
Merged_data<-dcast(data = Merged_data, Subject_num+ Activity ~ variable , fun.aggregate = mean)

###################################################
# From the data set in step 4, creates a second, independent tidy data set
Tiday_data<-Merged_data
write.table(Tiday_data,file = "Tiday_data.txt",row.name=FALSE)

###################################################                                


