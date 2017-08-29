withRowMeans <- function(DT) {
    ptm <- proc.time()
    x <- rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
    proc.time() - ptm
}

withMean <- function(DT) {
    ptm <- proc.time()
    x <- mean(DT$pwgtp15,by=DT$SEX)
    proc.time() - ptm
}

withMeanMean <- function(DT) {
    ptm <- proc.time()
    x <- mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
    proc.time() - ptm
}

withTapply <- function(DT) {
    ptm <- proc.time()
    x <- tapply(DT$pwgtp15,DT$SEX,mean)
    proc.time() - ptm
}

withData.Table.Features <- function(DT) {
    ptm <- proc.time()
    x <- DT[,mean(pwgtp15),by=SEX]
    proc.time() - ptm
}

withSapply <- function(DT) {
    ptm <- proc.time()
    x <- sapply(split(DT$pwgtp15,DT$SEX),mean)
    proc.time() - ptm
}

profile <- function(DT) {
    #print("withRowMeans")
    #system.time(withRowMeans(DT))
    print("withMean")
    a <- withMean(DT)
    print(a)
    print("withMeanMean")
    b <- withMeanMean(DT)
    print(b)
    print("withTapply")
    c <- withTapply(DT)
    print(c)
    print("withData.Table.Features")
    d <- withData.Table.Features(DT)
    print(d)
    print("withSapply")
    e <- withSapply(DT)
    print(e)
    return()
}