# Code Book

## main()
The script will begin with running the main function. Here, other functions will be called 
to performed the different tasks in the project, se the descriptions below. In the end, the tidy dataset is 
written to the tidy_data.txt file.

### installAndLoadLibraries()
This function will install (if not already installed) and load the packages passed into this function.

### fetchData()
This function will download the data zip file as well as extract the zip file if either of or both of 
these tasks haven't already been performed.

### loadAndMergeData()
This function fixes task 1 and 3. It first calls the function loadAndMergeXAndY() to load the 
X_train, subject_train and the y_train data. Then the function activityToName() is used to replace the integers in y_train 
with the correct word defined in activity_labels.txt which it also loads. Then the subject_train and the new y_train is added to X_train.

The same process is done for the test data. After that, this function will merge the train and test data to one dataset.

### extractMeanStdColumns()
This function fixes task 2. The functions start off with finding the column names of the combined dataset that has mean
or std in its name. After that the function finds what column number the activity and the subject has. Then the dataset is filtered to keep the mean, std, subject and activity columns.
 
### prettifyVariableNames()
This function fixes task 4. It replaces mean with Mean, std with Std and removes all of the unnecessary dots in
the datasets column names.

### createAvgOfEachVariableAndActivity()
This function fixes task 5. First, the data is grouped by subject and activity, then it calculates the average of each 
variable for each activity and each subject.
