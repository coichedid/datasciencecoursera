## poluttantmean function calculates mean of measured pollutant values of list
##                  of selected monitors
## 'directory' is a char vector with relative folder name where lives CSV files
## 'pollutant' is a char vector for which mean is calculated
## 'id' is a int vector with selected monitors
## Return the mean of pollutant across all monitors list
pollutantmean <- function(directory, pollutant, id = 1:332) {
    # format ids to XXX format
    library(stringr)
    normIds <- str_pad(id,3,pad = "0")
    
    # Prepare vector of files relative to Working Dir
    files <- paste(directory,"/",normIds,".csv",sep="")
    
    # Read all data from selected IDs and concatenate into a single data.frame
    colclasses <- c("Date","numeric","numeric","integer")
    data <- do.call(rbind,lapply(files,read.csv,colClasses = colclasses))
    
    # Select requested measure
    measure <- data[[pollutant]]
    
    # Identify missing data and filter only valid data
    badData <- is.na(measure)
    goodData <- measure[!badData]
    
    # return mean of requested measure of requested monitors
    mean(goodData)
}