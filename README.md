# coursera-datasci-cleaningdata
Code for Cleaning Data course in Data Science specialty at Cousera

## Useage
Download the data, extract and create simlink as run_analysis.R expects data
to be in a particular directory.

1. wget https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip -O data.zip
2. unzip data.zip
3. ln -s UCI\ HAR\ Dataset uci

Start interactive R session then source("run_analysis.R").

The tidy data is called "combined".
The summarized data frame is called "final".
