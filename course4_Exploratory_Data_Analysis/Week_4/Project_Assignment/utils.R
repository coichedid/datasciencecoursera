## Some utilities functions that may be duplicated on scripts

## Read data files and return a list with those 2 data frames
read.files <- function() {
    NEI <- readRDS("./data/summarySCC_PM25.rds")
    SCC <- readRDS("./data/Source_Classification_Code.rds")
    data <- list(NEI = NEI,SCC = SCC)
    return(data)
}

run.analysis <- function(scriptname) {
    print("Sourcing and running...")
    source(paste(".",scriptname,sep = "/"))
    if (!exists("only.source") | only.source) do.analysis(dataframes$NEI,dataframes$SCC)
}