## Global plot file name
png.name <- "plot4.png"

library(dplyr)
library(ggplot2)

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
    
    ## Plot total emissions of coal combustion-related over years
    g <- qplot(year, total.emission, data = data, 
               main = "Total coal combustion-related emissions of United States",
               ylab = "Total Emissions in tons")
    ## Adjust X axis
    g1 <- g + scale_x_continuous(name = "Year",breaks = unique(data$year))
    ## Plot points and smooth line
    g2 <- g1 + geom_line(stat = "smooth", method = "lm", se = F, size = .5, 
                         color = "blue")
    ## Render graph
    print(g2)
    
    if(plot.to.file) dev.off()
}

do.analysis <- function(NEI,SCC,plot.to.file = FALSE) {
    if (!missing(NEI) & !missing(SCC)) { ## check if data is present
        ## Get Coal Combustion
        ## As assumption coal combustion are sources from EI.Sector Fuel Comb
        ## Based on (https://www.epa.gov/sites/production/files/2016-09/emission_data_source_2.xlsx)
        ## Coal Combustion are those sectors with "coal" expression in its names
        
        SCC_Codes <- SCC %>% filter(grepl("fuel comb",EI.Sector,ignore.case = T)) %>%
            filter(grepl("coal",EI.Sector,ignore.case = T)) %>%
            select(SCC)
        coal.comb_Emissions <- NEI %>% filter(SCC %in% SCC_Codes[,1]) %>%
            group_by(year) %>% summarise(total.emission = sum(Emissions))
        
        plot.data(coal.comb_Emissions,plot.to.file)
    }
}

print("Running analysis Plot 4..")
if(!exists("dataframes")) {
    dataframes <<- read.files()
}

## Automatic run analysis as default
if(!exists("only.source") | !only.source) {
    NEI <- dataframes$NEI
    SCC <- dataframes$SCC
    do.analysis(NEI,SCC,plot.to.file = TRUE)
}
