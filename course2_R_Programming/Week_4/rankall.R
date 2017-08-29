## rankall function finds the hospitals with provided rank for every state for provided outcome
## 'outcome' the name of outcome, that could be "heart attack", "heart failure" 
##      or "pneumonia"
## 'num' is the required Rank of hospital. It can be a number or words like "best" and "worst"
## Return the name of hospital found at state and outcome rank
rankall <- function(outcome, num = "best") {
    outcomeColumns <- c("heart attack" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack", 
                        "heart failure" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
                        "pneumonia" = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
                        ) # valid outcomes
    outcomeName <- outcomeColumns[outcome]
    ## Read outcome data
    outcomeData <- read.csv("outcome-of-care-measures.csv",colClasses = "character") #data.frame
    
    ## Check that state and outcome are valid
    validOutcome <- !is.na(outcomeName)
    if (!validOutcome) stop("invalid outcome")
    
    ## converting required outcome to number
    outcomeData[,outcomeName] = as.num(outcomeData[,outcomeName],
                                                  na.strings = "Not Available")
    ## excluding NAs
    bads <- is.na(outcomeData[,outcomeName])
    outcomeData <- outcomeData[!bads,]
    
    rank <- "worst" ## variable representing requested rank
    ## Validate requested rank
    if (is.numeric(num) & length(num) > 0) {
        rank <- num
    }
    else if (!is.numeric(num) & length(num) > 0 & num == "best") {
        rank <- 1
    }
    
    ## Aggregating data by State names
    data <- outcomeData[,c("Hospital.Name","State",outcomeName)]
    outcomeByState <- split(data,data$State)
    
    ## sorting each dataframe by hospital name
    outcomeByState <- lapply(outcomeByState,function(d){d[order(d[,"Hospital.Name"],decreasing = FALSE),]})
    ## Rank every state
    outcomeByState <- lapply(outcomeByState,function(d){cbind(d,rank = rank(d[,outcomeName], ties.method = "first"))})
    
    ## Get ranked hospitals
    rankedHospitals <- do.call(rbind,lapply(outcomeByState,getRanked,rank = rank))
    
    rankedHospitals
}

## as.num function coerce strings into numbers with unavailable treatement
## 'x' is a character vector
## 'na.strings' is value of unavailable values
## Return new vector with coerced values
as.num = function(x, na.strings = "NA") {
    stopifnot(is.character(x))
    na = x %in% na.strings
    x[na] = 0
    x = as.numeric(x)
    x[na] = NA_real_
    x
}

## getRanked function finds hospital ranked as provided rank or NA for non hospitals
## 'd' is a dataframe with Hospital.Name, State and rank columns
## 'rank' target rank value
## Return a dataframe with single line with found hospital
getRanked = function(d, rank = 1) { 
    eachRank <- rank
    if (rank == "worst") { ## set worst rank for each case
        eachRank <- nrow(d)
    }
    r <- d[d$rank == eachRank,c("Hospital.Name","State")]
    colnames(r) <- c("hospital","state")
    if (nrow(r) == 0) {
        r <- data.frame(hospital = NA,state = d[["State"]])
    }
    r[1,]
}