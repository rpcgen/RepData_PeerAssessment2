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
        }

        data <- read.csv(keyfiles$datafile)
        return(data)
    }

    dataobj <- list(getData = getData)
    return(dataobj)
}
library(ggmap)
dataobj <- createDataObject()
data <- dataobj$getData()
data <- read.csv('data/data.csv.bz2')
minidata <- read.csv('data/data.mini.csv')
fminidata<- minidata[minidata$FATALITIES>0,c('LONGITUDE','LATITUDE','FATALITIES')]
fdata<- data[data$FATALITIES>0,c('LONGITUDE','LATITUDE','FATALITIES')]
fminidata<- fminidata[complete.cases(fminidata),]
fdata<- fdata[complete.cases(fdata),]
f2data <- fdata[fdata$LONGITUDE < 12500 & fdata$LONGITUDE > 6900,]
map <- get_map(location = c(lon = -97, lat = 40), maptype="terrain", zoom=4)
ggmap(map) + geom_point(aes(x=-LONGITUDE/100, y=LATITUDE/100, size=log(FATALITIES), color=log(FATALITIES)), data=f2data) + scale_colour_gradient(low="orange", high="red")

data$YEAR <- factor((gsub('.*(\\d{4}).*', '\\1', as.character(data$BGN_DATE))))
aggfatyr <- aggregate(data$FATALITIES, list(data$YEAR), sum)
barplot(aggfatyr$x)
plot(as.character(aggfatyr$Group.1),aggfatyr$x, type='l')
