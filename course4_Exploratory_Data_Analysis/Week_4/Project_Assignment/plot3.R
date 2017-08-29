## Global plot file name
png.name <- "plot3.png"

## Load dependencies
library(ggplot2)
library(dplyr)

## Read data files and return a list with those 2 data frames
read.files <- function() {
    NEI <- readRDS("./data/summarySCC_PM25.rds")
    SCC <- readRDS("./data/Source_Classification_Code.rds")
    data <- list(NEI = NEI,SCC = SCC)
    return(data)
}

## Basic function to do plotting to a file or console
plot.data <- function(data, plot.to.file = FALSE) {
    if (plot.to.file) png(paste(".","plots",png.name,sep = "/"),width = 1024, height = 768) ## plot to png under plots folder
    else x11() ## open a new plotting window
    
    ## Plot Baltimore totalized emissions, cathegorized by emission source type
    ## over the years 1999 ~ 2008
    
    ## Create panels for each emission source type
    g <- qplot(year,total.emission,data = data,facets = .~type,
               main = "Total PM2.5 emissions in Baltimore City cathegorized by source type",
               ylab = "Total Emissions in tons")
    ## Plot a smoother to clarify if a type decreased or increased emissions
    g2 <- g + geom_line(stat = "smooth", method="lm", se = FALSE, size = .5, 
                       color = "blue")
    ## render graph
    print(g2)
    
    if(plot.to.file) dev.off()
}

do.analysis <- function(NEI,SCC,plot.to.file = FALSE) {
    if (!missing(NEI)) { ## check if data is present
        
        ## get only Baltimore City, Maryland (fips == "24510")
        baltimoreData <- NEI[NEI$fips == "24510",]
        
        ## Group Baltimore City data by source type and year
        summarised <- baltimoreData %>% group_by(type,year) %>% 
            summarise(total.emission = sum(Emissions))
        
        plot.data(summarised,plot.to.file)
    }
}

print("Running analysis Plot 3..")
if(!exists("dataframes")) {
    dataframes <<- read.files()
}

## Automatic run analysis as default
if(!exists("only.source") | !only.source) {
    NEI <- dataframes$NEI
    SCC <- dataframes$SCC
    do.analysis(NEI,SCC,plot.to.file = TRUE)
}
