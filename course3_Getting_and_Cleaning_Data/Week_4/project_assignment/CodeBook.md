<a name="top"></a>
# Getting and Cleaning Data Course
## Assignment Project Code Book

## Table of Contents
1. [Original Raw Data](#rawdata)  
2. [Raw data transformations and subsetting](#transformations)  
3. [Dataset structure](#structure)

<a name="rawdata"></a>  
### Original Raw Data  
This project has the goal to transform and get a tidy dataset from raw data of Human Activity Recognition Using Smartphones Dataset experiments performed by Smartlab - Non Linear Complex Systems Laboratory - DITEN - Universit? degli Studi di Genova.

Original data comes from experiments that have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ  
tGravityAcc-XYZ  
tBodyAccJerk-XYZ  
tBodyGyro-XYZ  
tBodyGyroJerk-XYZ  
tBodyAccMag  
tGravityAccMag  
tBodyAccJerkMag  
tBodyGyroMag  
tBodyGyroJerkMag  
fBodyAcc-XYZ  
fBodyAccJerk-XYZ  
fBodyGyro-XYZ  
fBodyAccMag  
fBodyAccJerkMag  
fBodyGyroMag  
fBodyGyroJerkMag  

The set of variables that were estimated from these signals are: 

mean(): Mean value  
std(): Standard deviation  
mad(): Median absolute deviation   
max(): Largest value in array  
min(): Smallest value in array  
sma(): Signal magnitude area  
energy(): Energy measure. Sum of the squares divided by the number of values.   
iqr(): Interquartile range   
entropy(): Signal entropy   
arCoeff(): Autorregresion coefficients with Burg order equal to 4  
correlation(): correlation coefficient between two signals  
maxInds(): index of the frequency component with largest magnitude  
meanFreq(): Weighted average of the frequency components to obtain a mean frequency  
skewness(): skewness of the frequency domain signal   
kurtosis(): kurtosis of the frequency domain signal   
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.  
angle(): Angle between to vectors.  

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean  
tBodyAccMean  
tBodyAccJerkMean  
tBodyGyroMean  
tBodyGyroJerkMean  
[Top](#top)

<a name="transformations"></a>
### Raw data transformations and subsetting
Raw data was separated into 2 sets: 70% train data and 30% test data. For this project, data was read from original data files and merged. After that, only "mean" and "std" variables was selected.

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

On this new dataset, all variables was rename to more human readable strings. 
For this transformation, variable names was format with 2 patterns. Thos following patterns was transformed by its peaces as describes:

1. General Variables
`<domain:[t,f]><feature:BodyAcc,GravityAcc,BodyGyro,BodyBodyAcc,BodyBodyGyro><ExtraName:Jerk,Mag,JerkMag><Measure><Dimensions:[X|Y|Z],[X|Y|Z|1|2][1|2]>`  

    * domain values
        * t => acitivity.time
        * f => activity.frequency
    * feature names
        * BodyAcc => body.accelerometer
        * GravityAcc => gravity.accelerometer
        * BodyGyro => body.gyroscope
        * BodyBodyAcc => body.body.accelerometer
        * BodyBodyGyro => body.body.gyroscope
    * extra names
        * Jerk => jerk
        * Mag => magnitude
        * JerkMag => jerk.magnitude
    * measures
        * mean() => mean
        * std() => standard.deviation
        * meanFreq() => mean.frequency
2. Angle Variables: those variables starts with "angle(" expression  
`angle(<1st dimension:[X|Y|Z] or feature name like earlier pattern>,<2nd dimension: gravity followed or not by mean>)`

For second pattern, if 1st dimension was the feature name, it was transformed as described on 1st pattern.

After renamed all selected variables, dataset was aggregated by subject of activity and activity properly. At this time, the average was calculated for each measure variable.  
[Top](#top)  

<a name="structure"></a>
### Dataset structure  
Dataset is composed by 88 variables, 1st and 2nd variables ar subject and activity name. All others are averages of corresponding variable of original raw data grouped by subject and activity.

The descriptions of each variable is followed.

* activity.name   
    The six possible activities performed by subjects:
    
        * walking
        * walking upstairs
        * walking downstairs
        * sitting
        * standing
        * laying
        
* subject.of.activity   
    Group of 30 volunteers who performed those activities  
    
        * sequency of 1 to 30
        
* mean.of.activity.time.body.accelerometer.mean.of.x  
`mean of specific activity mean duration performed by one subject read on body accelerometer on X axis`   

* mean.of.activity.time.body.accelerometer.mean.of.y  
`mean of specific activity mean duration performed by one subject read on body accelerometer on Y axis`   

* mean.of.activity.time.body.accelerometer.mean.of.z  
`mean of specific activity mean duration performed by one subject read on body accelerometer on Z axis`   

* mean.of.activity.time.body.accelerometer.standard.deviation.of.x  
`mean of specific activity standard deviation performed by one subject read on body accelerometer on X axis`   

* mean.of.activity.time.body.accelerometer.standard.deviation.of.y  
`mean of specific activity standard deviation performed by one subject read on body accelerometer on Y axis`   

* mean.of.activity.time.body.accelerometer.standard.deviation.of.z  
`mean of specific activity standard deviation performed by one subject read on body accelerometer on Z axis`   

* mean.of.activity.time.gravity.accelerometer.mean.of.x  
`mean of specific activity mean duration performed by one subject read on gravity accelerometer on X axis`   

* mean.of.activity.time.gravity.accelerometer.mean.of.y  
`mean of specific activity mean duration performed by one subject read on gravity accelerometer on Y axis`   

* mean.of.activity.time.gravity.accelerometer.mean.of.z  
`mean of specific activity mean duration performed by one subject read on gravity accelerometer on Z axis`   

* mean.of.activity.time.gravity.accelerometer.standard.deviation.of.x  
`mean of specific activity standard deviation performed by one subject read on gravity accelerometer on X axis`   

* mean.of.activity.time.gravity.accelerometer.standard.deviation.of.y  
`mean of specific activity standard deviation performed by one subject read on gravity accelerometer on Y axis`   

* mean.of.activity.time.gravity.accelerometer.standard.deviation.of.z  
`mean of specific activity standard deviation performed by one subject read on gravity accelerometer on Z axis`   

* mean.of.activity.time.body.accelerometer.jerk.mean.of.x  
`mean of specific activity Jerk signal mean performed by one subject read on body accelerometer on X axis`   

* mean.of.activity.time.body.accelerometer.jerk.mean.of.y  
`mean of specific activity Jerk signal mean performed by one subject read on body accelerometer on Y axis`   

* mean.of.activity.time.body.accelerometer.jerk.mean.of.z  
`mean of specific activity Jerk signal mean performed by one subject read on body accelerometer on Z axis`   

* mean.of.activity.time.body.accelerometer.jerk.standard.deviation.of.x  
`mean of specific activity Jerk signal standard deviation performed by one subject read on body accelerometer on X axis`   

* mean.of.activity.time.body.accelerometer.jerk.standard.deviation.of.y  
`mean of specific activity Jerk signal standard deviation performed by one subject read on body accelerometer on Y axis`   

* mean.of.activity.time.body.accelerometer.jerk.standard.deviation.of.z  
`mean of specific activity Jerk signal standard deviation performed by one subject read on body accelerometer on Z axis`   

* mean.of.activity.time.body.gyroscope.mean.of.x  
`mean of specific activity mean duration performed by one subject read on body gyroscope on X axis`   

* mean.of.activity.time.body.gyroscope.mean.of.y  
`mean of specific activity mean duration performed by one subject read on body gyroscope on Y axis`   

* mean.of.activity.time.body.gyroscope.mean.of.z  
`mean of specific activity mean duration performed by one subject read on body gyroscope on Z axis`   

* mean.of.activity.time.body.gyroscope.standard.deviation.of.x  
`mean of specific activity standard deviation performed by one subject read on body gyroscope on X axis`   

* mean.of.activity.time.body.gyroscope.standard.deviation.of.y  
`mean of specific activity standard deviation performed by one subject read on body gyroscope on Y axis`   

* mean.of.activity.time.body.gyroscope.standard.deviation.of.z  
`mean of specific activity standard deviation performed by one subject read on body gyroscope on Z axis`   

* mean.of.activity.time.body.gyroscope.jerk.mean.of.x  
`mean of specific activity Jerk signal mean performed by one subject read on body gyroscope on X axis`   

* mean.of.activity.time.body.gyroscope.jerk.mean.of.y  
`mean of specific activity Jerk signal mean performed by one subject read on body gyroscope on Y axis`   

* mean.of.activity.time.body.gyroscope.jerk.mean.of.z  
`mean of specific activity Jerk signal mean performed by one subject read on body gyroscope on Z axis`   

* mean.of.activity.time.body.gyroscope.jerk.standard.deviation.of.x  
`mean of specific activity Jerk signal standard deviation performed by one subject read on body gyroscope on X axis`   

* mean.of.activity.time.body.gyroscope.jerk.standard.deviation.of.y  
`mean of specific activity Jerk signal standard deviation performed by one subject read on body gyroscope on Y axis`   

* mean.of.activity.time.body.gyroscope.jerk.standard.deviation.of.z  
`mean of specific activity Jerk signal standard deviation performed by one subject read on body gyroscope on Y axis`   

* mean.of.activity.time.body.accelerometer.magnitude.mean  
`mean of specific activity magnitude of three-dimensional signal mean performed by one subject read on body accelerometer`   

* mean.of.activity.time.body.accelerometer.magnitude.standard.deviation  
`mean of specific activity magnitude of three-dimensional signal standard deviation performed by one subject read on body accelerometer`   

* mean.of.activity.time.gravity.accelerometer.magnitude.mean  
`mean of specific activity magnitude of three-dimensional signal mean performed by one subject read on gravity accelerometer`   

* mean.of.activity.time.gravity.accelerometer.magnitude.standard.deviation  
`mean of specific activity magnitude of three-dimensional signal standard deviation performed by one subject read on gravity accelerometer`   

* mean.of.activity.time.body.accelerometer.jerk.magnitude.mean  
`mean of specific activity magnitude of Jerk signal mean performed by one subject read on body accelerometer`   

* mean.of.activity.time.body.accelerometer.jerk.magnitude.standard.deviation  
`mean of specific activity magnitude of Jerk signal standard deviation performed by one subject read on body accelerometer`   

* mean.of.activity.time.body.gyroscope.magnitude.mean  
`mean of specific activity magnitude of three-dimensional signal mean performed by one subject read on body gyroscope`   

* mean.of.activity.time.body.gyroscope.magnitude.standard.deviation  
`mean of specific activity magnitude of three-dimensional signal standard deviation performed by one subject read on body gyroscope`   

* mean.of.activity.time.body.gyroscope.jerk.magnitude.mean  
`mean of specific activity magnitude of Jerk signal mean performed by one subject read on body gyroscope`   

* mean.of.activity.time.body.gyroscope.jerk.magnitude.standard.deviation  
`mean of specific activity magnitude of Jerk signal standard deviation performed by one subject read on body gyroscope`   

* mean.of.activity.frequency.body.accelerometer.mean.of.x  
`mean of specific activity mean frequency performed by one subject read on body accelerometer on X axis`   

* mean.of.activity.frequency.body.accelerometer.mean.of.y  
`mean of specific activity mean frequency performed by one subject read on body accelerometer on Y axis`   

* mean.of.activity.frequency.body.accelerometer.mean.of.z  
`mean of specific activity mean frequency performed by one subject read on body accelerometer on Z axis`   

* mean.of.activity.frequency.body.accelerometer.standard.deviation.of.x  
`mean of specific activity frequency standard deviation performed by one subject read on body accelerometer on X axis`   

* mean.of.activity.frequency.body.accelerometer.standard.deviation.of.y  
`mean of specific activity frequency standard deviation performed by one subject read on body accelerometer on Y axis`   

* mean.of.activity.frequency.body.accelerometer.standard.deviation.of.z  
`mean of specific activity frequency standard deviation performed by one subject read on body accelerometer on Z axis`   

* mean.of.activity.frequency.body.accelerometer.mean.frequency.of.x  
`mean of specific activity frequency of mean frequency performed by one subject read on body accelerometer on X axis`   

* mean.of.activity.frequency.body.accelerometer.mean.frequency.of.y  
`mean of specific activity frequency of mean frequency performed by one subject read on body accelerometer on Y axis`   

* mean.of.activity.frequency.body.accelerometer.mean.frequency.of.z  
`mean of specific activity frequency of mean frequency performed by one subject read on body accelerometer on Z axis`   

* mean.of.activity.frequency.body.accelerometer.jerk.mean.of.x  
`mean of specific activity frequency of Jeark signal mean performed by one subject read on body accelerometer on X axis`   

* mean.of.activity.frequency.body.accelerometer.jerk.mean.of.y  
`mean of specific activity frequency of Jeark signal mean performed by one subject read on body accelerometer on Y axis`   

* mean.of.activity.frequency.body.accelerometer.jerk.mean.of.z  
`mean of specific activity frequency of Jeark signal mean performed by one subject read on body accelerometer on Z axis`   

* mean.of.activity.frequency.body.accelerometer.jerk.standard.deviation.of.x  
`mean of specific activity frequency of Jeark signal standard deviation performed by one subject read on body accelerometer on X axis`   

* mean.of.activity.frequency.body.accelerometer.jerk.standard.deviation.of.y  
`mean of specific activity frequency of Jeark signal standard deviation performed by one subject read on body accelerometer on Y axis`   

* mean.of.activity.frequency.body.accelerometer.jerk.standard.deviation.of.z  
`mean of specific activity frequency of Jeark signal standard deviation performed by one subject read on body accelerometer on Z axis`   

* mean.of.activity.frequency.body.accelerometer.jerk.mean.frequency.of.x  
`mean of specific activity frequency of Jerk signal mean frequency performed by one subject read on body accelerometer on X axis`   

* mean.of.activity.frequency.body.accelerometer.jerk.mean.frequency.of.y  
`mean of specific activity frequency of Jerk signal mean frequency performed by one subject read on body accelerometer on Y axis`   

* mean.of.activity.frequency.body.accelerometer.jerk.mean.frequency.of.z  
`mean of specific activity frequency of Jerk signal mean frequency performed by one subject read on body accelerometer on Z axis`   

* mean.of.activity.frequency.body.gyroscope.mean.of.x  
`mean of specific activity mean frequency performed by one subject read on body gyroscope on X axis`   

* mean.of.activity.frequency.body.gyroscope.mean.of.y  
`mean of specific activity mean frequency performed by one subject read on body gyroscope on Y axis`   

* mean.of.activity.frequency.body.gyroscope.mean.of.z  
`mean of specific activity mean frequency performed by one subject read on body gyroscope on Z axis`   

* mean.of.activity.frequency.body.gyroscope.standard.deviation.of.x  
`mean of specific activity frequency standard deviation performed by one subject read on body gyroscope on X axis`   

* mean.of.activity.frequency.body.gyroscope.standard.deviation.of.y  
`mean of specific activity frequency standard deviation performed by one subject read on body gyroscope on Y axis`   

* mean.of.activity.frequency.body.gyroscope.standard.deviation.of.z  
`mean of specific activity frequency standard deviation performed by one subject read on body gyroscope on Z axis`   

* mean.of.activity.frequency.body.gyroscope.mean.frequency.of.x  
`mean of specific activity frequency of mean frequency  performed by one subject read on body gyroscope on X axis`   

* mean.of.activity.frequency.body.gyroscope.mean.frequency.of.y  
`mean of specific activity frequency of mean frequency performed by one subject read on body gyroscope on Y axis`   

* mean.of.activity.frequency.body.gyroscope.mean.frequency.of.z  
`mean of specific activity frequency of mean frequency performed by one subject read on body gyroscope on Z axis`   

* mean.of.activity.frequency.body.accelerometer.magnitude.mean  
`mean of specific activity magnitude of three-dimensional signal mean frequency performed by one subject read on body accelerometer`   

* mean.of.activity.frequency.body.accelerometer.magnitude.standard.deviation  
`mean of specific activity magnitude of three-dimensional signal frequency standard deviation performed by one subject read on body accelerometer`   

* mean.of.activity.frequency.body.accelerometer.magnitude.mean.frequency  
`mean of specific activity magnitude of three-dimensional signal frequency mean frequency performed by one subject read on body accelerometer`   

* mean.of.activity.frequency.body.body.accelerometer.jerk.magnitude.mean  
`mean of specific activity Jerk magnitude signal mean frequency performed by one subject read on body accelerometer`   

* mean.of.activity.frequency.body.body.accelerometer.jerk.magnitude.standard.deviation  
`mean of specific activity Jerk magnitude signal frequency standard deviation performed by one subject read on body accelerometer`   

* mean.of.activity.frequency.body.body.accelerometer.jerk.magnitude.mean.frequency  
`mean of specific activity Jerk magnitude signal frequency mean frequency performed by one subject read on body accelerometer`   

* mean.of.activity.frequency.body.body.gyroscope.magnitude.mean  
`mean of specific activity magnitude of three-dimensional signal mean frequency performed by one subject read on body gyroscope`   

* mean.of.activity.frequency.body.body.gyroscope.magnitude.standard.deviation  
`mean of specific activity magnitude of three-dimensional signal frequency standard deviation performed by one subject read on body gyroscope`   

* mean.of.activity.frequency.body.body.gyroscope.magnitude.mean.frequency  
`mean of specific activity magnitude of three-dimensional signal frequency mean frequency performed by one subject read on body gyroscope`   

* mean.of.activity.frequency.body.body.gyroscope.jerk.magnitude.mean  
`mean of specific activity Jerk magnitude signal mean frequency performed by one subject read on body gyroscope`   

* mean.of.activity.frequency.body.body.gyroscope.jerk.magnitude.standard.deviation  
`mean of specific activity Jerk magnitude signal frequency standard deviation performed by one subject read on body gyroscope`   

* mean.of.activity.frequency.body.body.gyroscope.jerk.magnitude.mean.frequency  
`mean of specific activity Jerk magnitude signal frequency mean frequency performed by one subject read on body gyroscope`   

* mean.of.angle.between.activity.time.body.accelerometer.mean.and.gravity  
`mean of vector angle between specific activity mean duration performed by one subject read on body accelerometer and gravity vector `   

* mean.of.angle.between.activity.time.body.accelerometer.jerk.mean.and.gravity.mean  
`mean of vector angle between specific activity mean duration performed by one subject read on body accelerometer and mean gravity vector`   

* mean.of.angle.between.activity.time.body.gyroscope.mean.and.gravity.mean  
`mean of vector angle between specific activity mean duration performed by one subject read on body gyroscope and gravity vector`   

* mean.of.angle.between.activity.time.body.gyroscope.jerk.mean.and.gravity.mean  
`mean of vector angle between specific activity mean duration performed by one subject read on body gyroscope and mean gravity vector`   

* mean.of.angle.between.X.and.gravity.mean  
`mean of vector angle between specific activity mean duration performed by one subject read on body accelerometer on X axis and mean gravity vector`   

* mean.of.angle.between.Y.and.gravity.mean  
`mean of vector angle between specific activity mean duration performed by one subject read on body accelerometer on Y axis and mean gravity vector`   

* mean.of.angle.between.Z.and.gravity.mean  
`mean of vector angle between specific activity mean duration performed by one subject read on body accelerometer on Z axis and mean gravity vector`   

[Top](#top)
