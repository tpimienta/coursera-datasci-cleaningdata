library(plyr)
library(dplyr)

# process train, process test, combine using rbind()

# common
# the  variables represented in each column of the data frames
features <- read.table('uci/features.txt', comment.char='', stringsAsFactors=F)

# only want variables that are mean and standard deviation
idx_of_mean_and_std <- grep("mean|std", features$V2, ignore.case=T)

# a logical vector is required to filter the features to only the mean and std dev
logical_idx_of_mean_and_std<-grepl("mean|std", features$V2, ignore.case=T)

# labels for the activities
act_label<-read.table('uci/activity_labels.txt')


# processing
# files: the data, the activities for the data, the subjects



manipulate_raw_data <-function(data, test_act, subjects) {
    data<-select(data, idx_of_mean_and_std)
    # match activity label to observation index
    test_labels<-join(test_act, act_label)

    # add activity variable to data frame
    test_with_activity<-cbind(test_labels$V2, data)

    data_final<-cbind(subjects, test_with_activity)

    # fix names on the data frame 
    # here using logical vector gives desired result
    feature_names<-filter(features, grepl("mean|std", features$V2, ignore.case=T))
    # @TODO do some processing on the feature names to change
    # tBodyAcc-mean()-X to 'Mean Body Accel (x)' for example
    colnames(data_final)<-c("subject", "activity", feature_names$V2, recursive=T)

    data_final
}

# raw test data frame
test<-read.table('uci/test/X_test.txt', comment.char='')

# each row in test data frame is for these activities
test_act<-read.table('uci/test/y_test.txt')

# subject variable 
subjects<-read.table('uci/test/subject_test.txt')

# raw test data frame
train<-read.table('uci/train/X_train.txt', comment.char='')

# each row in test data frame is for these activities
train_act<-read.table('uci/train/y_train.txt')

# subject variable 
train_subjects<-read.table('uci/train/subject_train.txt')

test_final<-manipulate_raw_data(test, test_act, subjects)
train_final<-manipulate_raw_data(train, train_act, train_subjects)
out<-rbind(train_final, test_final)
