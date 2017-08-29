# Question 1 split wgtp
data <- read_csv("./data/idaho_housing.csv")
names(data)
n <- names(data)
s <- strsplit(n,"wgtp")
s[123]
# Question 2 mean value
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(url,"./data/fgdp.csv")
fgdp <- read.csv("./data/fgdp.csv",header = F,skip = 5,na.strings = "..",col.names = c("countryID","ranking","skip1","economy","value","skip2","skip3","skip4","skip5","skip6"),stringsAsFactors = F,blank.lines.skip = T)
fgdp <- fgdp[1:190,c(1,2,4,5)]
fgdp$value <- gsub(" ","",fgdp$value)
fgdp$value <- gsub(",","",fgdp$value)
fgdp2 <- fgdp[!is.na(fgdp$value)]
fgdp$value <- as.numeric(fgdp$value)
fgdp2 <- fgdp[!is.na(fgdp$value),]
mean(fgdp2$value)
# Question 3 get country names begging with United
countrNames <- fgdp2[,c("economy")]
countryNames <- fgdp2[,c("economy")]
countryNames
grep("^United",countryNames)
#Question 4 Num of fiscal year ends in June
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv","./data/educational.csv")
education <- read.csv("./data/educational.csv")
merged <- merge(fgdp,education,by.x = "countryID",by.y = "CountryCode",all = F)
fiscaldata <- grep("^Fiscal year end:",merged$Special.Notes)
fiscaldata
fiscaldata <- grep("^Fiscal year end:",merged$Special.Notes, value = T)
fiscaldata
#Question 5 Collected values on mondays of 2012
install.packages("stringr")
library(stringr)
fiscaldata
str_extract(fiscaldata,"^.*: (.*?);.*")
str_match(fiscaldata,"^.*: (.*?);.*")
month <- str_match(fiscaldata,"^.*: (.*?);.*")[,2]
month
month <- as.Date(month,"%B %d")
month
library(lubridate)
help(package = lubridate)
month(month[1])
months(month[1])
months(month)
grep(months(month),"June")
monthnames <- months(month)
class(monthnames)
grep("June",monthnames)
nrow(grep("June",monthnames))
length(grep("June",monthnames))
library(quantmod)
install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign = F)
amzn = getSymbols("AMZN",auto.assign = FALSE)
sampleTimes = index(amzn)
class(sampleTimes)
years <- year(sampleTimes)
years
years == 2012
years2012 <- years[years == 2012]
years2012
length(years2012)
d2012 <- sampleTimes[year(sampleTimes) == 2012]
length(d2012)
wday(d2012[1])
head(d2012)
weekdays(d2012[1])
mondays <- d2012[wday(d2012) == 2]
length(mondays)
