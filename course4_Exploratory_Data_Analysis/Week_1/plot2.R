## Function to load data from web repository
## This function also filter data file getting header and lines of required dates
## Then it merges Date and Time variables to get DateTime variable of type POSIXlt
load.data <- function(url, filename, from, to) {
    filepath <- paste("./data",filename,sep = "/") # set file path to ./data folder
    if(!file.exists("./data")) dir.create("./data") # create ./data if need
    download.file(url,filepath) # download file
    unzip(filepath,exdir = "./data") # unzip file
    
    unzippedfilename <- dir("./data",pattern = "*.txt")[1] # get unzipped file
    unzippedfilepath <- paste("./data",unzippedfilename,sep = "/")
    
    ## This file is so big, so read only necessary data
    awkcmd <- paste("awk 'BEGIN {FS=\";\"} {if (($1 == \"Date\") || ($1 == \"",
                    from,
                    "\") || ($1 == \"",
                    to,
                    "\")) print $0}' ",
                    unzippedfilepath,
                    sep = "")
    d <- read.csv(pipe(awkcmd),header = TRUE,sep = ";", stringsAsFactors = FALSE,
                  na.strings = "?")
    d$DateTime <- strptime(paste(d$Date,d$Time),format = "%d/%m/%Y %H:%M:%S")
    return(d)
} 

## Function to plot line chart
## It receives data, x and y variable names, x and y labels
## It can save to PNG file with dimensions of 480x480 if savetofile is true
plot.study <- function(data, xvar, yvar ,xlab = "", ylab = "", savetofile) {
    if (!missing(savetofile) && savetofile) {
        png(filename = "./plot2.png")
    }
    with(data,{
        plot(eval(as.symbol(xvar)),eval(as.symbol(yvar)),type = "n", xlab = xlab, ylab = ylab)
        lines(eval(as.symbol(xvar)), y = eval(as.symbol(yvar)))
    })
    if (!missing(savetofile) && savetofile) {
        dev.off()
    }
}

url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data <- load.data(url,"household_power_consumption.zip","1/2/2007","2/2/2007") ## Load data

## Plot line chart of Global Active Power by DateTime
plot.study(data,xvar = "DateTime", yvar = "Global_active_power",
           ylab = "Global Active Power (kilowatts)",
           savetofile = TRUE)