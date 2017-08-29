## Global plot file name
png.name <- "plot1.png"

## Read data files and return a list with those 2 data frames
read.files <- function() {
    NEI <- readRDS("./data/summarySCC_PM25.rds")
    SCC <- readRDS("./data/Source_Classification_Code.rds")
    data <- list(NEI = NEI,SCC = SCC)
    return(data)
}

## Basic function to do plotting to a file or console
plot.data <- function(data, plot.to.file = FALSE) {
    a <<- data
    if (plot.to.file) png(paste(".","plots",png.name,sep = "/"),width = 1024, height = 768) ## plot to png under plots folder
    else x11() ## open a new plotting window
    
    ## Plot a line chart by years
    with(data,plot(x=years,y=totals/10^6,type = "p",main = "Total PM2.5 emissions in United States",
                   xlab = "Year", ylab = "Total Emissions in Millions of tons"))
    #with(data,lines(years,totals/10^6,col = "blue"))
    
    ## Plot lm line
    totals <- data$totals/10^6
    years <- as.integer(data$years)
    abline(lm(totals~years),col = "red")
    
    if(plot.to.file) dev.off()
}

do.analysis <- function(NEI,SCC,plot.to.file = FALSE) {
    if (!missing(NEI)) { ## check if data is present
        summarised.by.year <- with(NEI,tapply(Emissions,year,sum,na.rm = T))
        df <- data.frame(years = names(summarised.by.year),totals = summarised.by.year, stringsAsFactors = FALSE)
        plot.data(df,plot.to.file)
    }
}

print("Running analysis Plot 1..")
if(!exists("dataframes")) {
    dataframes <<- read.files()
}

## Automatic run analysis as default
if(!exists("only.source") | !only.source) {
    NEI <- dataframes$NEI
    SCC <- dataframes$SCC
    do.analysis(NEI,SCC,plot.to.file = TRUE)
}
