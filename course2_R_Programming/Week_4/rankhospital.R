## rankhospital function finds the hospital with provided rank at provided state 
##      and on provided outcome
## 'state' is a char vector with state name
## 'outcome' the name of outcome, that could be "heart attack", "heart failure" 
##      or "pneumonia"
## 'num' is the required Rank of hospital. It can be a number or words like "best" and "worst"
## Return the name of hospital found at state and outcome rank
rankhospital <- function(state, outcome, num = "best") {
    outcomeColumns <- c("heart attack" = 11, "heart failure" = 17, "pneumonia" = 23) # valid outcomes
    outcomeName <- outcomeColumns[outcome]
    ## Read outcome data
    outcomeData <- read.csv("outcome-of-care-measures.csv",colClasses = "character") #data.frame
    outcomeStates <- unique(outcomeData$State) # valid states
    ## Check that state and outcome are valid
    validState <- state %in% outcomeStates
    validOutcome <- !is.na(outcomeName)
    if (!validState) stop("invalid state")
    if (!validOutcome) stop("invalid outcome")
    
    ## Getting state hospitals
    stateHospitalsOutcomes <- outcomeData[outcomeData$State == state,]
    ## converting required outcome to number
    stateHospitalsOutcomes[,outcomeName] = as.num(stateHospitalsOutcomes[,outcomeName],
                                                  na.strings = "Not Available")
    ## excluding NAs
    bads <- is.na(stateHospitalsOutcomes[,outcomeName])
    stateHospitalsOutcomes <- stateHospitalsOutcomes[!bads,]
    
    rank <- 9999 ## variable representing requested rank
    ## Validate requested rank
    if (is.numeric(num) & length(num) > 0) {
        rank <- num
    }
    else if (!is.numeric(num) & length(num) > 0 & num == "best") {
        rank <- 1
    }
    else if (!is.numeric(num) & length(num) > 0 & num == "worst") {
        rank <- nrow(stateHospitalsOutcomes)
    }
    
    if (rank > nrow(stateHospitalsOutcomes)) {
        return(NA)
    }
    
    # Ranking outcome values
    #stateHospitalsOutcomes <- stateHospitalsOutcomes[order(stateHospitalsOutcomes[,outcomeName],decreasing = FALSE),]
    # First sort hospitals by its name, so rank function ranks by first occurance
    stateHospitalsOutcomes <- stateHospitalsOutcomes[order(stateHospitalsOutcomes[,"Hospital.Name"],decreasing = FALSE),]
    ranks <- rank(stateHospitalsOutcomes[,outcomeName], ties.method = "first")
    hospitalRanks <- cbind(stateHospitalsOutcomes,ranks = ranks)
    
    # Find Hospitals with required rank
    hospitals <- hospitalRanks[hospitalRanks["ranks"] == rank,]
    
    if (nrow(hospitals) > 1) { ## a Tie! Get first in alphabetic order
        hospitals <- hospitals[order(hospitals[,"Hospital.Name"],decreasing = FALSE),]
    }
    ## Return hospital name in that state with lowest 30-day death
    ## rate
    hospitals[1,"Hospital.Name"]
    
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