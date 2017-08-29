## Clear environment to begin transformations
vars <- ls()
funcs <- grep("^analysis\\.",vars)
rm(list = vars[-funcs])

## load required libraries
if ("package:dplyr" %in% search()) {
    detach("package:dplyr",unload = TRUE)
}
library(utils)
library(data.table)
library(plyr)
suppressPackageStartupMessages(library(dplyr))

initMeasureNum <<- 0
allFeatures <<- c()
fileFormat <<- data.frame()
generalFeaturesTotal <<- 0
angleFeaturesTotal <<- 0
generalNAs <<- 0
angleNAs <<- 0

## Filter dataset based on feature name prefix and includes subject, train, measurenum columns
analysis.get.data.features <- function(featureName,dataset) {
    features <- grep(featureName,names(dataset))
    varNames <- grep(featureName,names(dataset),value = T)
    allFeatures <<- c(allFeatures,varNames) ## concat feature names to validation
    features <- c(features,(ncol(dataset) - 2), (ncol(dataset) - 1), ncol(dataset))
    dataset[,..features] 
}

## Angle data Transformation 
## Take diferent Variables that represents measures and also observations
## Create specific observations for those variables and uniform Variables as measurements like mean, max and so on
analysis.transform.angle.features <- function(featureName, dataset = data.frame()) {
    cat(paste("Feature name",featureName," "))
    featuresdata <- analysis.get.data.features(featureName,dataset)
    featuresdata <- featuresdata %>%
        ## Transform columns to key-value pair        
        gather(key,value,1:(ncol(featuresdata)-3)) 
    
    ## sum total features (Lines * variables selected) and NAs to validation
    angleFeaturesTotal <<- angleFeaturesTotal + length(featuresdata$key)
    angleNAs <<- angleNAs + sum(is.na(featuresdata$value))
    
        ## split feature
    featuresdata <- featuresdata %>% extract(key,c("variable","feature"),"(angle)\\((.*)\\)$") %>%
        ## create dimension and domain Variables with values NA and "angle"
        mutate(dimension = NA,domain = "angle") %>%
        ## remove ) from feature
        mutate(feature = gsub("\\)","",feature)) %>% 
        ## set dimension and domain as factors
        mutate(dimension = as.factor(dimension), domain = as.factor(domain)) 
    
    # take number of measurements
    featuresdataMeasures <- nrow(featuresdata)
    cat(paste(featuresdataMeasures,"measures"))
    
    ## transform "variable" column into measurement variables 
    featuresdata <- featuresdata %>% spread(variable,value) 
    
    ## Validating transformations
    validData <- !is.na(featuresdata[,7])
    featuresdataValidMeasures <- sum(validData)
    #names <- paste(names(featuresdata))
    msg <- paste("\nWith",featureName,"name were processed",featuresdataMeasures,
                 "variables with",featuresdataValidMeasures,"valid data\nTransformation is",
                 ifelse(featuresdataMeasures == featuresdataValidMeasures,"valid","invalid"),"\n")
    cat(msg)
    #cat("Column names\n")
    #cat(names)
    
    # done with this transformations
    return(featuresdata)
}

## Transformation for most of Variables of dataset. 
## Angle Variables has special treatement
## Take diferent Variables that represents measures and also observations
## Create specific observations for those variables and uniform Variables as measurements like mean, max and so on
analysis.transform.data.features <- function(featureName, dataset = data.frame()) {
    cat(paste("Feature name",featureName," "))
    featuresdata <- analysis.get.data.features(featureName,dataset)
    featuresdata <- featuresdata %>%
        ## Transform columns to key-value pair        
        gather(key,value,1:(ncol(featuresdata)-3))
    
    ## sum total features (Lines * variables selected) and NAs to validation
    generalFeaturesTotal <<- generalFeaturesTotal + length(featuresdata$key)
    generalNAs <<- generalNAs + sum(is.na(featuresdata$value))
    
        ## split feature
    featuresdata <- featuresdata %>% separate(key,c("feature","variable","dimension"),sep = "-", fill = "right") %>% 
        ## handle dupplication variables as versions
        separate(dimension,c("dimension","version"),sep = "_", fill = "right") %>% 
        ## set unique variables to version 1
        mutate(version = as.numeric(version), version = ifelse(is.na(version),0,version), version = version + 1) %>% 
        ## remove () from variable
        mutate(variable = gsub("\\(\\)","",variable)) %>% 
        ## split domain from feature
        mutate(domain = substring(feature,1,1), feature = substring(feature,2)) %>% 
        ## define factors
        mutate(domain = gsub("t","time",domain), domain = gsub("f","frequency",domain)) %>% 
        ## set dimension and domain as factors
        mutate(dimension = as.factor(dimension), domain = as.factor(domain)) 
    
    # take number of measurements
    featuresdataMeasures <- nrow(featuresdata)
    cat(paste(featuresdataMeasures,"measures"))
    
    ## transform "variable" column into measurement variables 
    featuresdata <- featuresdata %>% spread(variable,value) 
    
    ## Validating transformations
    validData <- colSums(sapply(featuresdata[,8:ncol(featuresdata)],function(x) !is.na(x)))
    featuresdataValidMeasures <- sum(validData)
    #names <- paste(names(featuresdata))
    msg <- paste("\nWith",featureName,"name were processed",featuresdataMeasures,
                 "variables with",featuresdataValidMeasures,"valid data\nTransformation is",
                 ifelse(featuresdataMeasures == featuresdataValidMeasures,"valid","invalid"),"\n")
    cat(msg)
    #cat("Column names\n")
    #cat(names)
    
    # done with this transformations
    return(featuresdata)
}

## load Train data ##
#####################
analysis.load.data <- function(type, featureNames, angleFeatureNames, variablenames) {
    ## Reset validation data
    allFeatures <<- c()
    fileFormat <<- data.frame()
    generalFeaturesTotal <<- 0
    angleFeaturesTotal <<- 0
    generalNAs <<- 0
    angleNAs <<- 0
    
    ## read data from raw file and set default names
    rawdata <- fread(paste("./data/ucihardataset/",type,"/X_",type,".txt",sep = ""),header = FALSE,col.names = variablenames)
    
    ## read subjects and training label of raw file and bind to raw data
    subjects <- fread(paste("./data/ucihardataset/",type,"/subject_",type,".txt",sep = ""), header = FALSE)[,V1]
    rowLabels <- fread(paste("./data/ucihardataset/",type,"/y_",type,".txt",sep = ""),header = FALSE)[,V1]
    
    ## enrich traindata with subjects and training labels
    rawdata <- cbind(rawdata,subject = subjects,train = rowLabels,measurenum = c(1:nrow(rawdata)))
    rawdata$measurenum <- rawdata$measurenum + initMeasureNum
    initMeasureNum <<- initMeasureNum + nrow(rawdata)
    
    ## compute processed data
    dataGeneral <- data.frame(dataType = type, type = "general", lines = nrow(rawdata), 
                               totalCols = ncol(rawdata),
                               cols = (length(variablenames) - length(angleFeatureNames)), 
                               totalData = nrow(rawdata) * (length(variablenames) - length(angleFeatureNames)))
    dataAngle <- data.frame(dataType = type, type = "angle", lines = nrow(rawdata), 
                               totalCols = ncol(rawdata),
                               cols = length(angleFeatureNames), totalData = nrow(rawdata) * length(angleFeatureNames))
    fileFormat <<- rbind(dataGeneral,dataAngle)
    
    ## Transform general variables
    ## For memory limitations, treat each feature at time
    cat("#### Preparing general variables ####\n")
    generalFeaturesData <- do.call(rbind.fill,lapply(featureNames,analysis.transform.data.features,dataset = rawdata))
    
    ## Transform angle variables
    ## For memory limitations, treat each feature at time
    cat("#### Preparing angle variables ####\n")
    angleFeaturesData <- do.call(rbind.fill,lapply(angleFeatureNames,analysis.transform.angle.features,dataset = rawdata))
    
    ## Validating general features transformations
    cat("#### Validating transformations ####\n")
    validData <- colSums(sapply(generalFeaturesData[,8:ncol(generalFeaturesData)],function(x) !is.na(x)))
    totalValidMeasures <- sum(validData)
    
    ## Consider original dataset
    dataVariableNames <- names(rawdata[,-c("subject","train","measurenum")])
    ## Exclude angle variables 
    angleVariables <- grep("angle",dataVariableNames)
    ## Count number of variables after exclusions
    numVariables <- length(dataVariableNames[-angleVariables])
    dataDataMeasures <- numVariables * nrow(rawdata)
    
    msg <- paste("\nGeneral Variables data has",dataDataMeasures,"observations. Transformed data has",
                 totalValidMeasures,"\nTransformation is",
                 ifelse(totalValidMeasures == dataDataMeasures,"valid","invalid"),
                 "\n\n")
    cat(msg)
    
    ## Validating angle features transformations
    validData <- !is.na(angleFeaturesData[,7])
    totalValidMeasures <- sum(validData)
    
    ## Count number of angle variables
    numVariables <- length(angleFeatureNames)
    dataDataMeasures <- numVariables * nrow(rawdata)
    
    msg <- paste("\nAngle Variables data has",dataDataMeasures,"observations. Transformed data has",
                 totalValidMeasures,"\nTransformation is",
                 ifelse(totalValidMeasures == dataDataMeasures,"valid","invalid"),
                 "\n\n")
    cat(msg)
    
    data <- rbind.fill(generalFeaturesData,angleFeaturesData)
    
    ## Validating transformations
    validData <- colSums(sapply(data[,8:ncol(data)],function(x) !is.na(x)))
    totalValidMeasures <- sum(validData)
    
    dataDataMeasures <- (ncol(rawdata) - 3) * nrow(rawdata)
    
    msg <- paste("\nTrain data has",dataDataMeasures,"observations. Transformed data has",
                 totalValidMeasures,"\nTransformation is",
                 ifelse(totalValidMeasures == dataDataMeasures,"valid","invalid"),
                 "\n\n")
    cat(msg)
    return(data)
}

## download zip dataset and extract it to data folder
if (!file.exists("./data/ucihardataset")) {
    data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(data_url,"./data/Dataset.zip")
    setwd("./data")
    unzip("./Dataset.zip") 
    file.rename("./UCI HAR Dataset","ucihardataset")
    setwd("../") 
}

## Set features names
featureNames <- c("tBodyAcc-","tGravityAcc-","tBodyAccJerk-","tBodyGyro-",
                  "tBodyGyroJerk-","tBodyAccMag-","tGravityAccMag-","tBodyAccJerkMag-",
                  "tBodyGyroMag-","tBodyGyroJerkMag-","fBodyAcc-","fBodyAccJerk-","fBodyGyro-",
                  "fBodyAccMag-","fBodyBodyAccJerkMag-","fBodyBodyGyroMag-",
                  "fBodyBodyGyroJerkMag-")

## Set angle features names
angleFeatureNames <- c("angle\\(tBodyAccMean,gravity\\)","angle\\(tBodyAccJerkMean\\),gravityMean\\)",
                       "angle\\(tBodyGyroMean,gravityMean\\)","angle\\(tBodyGyroJerkMean,gravityMean\\)",
                       "angle\\(X,gravityMean\\)","angle\\(Y,gravityMean\\)","angle\\(Z,gravityMean\\)")

## first load variable names from features.txt 
variablenames <- fread("./data/ucihardataset/features.txt")[[2]] ## get second position
variablenames <- make.unique(variablenames,sep = "_") # handle variable names dupplications

## Load Train data
trainData <- analysis.load.data("train",featureNames, angleFeatureNames, variablenames)

## Final validations
allColumns <- 561 == sum(fileFormat$cols)
allReadFeatures <- 561 == length(allFeatures)
totalReadFeatures <- length(allFeatures)
allComputedColumns <- sum(fileFormat$cols)
totalColumns <- fileFormat$totalCols[1]
allLines <- 7352 == fileFormat$lines[1]
allComputedLines <- fileFormat$lines[1]
allComputedData <- fileFormat[1,c("lines")] * sum(fileFormat$cols) == sum(fileFormat$totalData)
totalData <- sum(fileFormat$totalData)
totalComputedData <- fileFormat[1,c("lines")] * sum(fileFormat$cols)
allData <- totalData == (7352 * 561)
allAngleData <- angleFeaturesTotal == fileFormat$totalData[2]
angleComputedData <- fileFormat$totalData[2]
allGeneralData <- generalFeaturesTotal == fileFormat$totalData[1]
generalComputedData <- fileFormat$totalData[1]
noAngleNAs <- angleNAs == 0
noGeneralNAs <- generalNAs == 0
minMeasureNum <- 1 == min(trainData$measurenum)
maxMeasureNum <- 7352 == max(trainData$measurenum)

summarisedValidations <- data.table(
    allColumns = allColumns,
    allReadFeatures = allReadFeatures,
    totalReadFeatures = totalReadFeatures,
    totalColumns = totalColumns,
    allComputedColumns = allComputedColumns,
    allLines = allLines,
    allComputedLines = allComputedLines,
    allComputedData = allComputedData,
    totalData = totalData,
    totalComputedData = totalComputedData,
    allData = allData,
    allAngleData = allAngleData,
    angleComputedData = angleComputedData,
    allGeneralData = allGeneralData,
    generalComputedData = generalComputedData,
    noAngleNAs = noAngleNAs,
    noGeneralNAs = noGeneralNAs,
    minMeasureNum = minMeasureNum,
    maxMeasureNum = maxMeasureNum
)

## Load Train data
testData <- analysis.load.data("test",featureNames, angleFeatureNames, variablenames)

## Final validations
allColumns <- 561 == sum(fileFormat$cols)
allReadFeatures <- 561 == length(allFeatures)
totalReadFeatures <- length(allFeatures)
allComputedColumns <- sum(fileFormat$cols)
totalColumns <- fileFormat$totalCols[1]
allLines <- 2947 == fileFormat$lines[1]
allComputedLines <- fileFormat$lines[1]
allComputedData <- fileFormat[1,c("lines")] * sum(fileFormat$cols) == sum(fileFormat$totalData)
totalData <- sum(fileFormat$totalData)
totalComputedData <- fileFormat[1,c("lines")] * sum(fileFormat$cols)
allData <- totalData == (2947 * 561)
allAngleData <- angleFeaturesTotal == fileFormat$totalData[2]
angleComputedData <- fileFormat$totalData[2]
allGeneralData <- generalFeaturesTotal == fileFormat$totalData[1]
generalComputedData <- fileFormat$totalData[1]
noAngleNAs <- angleNAs == 0
noGeneralNAs <- generalNAs == 0
minMeasureNum <- (7352 + 1) == min(testData$measurenum)
maxMeasureNum <- (7352 + 2947) == max(testData$measurenum)

summarisedValidations2 <- data.table(
    allColumns = allColumns,
    allReadFeatures = allReadFeatures,
    totalReadFeatures = totalReadFeatures,
    totalColumns = totalColumns,
    allComputedColumns = allComputedColumns,
    allLines = allLines,
    allComputedLines = allComputedLines,
    allComputedData = allComputedData,
    totalData = totalData,
    totalComputedData = totalComputedData,
    allData = allData,
    allAngleData = allAngleData,
    angleComputedData = angleComputedData,
    allGeneralData = allGeneralData,
    generalComputedData = generalComputedData,
    noAngleNAs = noAngleNAs,
    noGeneralNAs = noGeneralNAs,
    minMeasureNum = minMeasureNum,
    maxMeasureNum = maxMeasureNum
)
cat("Train summary\n")
print(summarisedValidations)
cat("\n\nTest Summary\n")
print(summarisedValidations2)

namedVars <- c("funcs","vars","allFeatures","generalFeaturesTotal","angleFeaturesTotal", "generalNAs", "angleNAs",
               "featureNames", "angleFeatureNames", "variablenames", 
               names(summarisedValidations2), "namedVars")
suppressWarnings(rm(list = namedVars)) 