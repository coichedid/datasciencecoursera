## Simple script to run all analysis
## Prepare environment
##  - Create data folder
##  - Create plots folder
##  - Download and unzip data file if not exists
## Source scripts files
## Run each analysis
source("./utils.R")
only.source <<- TRUE ## run scripts to screen
data.exists <- TRUE ## reload data

if (!file.exists("./data")) dir.create("./data") ## Prepare data folder
if (!file.exists("./plots")) dir.create("./plots") ## Prepare plots folder

if(!file.exists("./data/extdata_data_NEI_data.zip")) {
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    if (download.file(url,"./data/extdata_data_NEI_data.zip") == 0) {
        unzip("./data/extdata_data_NEI_data.zip",exdir = "./data/")
        data.exists <- TRUE
    }
} else data.exists <- TRUE

if (data.exists) {
    if(!exists("dataframes")) {
        dataframes <<- read.files()
    }
    if (!exists("only_script") ) scripts <- dir(pattern = "^plot[0-9]\\.R")
    else scripts <- c(only_script)
    sapply(scripts,run.analysis)
    print("All analysis are done!")
} else {
    cat("No data found")
}