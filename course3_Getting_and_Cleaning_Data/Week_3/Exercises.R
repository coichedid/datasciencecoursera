# Question 1 households > 10 acres and 10,000 worth of agriculture products
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url,"data/idaho_survey_2006.csv")
survey <- read.csv("./data/idaho_survey_2006.csv")
head(survey)
tail(survey)
agricultureLogical <- survey[which(ACR == 3 & AGS == 6)]
which(survey$ACR == 3 & survey$AGS == 6)
ifelse(survey$ACR == 3 & survey$AGS == 6)
ifelse(survey$ACR == 3 & survey$AGS == 6,T,F)
agricultureLogical <- ifelse(survey$ACR == 3 & survey$AGS == 6,T,F)
table(agricultureLogical)
which(agricultureLogical) # Values True

#Question 2 30th and 80th quantiles
install.packages("jpeg")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg","./data/jeff.jpg")
jpeg::readJPEG("./data/jeff.jpg")
pic <- jpeg::readJPEG("./data/jeff.jpg",native = TRUE)
quantile(pic,c(0.3,0.8))

# Question 3 match ids and get 13th country sorted desc by ranking
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv","./data/FGDP.csv")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv","./data/education.csv")
merged <- merge(fgdp,education,by.x = "countryID",by.y = "CountryCode",all = F)
fgdp <- read.csv("./data/FGDP.csv",header = F,skip = 5,na.strings = "..",col.names = c("countryID","ranking","skip1","economy","value","skip2","skip3","skip4","skip5","skip6"),stringsAsFactors = F,blank.lines.skip = T)
education <- read.csv("./data/educational.csv")
fgdp <- fgdp[,c(1,2,4,5)]
fgdp <- fgdp[1:190,]
library(dplyr)
merged <- merge(education,fgdp,by.y = "countryID",by.x = "CountryCode", all = F)
sorted <- arrange(merged,desc(ranking))
sorted[10:15,c("CountryCode","Long.Name","ranking")]

# Question 4 summarise ranking by Income.Group
sorted <- sorted[!is.na(sorted$value),]
sorted$value <- gsub(" ","",sorted$value)
sorted$value <- gsub(",","",sorted$value)
sorted$value <- as.numeric(sorted$value)
gb <- group_by(sorted,Income.Group)
summarise(gb,gdp_mean = mean(ranking))

#question 5 cut into 5 quantiles and cross with Income.Group
install.packages("Hmisc")
library(Hmisc)
sorted$quantiles <- cut(sorted$ranking,c(quantile(sorted$ranking,probs = seq(0,1,by=0.20))), include.lowest=TRUE)
table(sorted$quantiles,sorted$Income.Group)
