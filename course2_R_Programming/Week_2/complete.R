## complete function counts the number of completely observed cases for the 
##          required monitors
## 'directory' is a char vector with relative folder name where lives CSV files
## 'id' is a int vector with selected monitors
## Return a data.frame with monitor ID and number of completely cases
complete <- function(directory, id = 1:332) {
    # format ids to XXX format
    library(stringr)
    normIds <- str_pad(id,3,pad = "0")
    
    # Prepare vector of files relative to Working Dir
    files <- paste(directory,"/",normIds,".csv",sep="")
    # Read all data from selected IDs and concatenate into a single data.frame
    colclasses <- c("Date","numeric","numeric","integer")
    data <- do.call(rbind,lapply(files,read.csv,colClasses = colclasses))
    
    # filter incomplete measures of read data
    goodData <- data[complete.cases(data),]
    
    # return aggregated data by ID
    cols <- c("unique.values","ID")
    newColNames <- c("id","nobs")
    counts <- aggregate(x = goodData,by = list(unique.values = goodData$ID), FUN=NROW)[cols]
    colnames(counts) <- newColNames
    counts[match(id,counts$id),]
}