paste(1:3,c("X","Y","Z"),sep = "")
paste(LETTERS,1:4,sep="-")
x <- c(44,NA,5,NA)
x*3
y <- rnorm(1000)
z <- rep(NA,1000)
my_data <- sample(c(y,z),100)
my_na <- is.na(my_data)
my_na
my_data == NA
sum(my_na)
my_data
0/0
Inf - Inf
x
bye()
swirl()
x
x[1:10]
x[is.na(x)]
y <- x[!is.na(x)]
y
y[y > 0]
x[x > 0]
x[!is.na(x) & x > 0]
x[c(3,5,7)]
x[0]
x[3000]
x[c(-2,-10)]
x[-c(2,10)]
vect <- c(foo=11,bar=2,norf=NA)
vect
names(vect)
vect2 <- c(11,2,NA)
names(vect2) <- c("foo","bar","norf")
identical(vect,vect2)
vect["bar"]
vect[c("foo","bar")]
my_vector <- 1:20
my_vector
dim(my_vector)
length(my_vector)
dim(my_vector) <- c(4,5)
dim(my_vector)
attributes(my_vector)
my_vector
class(my_vector)
my_matrix <- my_vector
?matrix
my_matrix2 <- matrix(data = 1:20,nrow = 4,ncol = 5)
identical(my_matrix,my_matrix2)
patients <- c("Bill","Gina","Kelly","Sean")
cbind(patients,my_matrix)
my_data <- data.frame(patients,my_matrix)
my_data
class(my_data)
cnames <- c("patient","age","weight","bp","rating","test")
colnames(my_data) <- cnames
my_data
bye()
install.packages(xlsx)
install.packages("xlsx")
library(xlsx)
library(rJava)
remove.packages("rJava")
library(rJava)
remove.packages("xlsx")
library(rJava)
library(xlsx)
install.packages("rJava",type = "source")
install.packages("xlsx")
library(xlsx)
library(rJava)
library(rJava)
options("java_home")
options("java_home"="/Library/Java/JavaVirtualMachines/jdk1.8.0_66.jdk/Contents/Home")
options("java_home")
library(rJava)
library(rJava)
library(rJava)
options("java_home")
remove.packages("rJava")
remove.packages("xlsx")
library(rJava)
library(rJava)
R.version
install.packages("XML")
library(XML)
uri <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(uri,useInternalNodes = T)
doc <- xmlTreeParse(uri,useInternalNodes = T)
uri <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(uri,useInternalNodes = T)
root <- xmlRoot(doc)
xmlName(root)
names(root)
zipCodes <- xpathSApply(root,"//zipcode",xmlValue)
zipCodes
listZipCodes <- list(zipcodes = zipCodes)
listZipCodes
names(listZipCodes)
listZipCodes[listZipCodes$zipcodes == "21231"]
listZipCodes[listZipCodes$zipcodes == "21231",]
dfZips <- data.frame(zipCodes = zipCodes)
dfZips[listZipCodes$zipcodes == "21231",]
zips <- dfZips[listZipCodes$zipcodes == "21231",]
zips <- dfZips[dfZips$zipcodes == "21231",]
dfZips[dfZips$zipcodes == "21231",]
dfZips <- data.frame(zipCodes = zipCodes,stringsAsFactors = FALSE)
dfZips[dfZips$zipcodes == "21231",]
View(dfZips)
dfZips
goods <- dfZips$zipCodes == "21231"
goods
dfZips[goods]
dfZips[goods,]
dfZips[dfZips$zipCodes == "21231",]
nRow(dfZips[dfZips$zipCodes == "21231",])
nrow(dfZips[dfZips$zipCodes == "21231",])
NROW(dfZips[dfZips$zipCodes == "21231",])
zips <- dfZips[dfZips$zipCodes == "21231",]
unique(dfZips$zipCodes)
getwd()
setwd("~/Projetos/Data_Science/datasciencecoursera/course3_Getting_and_Cleaning_Data/Week_1")
uri <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(uri,"./data/housing.idaho.csv")
library(data.table)
install.packages("data.table")
library(data.table)
?fread
fread("./data/housing.idaho.csv",sep = ",",header = T)
DT <- fread("./data/housing.idaho.csv",sep = ",",header = T)
system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2])
system.time((rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]))
system.time(rowMeans(DT)[DT$SEX==1];rowMeans(DT)[DT$SEX==2])
system.time(getwd())
a <- system.time(getwd())
a
df <- data.frame(a)
source("./meanComputationProfiling")
source("./meanComputationProfiling.R")
source("./meanComputationProfilling.R")
profile(DT)
class(DT)
source("./meanComputationProfilling.R")
profile(DT)
source("./meanComputationProfilling.R")
profile(DT)
system.time(withMean(DT))
system.time(withMeanMean(DT))
system.time(withTapply(DT))
system.time(withData.Table.Features(DT))
system.time(withSapply(DT))
read.csv("./data/housing.csv",header = TRUE)
housing <- read.csv("./data/housing.csv",header = TRUE)
bad <- housing[is.na(housing$VAL)]
good <- housing[!is.na(housing$VAL),]
good[good$VAL==24]
good[good$VAL==24,]
nrow(good[good$VAL==24,])
library(xlsx)
gas <- read.xlsx("./data/natural.gas",sheetIndex = 1,rowIndex = 18:23,colIndex = 7:15)
gas <- read.xlsx("./data/natural.gas.xlsx",sheetIndex = 1,rowIndex = 18:23,colIndex = 7:15)
sum(gas$Zip*gas$Ext,na.rm = T)
library(XML)
source("./meanComputationProfilling.R")
system.time(withMean(DT))
system.time(withMeanMean(DT))
system.time(withData.Table.Features(DT))
system.time(withRowMeans(DT))
system.time(withMean(DT))
system.time(withTapply(DT))
system.time(withSapply(DT))
system.time(withMeanMean(DT))
system.time(withData.Table.Features(DT))
system.time(withMean(DT))
system.time(withTapply(DT))
system.time(withSapply(DT))
system.time(withMeanMean(DT))
system.time(withData.Table.Features(DT))
system.time(withMean(DT))
system.time(withTapply(DT))
source("./meanComputationProfilling.R")
Rprof()
?Rprof
source("./meanComputationProfilling.R")
profile(DT)
View(DT)
source("./meanComputationProfilling.R")
profile(DT)
profile(DT)
profile(DT)
profile(DT)
sum(gas$Zip*gas$Ext,na.rm = T)
install.packages("httr")
library(mttr)
library(httr)
oauth_endpoints("github")
myapp <- oauth_app("github", key = "93d4c08b83b1375c57c8", secret = "8087c3f76d3c42def49f9e9bad32f33ea032246d")
github_token <- oauth2.0_token(oauth_endpoints("github"),myapp)
install.packages("httpuv")
github_token <- oauth2.0_token(oauth_endpoints("github"),myapp)
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/rate_limit",gtoken)
stop_for_status(req)
content(req)
req <- GET("https://api.github.com/users/jtleek/repos",gtoken)
stop_for_status(req)
data_content <- content(req)
names(data_content)
data_content
str(data_content)
colnames(data_content)
library(jsonlite)
data <- fromJSON(toJSON(data_content))
names(data)
data$name
repo <-data[data$name == "datasharing",]
repo
names(repo)
repo$created_at
getwd()
setwd("../")
getwd()
dir.create("./Week_2")
setwd("./Week_2")
dir.create("./data")
uri = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(uri,"data/american_survey.csv")
data = read.csv("./data/american_servey.csv",header = T)
data = read.csv("./data/american_survey.csv",header = T)
install.packages("sqldf")
library(sqldf)
install.packages("tcltk")
library(sqldf)
sqldf("select pwgtp1 from data where AGEP < 50")
sqldf("select distinct AGEP from data")
uri = "http://biostat.jhsph.edu/~jleek/contact.html"
con = url(uri)
htmlCode = readLines(con)
close(con)
lines = htmlCode[c(10,20,30,100)]
lines
sapply(lines,nchar)
uri = "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
download.file(uri,"./data/wkssr8110.for")
widths = c(1,14,13,13,13,8)
widths = c(1,9,5,4,4,5,4,4,5,4,4,5,4,4)
read.fwf("./data/wkssr8110.for",widths = widths,skip = 3)
data <- read.fwf("./data/wkssr8110.for",widths = widths,skip = 3)
data <- data[,c(2,4,5,7,8,10,11,13,14)]
data
data[,4] <- as.numeric(data[,4])
data
data <- read.fwf("./data/wkssr8110.for",widths = widths,skip = 3)
data <- data[,c(2,4,5,7,8,10,11,13,14)]
data
data[,4]
col <- data[,4]
class(col)
data <- read.fwf("./data/wkssr8110.for",widths = widths,skip = 3,as.is = 1:14)
data <- data[,c(2,4,5,7,8,10,11,13,14)]
col <- data[,4]
class(col)
col <- as.numeric(col)
class(col)
col
col <- col[!is.na(col)]
col
sum(col)
swirl()
library(swirl)
swirl()
library(dplyr)
cran <- tbl_df(mydf)
rm("mydf")
cran
?group_by
by_package <- group_by(cran,package)
by_package
summarize(by_package,mean(size))
submit()
submit()
pack_sum
quantile(pack_sum$count,probs = 0.99)
top_counts = filter(pack_sum,count > 679)
top_counts <- filter(pack_sum,count > 679)
top_counts
View(top_counts)
top_counts_sorted <- arrange(top_counts,desc(count))
View(top_counts_sorted)
quantile(pack_sum$unique, probs = 0.99)
top_unique <- filter(pack_sum,unique > 465)
View(top_unique)
top_unique_sorted <- arrange(top_unique, desc(unique))
View(top_unique_sorted)
submit()
submit()
submit()
View(result3)
submit()
submit()
submit()
submit()
library(tidyr)
students
?gather
gather(students,sex,count,-grade)
students2
res <- gather(students2,sex_class, value,-grade)
res <- gather(students2,sex_class, count,-grade)
res
?separate
separate(data = res,col = sex_class, into = c("sex","class"))
submit()
students3
submit()
?spread
submit()
library(readr)
parse_number("class5")
parse_number("clas1s5")
?parse_number
submit()
submit()
students4
submit()
students4
submit()
submit()
passed
failed
passed <- mutate(passed,status = "passed")
failed <- mutate(failed,status = "failed")
bind_rows(passed,failed)
sat
reset()
swirl()
submit()
submit()
submit()
