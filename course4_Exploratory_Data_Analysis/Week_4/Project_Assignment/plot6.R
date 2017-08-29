## Global plot file name
png.name <- "plot6.png"

library(dplyr)
library(ggplot2)
require(gridExtra)

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
    
    ## Plot padronized emissions on LA and Baltimore of Motor Vehicles
    g <- ggplot(data, aes(x=year,y=padronized.emissions, group=fips, colour=fips,
                          ylab = "Total Emissions in tons")) +
        ggtitle("Total emissions of Motor Vehicles in Los Angeles and Baltimore City") +
        labs(y="Total emissions padronized by its average")
    ## Adjust X axis and legend lab
    g1 <- g + scale_x_continuous(name = "Year",breaks = unique(data$year)) +
        scale_color_manual(labels = c("06037"="LA", "24510"="Baltimore"), values = c("blue", "red"))
    ## Plot points and smooth line
    g2 <- g1 + geom_line(stat = "smooth", method = "lm", se = F, size = .5) + 
        geom_point()
    ## Render graph
    
    ## Plot total emissions on LA and Baltimore of Motor Vehicles
    city_labels <- c("06037"="LA", "24510"="Baltimore")
    g3 <- qplot(year, total.emission, data = data, 
               main = "Total emissions of Motor Vehicles",
               ylab = "Total Emissions in tons") +
        facet_grid(.~fips, labeller = as_labeller(city_labels))
    ## Adjust X axis and legend lab
    g4 <- g3 + scale_x_continuous(name = "Year",breaks = unique(data$year)) 
    ## Plot points and smooth line
    g5 <- g4 + geom_line(stat = "smooth", method = "lm", se = F, size = .5, 
                         color = "red") 
    grid.arrange(g5,g2,ncol=2)
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
        
        ## Filter data with Motor Vehicles SCC codes and 
        ##      belongs to Baltimore City or Los Angeles County
        ## Also summirise filtered data getting total by years
        motor.vehicles_Emissions <<- NEI %>% filter(SCC %in% SCC_Codes[,1]) %>%
            filter(fips %in% c("24510","06037")) %>% group_by(fips,year) %>%
            summarise(total.emission = sum(Emissions))
        
        ## To be able to compare evolution on motor vehicles emissions changes, 
        ##      we need to have both measures in the same scale. 
        ##      To do so, we divide each city year emission by its emission average
        ##      over all years. With that we have a proportion of emissions related 
        ##      with city average emission
        la_emissions <- motor.vehicles_Emissions[motor.vehicles_Emissions$fips == "06037",]$total.emission
        la_emissions <- la_emissions / mean(la_emissions)
        
        ba_emissions <- motor.vehicles_Emissions[motor.vehicles_Emissions$fips == "24510",]$total.emission
        ba_emissions <- ba_emissions / mean(ba_emissions)
        ## Add a new variable to dataframe with padronized emissions
        motor.vehicles_Emissions$padronized.emissions <- c(la_emissions,ba_emissions)
        plot.data(motor.vehicles_Emissions,plot.to.file)
    }
}

print("Running analysis Plot 6..")
if(!exists("dataframes")) {
    dataframes <<- read.files()
}

## Automatic run analysis as default
if(!exists("only.source") | !only.source) {
    NEI <- dataframes$NEI
    SCC <- dataframes$SCC
    do.analysis(NEI,SCC,plot.to.file = TRUE)
}
