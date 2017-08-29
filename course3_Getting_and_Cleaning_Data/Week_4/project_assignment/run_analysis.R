## Clear environment to begin transformations
vars <- ls()
funcs <- grep("^analysis\\.",vars)
rm(list = vars[-funcs])
suppressWarnings(rm(list = c("vars","funcs")))

## Remove current dataset output file
suppressWarnings(file.remove("./data/dataset.csv"))

## load required libraries
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(stringr))

## load Train data ##
#####################
analysis.load.data <- function(type, variablenames = c(), activitynames = c()) {
    
    ## read data from raw file and set default names
    rawdata <- fread(paste("./data/ucihardataset/",type,"/X_",type,".txt",sep = ""),header = FALSE,col.names = variablenames)
    
    ## read subjects and training label of raw file and bind to raw data
    subjects <- fread(paste("./data/ucihardataset/",type,"/subject_",type,".txt",sep = ""), header = FALSE)[,V1]
    activities <- fread(paste("./data/ucihardataset/",type,"/y_",type,".txt",sep = ""),header = FALSE)[,V1]
    
    ## enrich traindata with subjects and training labels
    rawdata <- cbind(subject.of.activity = subjects,activity.name = activities,rawdata)
    
    ## make activity variable as factor of activity names
    rawdata$activity.name = factor(rawdata$activity.name,labels = activitynames)
    
    return(rawdata)
}

## Transform variable names in something readable with "." (dot) as spaces
analysis.prepare.variable.names <- function(variablenames) {
    ## Work with BodyAcc 
    index <- grep("^[t|f]BodyAcc",variablenames)
    features <- variablenames[index]
    ## break feature name into domain, name, extra name, function, dimensions
    brokenFeatureNames <- str_match(features,"^(t|f)(BodyAcc)(.*)-(.*)\\(\\)(-[X|Y|Z])?(,[X|Y|Z|0-9]?)?([0-9])?")
    ## format variable names
    rows <- apply(brokenFeatureNames,1,analysis.format.normal.feature,"body.accelerometer")
    variablenames[index] <- rows
    
    ## Work with GravityAcc
    index <- grep("^[t|f]GravityAcc",variablenames)
    features <- variablenames[index]
    ## break feature name into domain, name, extra name, function, dimensions
    brokenFeatureNames <- str_match(features,"^(t|f)(GravityAcc)(.*)-(.*)\\(\\)(-[X|Y|Z])?(,[X|Y|Z|0-9]?)?([0-9])?")
    ## format variable names
    rows <- apply(brokenFeatureNames,1,analysis.format.normal.feature,"gravity.accelerometer")
    variablenames[index] <- rows
    
    ## Work with BodyGyro
    index <- grep("^[t|f]BodyGyro",variablenames)
    features <- variablenames[index]
    ## break feature name into domain, name, extra name, function, dimensions
    brokenFeatureNames <- str_match(features,"^(t|f)(BodyGyro)(.*)-(.*)\\(\\)(-[X|Y|Z])?(,[X|Y|Z|0-9]?)?([0-9])?")
    ## format variable names
    rows <- apply(brokenFeatureNames,1,analysis.format.normal.feature,"body.gyroscope")
    variablenames[index] <- rows
    
    ## Work with BodyBodyAcc
    index <- grep("^[t|f]BodyBodyAcc",variablenames)
    features <- variablenames[index]
    ## break feature name into domain, name, extra name, function, dimensions
    brokenFeatureNames <- str_match(features,"^(t|f)(BodyBodyAcc)(.*)-(.*)\\(\\)(-[X|Y|Z])?(,[X|Y|Z|0-9]?)?([0-9])?")
    ## format variable names
    rows <- apply(brokenFeatureNames,1,analysis.format.normal.feature,"body.body.accelerometer")
    variablenames[index] <- rows
    
    ## Work with BodyBodyGyro
    index <- grep("^[t|f]BodyBodyGyro",variablenames)
    features <- variablenames[index]
    ## break feature name into domain, name, extra name, function, dimensions
    brokenFeatureNames <- str_match(features,"^(t|f)(BodyBodyGyro)(.*)-(.*)\\(\\)(-[X|Y|Z])?(,[X|Y|Z|0-9]?)?([0-9])?")
    ## format variable names
    rows <- apply(brokenFeatureNames,1,analysis.format.normal.feature,"body.body.gyroscope")
    variablenames[index] <- rows
    
    ## Work with Angle features and gravity
    index <- grep("^angle\\(",variablenames)
    features <- variablenames[index]
    ## break feature name into known peaces
    brokenFeatureNames <- str_match(features,"^angle\\((X|Y|Z)?(t|f)?(Body)?(Acc|Gyro)?(Jerk)?(Mean)?\\)?,(gravity)(Mean)?\\)")
    colnames(brokenFeatureNames) <- c("fullname", "dimension", "domain", "feature",
                                      "meter", "featuretype", "measure", "secdim",
                                      "secdimmeasure")
    ## format variable names
    rows <- apply(brokenFeatureNames,1,analysis.format.angle.feature)
    variablenames[index] <- rows
    
    return(variablenames)
}

## get broken common feature name and format in readable name
analysis.format.angle.feature <- function(x) {
    ## ajust common names
    if (!is.na(x["feature"])) x["feature"] <- tolower(x["feature"])
    if (!is.na(x["meter"])) x["meter"] <- ifelse(x["meter"] == "Acc","accelerometer", "gyroscope")
    if (!is.na(x["featuretype"])) x["featuretype"] <- tolower(x["featuretype"])
    if (!is.na(x["measure"])) x["measure"] <- tolower(x["measure"])
    if (!is.na(x["secdimmeasure"])) x["secdimmeasure"] <- tolower(x["secdimmeasure"])
    
    name <- paste("angle","between",sep = ".")
    
    if (!is.na(x["dimension"])) { # single dimension name, like X, Y or Z
        name <- paste(name,x["dimension"],sep = ".")
    }
    else { # have a feature name as first angle parameter
        ## ajust domain name t = time, f = frequency
        domain <- ifelse(x["domain"] == "t","activity.time","activity.frequency")
        
        ## prepare feature name with domain + feature + meter + feature type + measure
        featurename <- paste(domain,x["feature"],x["meter"],sep = ".")
        if (!is.na(x["featuretype"]) && nchar(x["featuretype"]) > 0) featurename <- paste(featurename,x["featuretype"], sep = ".")
        featurename <- paste(featurename,x["measure"], sep = ".")
        
        name <- paste(name,featurename,sep = ".")
    }
    
    ## set second dimension of angle
    name <- paste(name,"and",x["secdim"],sep = ".")
    if (!is.na(x["secdimmeasure"])) name <- paste(name,x["secdimmeasure"],sep = ".")
    
    ## remove dupplicated seps
    name <- gsub("\\.+","\\.",name)
    ## return formated name
    return(name)
}

## get broken common feature name and format in readable name
analysis.format.normal.feature <- function(x,featureName) {
    ## ajust domain name t = time, f = frequency
    domain <- ifelse(x[2] == "t","activity.time","activity.frequency")
    
    ## ajust extra name
    if(x[4] == "Mag") x[4] <- "magnitude"
    if(x[4] == "Jerk") x[4] <- "jerk"
    if(x[4] == "JerkMag") x[4] <- "jerk.magnitude"
    
    ## ajust measure names
    if (x[5] == "std") x[5] <- "standard.deviation"
    if (x[5] == "meanFreq") x[5] <- "mean.frequency"
    
    ## ajust dimension names
    x[6] <- sub("-","",x[6])
    x[7] <- sub(",","",x[7])
    
    ## concat domain and feature name
    name <- paste(domain,featureName,sep = ".")
    
    ## concat extra feature name
    if (nchar(x[4]) > 0) name <- paste(name,x[4],sep = ".")
    
    ## concat measure name
    name <- paste(name,x[5],sep = ".")
    
    ## if dimensions are set, concat them
    dimensions <- ""
    if (!is.na(x[6])) dimensions <- paste(dimensions,x[6],sep = ".")
    if (!is.na(x[7])) dimensions <- paste(dimensions,x[7],sep = ".")
    if (!is.na(x[8])) dimensions <- paste(dimensions,x[8],sep = ".")
    if (nchar(dimensions) > 0) {
        dimensions <- tolower(dimensions)
        name <- paste(name,"of",dimensions,sep = ".")
    }
    
    ## remove dupplicated seps
    name <- gsub("\\.+","\\.",name)
    ## return formated name
    return(name)
}

analysis.get.dataset <- function() {
    ## check for data folder
    if (!file.exists("./data")) dir.create("./data")
    
    ## download zip dataset and extract it to data folder
    if (!file.exists("./data/ucihardataset")) {
        data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(data_url,"./data/Dataset.zip")
        setwd("./data")
        unzip("./Dataset.zip") 
        file.rename("./UCI HAR Dataset","ucihardataset")
        setwd("../") 
    }
    
    ## first load variable names from features.txt 
    variablenames <- fread("./data/ucihardataset/features.txt")[[2]] ## get second position
    variablenames <- make.unique(variablenames,sep = "_") # handle variable names dupplications
    
    ## load activity names from activity_labels.txt
    activitynames <- fread("./data/ucihardataset/activity_labels.txt")[[2]] ## get second position
    activitynames <- tolower(activitynames)
    activitynames <- gsub("_"," ",activitynames)
    
    ## data sources from train and test
    sources <- c("train","test")
    
    ## read data from train and test files and merge it all
    data <- do.call(rbind,lapply(sources,analysis.load.data,variablenames = variablenames, activitynames = activitynames))
    
    ## get all variables with mean or standard deviation
    variables <- grep(".*([Mm]ean)|([Ss]td)|(subject)|(activity).*",names(data))
    data <- data[,variables,with = FALSE]
    
    ## set human readable names for data
    names <- analysis.prepare.variable.names(names(data))
    colnames(data) <- names
    
    ## Group data by acitivity and subject
    groupeddata <- aggregate(. ~ activity.name + subject.of.activity,data[-2],mean)
    
    ## Ajust new dataset column names
    names <- colnames(groupeddata)[-c(1,2)]
    names <- sapply(names,function(n){paste("mean.of",n,sep = ".")})
    colnames(groupeddata)[-c(1,2)] <- names
    return(groupeddata)
}

dataset <- analysis.get.dataset()
write.table(dataset,"./data/dataset.csv",row.names = FALSE)
print(dataset)