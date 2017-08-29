## best function finds best hospital on some outcome in a state.
##      function also validate invalid states
## 'state' is a char vector with state name
## 'outcome' the name of outcome, that could be "heart attack", "heart failure" 
##      or "pneumonia"
## Return the name of best hospital found
best <- function(state, outcome) {
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
    
    #Find minimal rate and get Hospitals with this rate. Optimization point: merge next 2 instructions
    bestHospitalRate <- min(stateHospitalsOutcomes[,outcomeName])
    bestHospital <- stateHospitalsOutcomes[stateHospitalsOutcomes[outcomeName] == bestHospitalRate,]
    
    if (nrow(bestHospital) > 1) { ## a Tie! Get first in alphabetic order
        bestHospital <- bestHospital[order(bestHospital[,"Hospital.Name"],decreasing = FALSE),]
    }
    ## Return hospital name in that state with lowest 30-day death
    ## rate
    bestHospital[1,"Hospital.Name"]
    
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