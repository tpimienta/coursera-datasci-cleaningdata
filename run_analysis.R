library(plyr)
library(dplyr)

# information that is common to processing both training and test data sets

# the  variables represented in each column of the data frames
features <- read.table('uci/features.txt', comment.char='', stringsAsFactors=F)

# only want variables that are mean and standard deviation
idx_of_mean_and_std <- grep("mean|std", features$V2, ignore.case=T)

# a logical vector is required to filter the features to only the mean and std dev
logical_idx_of_mean_and_std<-grepl("mean|std", features$V2, ignore.case=T)

# labels for the activities
act_label<-read.table('uci/activity_labels.txt')

# The processing for both test and train data will be the same so
# compose a function to do those tasks.  Function will make use of the
# global variables initialized above.

manipulate_raw_data <-function(data, activity_data, subject_data) {
    # Processes the data to:
    # - extracts only mean and std variables from the data
    # - add activity variable to each observation
    # - add subject to each observation
    # 
    # @param data.frame data 
    #   the original raw data
    # @param data.frame activity_data
    #   the activity data
    # @param data.frame subject_data
    #   the subject data
    #
    # @return data.frame
    data<-select(data, idx_of_mean_and_std)
    # match activity label to observation index
    labels<-join(activity_data, act_label)

    # add activity variable to data frame
    with_activity<-cbind(labels$V2, data)

    data_final<-cbind(subject_data, with_activity)

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

# subject variable for each observation
subjects<-read.table('uci/test/subject_test.txt')

# raw training data frame
train<-read.table('uci/train/X_train.txt', comment.char='')

# each row in training data frame is for these activities
train_act<-read.table('uci/train/y_train.txt')

# subject variable 
train_subjects<-read.table('uci/train/subject_train.txt')

test_final<-manipulate_raw_data(test, test_act, subjects)
train_final<-manipulate_raw_data(train, train_act, train_subjects)

# combine training and test into single data frame
out<-rbind(train_final, test_final)
