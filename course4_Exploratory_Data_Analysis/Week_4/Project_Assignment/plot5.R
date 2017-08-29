## Global plot file name
png.name <- "plot5.png"

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
    
    ## Plot total emissions of motor vehicles on Baltimore City over years
    g <- qplot(year, total.emission, data = data, 
               main = "Total emissions of Motor Vehicles in Baltimore City",
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
        ## Get Motor Vehicles
        ## As assumption Motor Vehicle is a self-propelled road vehicle or off-road 
        ##      vehicle, commonly wheeled, that does not operate on rails, 
        ##      such as trains or trams and used for the transportation of passengers, 
        ##      or passengers and property 
        ## Based on (https://en.wikipedia.org/wiki/Motor_vehicle)
        ## So, Motor Vehicler are those from EI.Sector Mobile, except Aircraft, 
        ##      Commercial Marine Vessels, Locomotives
        ## Based on (https://www.epa.gov/sites/production/files/2016-09/emission_data_source_2.xlsx)
        
        SCC_Codes <- SCC %>% filter(grepl("mobile",EI.Sector,ignore.case = T)) %>%
            filter(!grepl("Aircraft",EI.Sector,ignore.case = T)) %>%
            filter(!grepl("Commercial Marine Vessels",EI.Sector,ignore.case = T)) %>%
            filter(!grepl("Locomotives",EI.Sector,ignore.case = T)) %>%
            select(SCC)
        
        ## Filter data with Motor Vehicles SCC codes and belongs to Baltimore City
        ## Also summirise filtered data getting total by years
        motor.vehicles_Emissions <- NEI %>% filter(SCC %in% SCC_Codes[,1]) %>%
            filter(fips == "24510") %>% group_by(year) %>%
            summarise(total.emission = sum(Emissions))
        
        plot.data(motor.vehicles_Emissions,plot.to.file)
    }
}

print("Running analysis Plot 5..")
if(!exists("dataframes")) {
    dataframes <<- read.files()
}

## Automatic run analysis as default
if(!exists("only.source") | !only.source) {
    NEI <- dataframes$NEI
    SCC <- dataframes$SCC
    do.analysis(NEI,SCC,plot.to.file = TRUE)
}
