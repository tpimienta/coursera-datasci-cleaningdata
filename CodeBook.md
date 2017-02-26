# CodeBook

This project creates a tidy data set from [ Human Activity Recognition Using Smartphones Data Set ](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The overall approach was to create tidy data sets for both the training and test data, combine them into a single data frame, then calculate the mean for each variable grouped by activity and subject.

## The data

The [raw data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) when extracted from the zip archive is spread out in many files.

In side the archive are:

- activity\_labels.txt  : Maps numeric value for activity to name of activity
- features.txt          : Variable names for the observations in the test and training data
- features\_info.txt    : Original project's code book describing variables in their data set.

The test and training data are contained in folders "test" and "train", respectively.

To illustrate using the "test" data:
- test/X\_test.txt      : Contains the measured variables for each observation.
- test/y\_test.txt      : Contains numeric value for activity that generated data for each observation.
- test/subject\_test.txt: Contains numeric identifier for the subject that performed the activity for each observation.

The "training" data is similarly respresented but the file names contain "train" instead of "test".

## The variables

See original project's features\_info.txt for explanation of variables measured.

## Transformations performed

The function manipulate\_raw\_data() encapsulates the processing for the test and training data since the steps are the same.

1. Variables other that those representing a mean or standard deviation were dropped.
2. Numeric values for activities were added to the data frame and the numeric values where changed to their names.
3. Subject identifier was added to the data frame.
4. The names of the columns where changed to drop parenthesis when they appeared together (eg: "tBodyAcc-mean()-X" became "tBodyAcc-mean-X").
5. The test and training data frames were combined into the variable "combined" representing a tidy data set.

## Summaries

The tidy data generated was summarized by taking the mean for each measurement.  Column names were prepended with the text "mean-" to indicate the variables were now means of the original variables.  The summarized data frame is called "final".
