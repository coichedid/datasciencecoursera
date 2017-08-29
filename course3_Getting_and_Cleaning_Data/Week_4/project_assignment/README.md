<a name="top"></a>
# Getting and Cleaning Data Course
## Assignment Project

## Table of Contents
1. [Repo contents](#repo)  
2. [Case study description](#casestudy) 
3. [Transformations on raw data](#transformations)
4. [run_analysis.R script](#run_analysis.R)
5. [Script dependencies](#deps)

<a name="repo"></a>  
### Repo contents 
* [README.md](https://github.com/coichedid/datasciencecoursera/blob/master/course3_Getting_and_Cleaning_Data/Week_4/project_assignment/README.md) -- this file, description of role study case
* [CodeBook.md](https://github.com/coichedid/datasciencecoursera/blob/master/course3_Getting_and_Cleaning_Data/Week_4/project_assignment/CodeBook.md) -- codebook with output dataset description
* [run_analysis.R](https://raw.githubusercontent.com/coichedid/datasciencecoursera/master/course3_Getting_and_Cleaning_Data/Week_4/project_assignment/run_analysis.R) -- R script to download raw data and get a tidy dataset with mean of each variable grouped by subject and activity  

[Top](#top)

<a name="casestudy"></a>  
### Case Study
This project has the goal to transform and get a tidy dataset from raw data of Human Activity Recognition Using Smartphones Dataset experiments performed by Smartlab - Non Linear Complex Systems Laboratory - DITEN - Universit? degli Studi di Genova.

Original data comes from experiments that have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.  
[Top](#top)

 <a name="transformations"></a>  
### Transformations on raw data
Raw data is composed by several rows of measures identified by one person (subject), one activity and a moment (not presented in raw data). It is also composed by 561 variables took from accelerometer and gyroscope meters or got from acceleration and angular velocity of those meters.

Final dataset is composed by 88 variables representing average of each mean or standard deviation variable of raw data, grouped by activity and subject.

To get this tidy dataset, the following steps was done:  
1. Read both train and test datasets (raw file was partitioned into 70% train data and 30% test data)  
2. Merge two datasets (first train and then test data)  
3. Enrich data with subject and activity names data from other 2 files  
4. Subset dataset with only variables containing "mean" or "std" strings in its name  
```
This said, features like:   
 tBodyAcc-mean()-Z  
 tBodyAcc-std()-X  
which has mean or std in its names,
and  
 tBodyAccMag-mean()  
 tBodyAccMag-std()  
that ends with mean or std,
and  
 fBodyAcc-meanFreq()-X  
 fBodyAcc-meanFreq()-Y  
that has mean inside its names are all included on final subset
```  
5. Transform variables names into a standard and meanful names  
6. Agregate data by subject and activity name and calculate mean of each value variable  
7. Rename variables to pattern mean.of.<old variable name>, like mean.of.angle.between.Z.and.gravity.mean  
8. Output new dataset  

[Top](#top)

 <a name="run_analysis.R"></a>  
### run_analysis.R script
run_analysis.R is the main script of this project. It declares some functions and outputs final dataset as dataset object and writes data to data/dataset.csv.  

Declared Functions:  

* analysis.format.angle.feature - format angle variable names to format "**angle.between.#first dimension#.and.#second dimension#**"  
* analysis.format.normal.feature - format general variable names to format "**activity.#domain: frequency or time#.#feature name: body accelerometer or body gyroscope#.#extra feature name: jerk or magnitude#.#measure: mean or standard deviation or mean frequency#**"  
* analysis.prepare.variable.names - decompose original variable name and call format functions  
* analysis.load.data - read data from raw files  
* analysis.get.dataset - main script function, call all others  

Base data directory is `getwd()/data`.  

**analysis.get.dataset** checks if data folder in working dir exists and if not creates a new one. Then it downloads raw data from `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip` into `getwd()/data` folder, unzip it into `getwd()/data/ucihardataset` folder.

With data into folder `getwd()/data/ucihardataset`, this function reads variable names file (features.txt) and activity names file (activity_labels.txt). Then it transforms activity names lowering cases and replacing "_" char by " " (space) char.

After getting variables and activities names, it calls, for train and test files, analysis.load.data, that load file contents into different objects and then it merges those 2 objects.

After subset data, getting only mean and standard deviation variables, it calls analysis.prepare.variable.names to rename each variable with human readable names, as described above.

Finally, this function aggregates dataset rows by its subject and activity, calculating mean of each measure variable and outputs tidyed dataset.  
[Top](#top)

 <a name="deps"></a>  
### Script dependencies

* data.table
* stringr  


All libraries are automatally loaded at beginning of script **run_analysis.R**  
[Top](#top)