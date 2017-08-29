## corr function finds correlations of measures of completely cases measured 
##      by monitors
## 'directory' is a char vector with relative folder name where lives CSV files
## 'threshold' is a int value to select completely cases greater then threshold
## Return the correlations of selected measures
corr <- function(directory, threshold = 0) {
    # get completed cases files IDs with completes greater then threshold
    files <- complete(directory)
    ids <- files[which(files$nobs > threshold),"id"]
    if (length(ids) == 0) {
        return(ids)
    } else {
        # Read all data from selected IDs and concatenate into a single data.frame
        colclasses <- c("Date","numeric","numeric","integer")
        measureNames <- c("sulfate","nitrate")
        dataFiles <- readfiles(directory,ids)
        
        # Calculating correlations
        correlations <- do.call(rbind,lapply(dataFiles,doCor,cols=measureNames))
        correlations[,1]
    }
    
}

## readfiles function read data from requested files into a list of data.frames
## 'directory' is a char vector with relative folder name where lives CSV files
## 'id' is a int vector with selected monitors
## Return a list of data.frame with files data
readfiles <- function(directory, id = 1:332) {
    # format ids to XXX format
    library(stringr)
    normIds <- str_pad(id,3,pad = "0")
    
    # Prepare vector of files relative to Working Dir
    files <- paste(directory,"/",normIds,".csv",sep="")
    
    # Read all data from selected IDs and concatenate into a single data.frame
    colclasses <- c("Date","numeric","numeric","integer")
    lapply(files,read.csv,colClasses = colclasses)
}

doCor <- function(data,cols) {
    d <- data[complete.cases(data),cols]
    cor(d[[1]],d[[2]])
}