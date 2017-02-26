# Cleaning Data Week 4 Peer Reviewed Assignment

library(plyr)
library(dplyr)

# information that is common to processing both training and test data sets

# the  variables represented in each column of the data frames
features <- read.table('uci/features.txt', stringsAsFactors=F)

# only want variables that are mean and standard deviation
idx_of_mean_and_std <- grep("mean|std", features$V2, ignore.case=T)

# a logical vector is required to filter the features to only the mean and std dev
logical_idx_of_mean_and_std<-grepl("mean|std", features$V2, ignore.case=T)

# fix names on the data frame 
# here using logical vector gives desired result
feature_names<-filter(features, logical_idx_of_mean_and_std)

# labels for the activities, we want factors, not character vectors!
act_label<-read.table('uci/activity_labels.txt', stringsAsFactors=T)

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

    # strip out parens right next to each other (eg: mean() -> mean)
    out_features<-sapply(feature_names$V2, gsub, pattern="\\(\\)", replacement="")
    colnames(data_final)<-c("subject", "activity", out_features, recursive=T)

    data_final
}

# raw test data frame
test<-read.table('uci/test/X_test.txt')

# each row in test data frame is for these activities
test_act<-read.table('uci/test/y_test.txt')

# subject variable for each observation
subjects<-read.table('uci/test/subject_test.txt')

# raw training data frame
train<-read.table('uci/train/X_train.txt')

# each row in training data frame is for these activities
train_act<-read.table('uci/train/y_train.txt')

# subject variable 
train_subjects<-read.table('uci/train/subject_train.txt')

test_final<-manipulate_raw_data(test, test_act, subjects)
train_final<-manipulate_raw_data(train, train_act, train_subjects)

# combine training and test into single data frame
combined<-rbind(train_final, test_final)

# Final data frame will have one observation for each combination of 
# unique subject identifier and activity.  Looks like 180 rows (30 x 6).

# Tried several other approaches that all _failed_ and are noted here to I 
# will in the future figure out why.

# This one will apply mean to activity and subject columns as well...
# z<-ddply(combined, .(activity, subject), summarize_all, mean)

# Here try to use is.numeric test before calc mean for column but, it
# throws an error b/c of "bad" characters in the col name (eg: , or ())
# z<-ddply(combined, .(activity, subject), summarize_if, is.numeric, mean)

# Also throws error for same reason as above:
# z<-ddply(combined, .(activity, subject), summarize_at, 3:88, mean)

# numcolwise will only apply to numeric columns and _doesn't_ choke
# like my attempts to use summarize_if or summarize_at
final<-ddply(combined, .(activity, subject), numcolwise(mean))


# Alter names of columns b/c they are now "mean of" whatever it was
# called before.
# set asside col names we don't want to alter
unaltered_column_names<-names(final)[1:2]
mean_prepend_column_names<-paste0("mean-", names(final)[3:88])
colnames(final)<-c(unaltered_column_names, mean_prepend_column_names, recursive=T)

# write tidy data to text file
write.table(final, 'tidy-data.txt', row.names=F)
