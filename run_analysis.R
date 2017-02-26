library(plyr)
library(dplyr)

# raw test data frame
test <- read.table('uci/test/X_test.txt', comment.char='')
#train <- read.table('uci/train/X_train.txt', comment.char='')
#o<-rbind(test, train)

# the  variables represented in each column of the data frames
features <- read.table('uci/features.txt', comment.char='', stringsAsFactors=F)
# only want variables that are mean and standard deviation
idx_of_mean_and_std <- grep("mean|std", features$V2, ignore.case=T)

# each row in test data frame is for these activities
test_act<-read.table('uci/test/y_test.txt')

# only select the variables we are interested in
test <- select(test, idx_of_mean_and_std)

# labels for the activities
act_label<-read.table('uci/activity_labels.txt')
# match activity label to observation index
test_labels<-join(test_act, act_label)

# add activity variable to data frame
names(test_labels)<-c("ignored", "activity")
test_with_activity<-cbind(test_labels$activity, test)

# add the subject variable to data frame
subjects<-read.table('uci/test/subject_test.txt')
names(subjects)<-c("subjects")
test_final<-cbind(subjects, test_with_activity)

# fix names on the data frame 
g<-grepl("mean|std", features$V2, ignore.case=T)
feature_names<-filter(features, g)
# @TODO do some processing on the feature names to change
# tBodyAcc-mean()-X to 'Mean Body Accel (x)' for example
colnames(test_final)<-c("subject", "activity", feature_names$V2, recursive=T)
