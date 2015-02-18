createDataObject <- function(basedir='data') {
  
  url <- 'http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2'
  
  keyfiles <- list(
    datafile = sprintf('%s/data.csv.bz2', basedir)
  )
  
  getData <- function(...) {
    
    if (!all(file.exists(unlist(keyfiles)))) {
      
      if (file.exists(basedir)) {
        unlink(basedir, recursive=T)
      }
      
      dir.create(basedir)
      download.file(url, keyfiles$datafile, ...)
      
      data <- read.csv(keyfiles$datafile)
      return(data)
    }
  }
  
  dataobj <- list(getData = getData)
  return(dataobj)
}

dataobj <- createDataObject()
data <- dataobj$getData()

