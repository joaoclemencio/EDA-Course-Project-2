require(lubridate)
require(ggplot2)
require(reshape2)

#Download and read files
if(!(file.exists("Source_Classification_Code.rds"))){
  download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "dataset.zip")
  unzip("dataset.zip")
  file.remove("dataset.zip")
}

SCC <- readRDS(file = "Source_Classification_Code.rds")
for(i in names(SCC)){
    SCC[[i]] <- as.factor(SCC[[i]])
    SCC[[i]][SCC[[i]]==""] <- NA
    SCC[[i]][SCC[[i]]==" "] <- NA
}
SCC <- droplevels(SCC)
#maybe not even useful...
SCC$Created_Date <- mdy_hms(SCC$Created_Date)
SCC$Revised_Date <- mdy_hms(SCC$Revised_Date)

#clean up
NEI <- readRDS(file = "summarySCC_PM25.rds")
NEI$Pollutant <- NULL

for(i in names(NEI)){
    if(i!="Emissions"){
        NEI[[i]] <- as.factor(NEI[[i]])
    }
}

NEI$fips[NEI$fips == "   NA"] <- NA
NEI$fips <- droplevels(NEI$fips)


total.emissions <- aggregate(Emissions ~ year, data = NEI, sum)

baltimore.fips <- "24510"

baltimore <- NEI[NEI$fips==baltimore.fips,]

baltimore.total.emissions <- aggregate(Emissions ~ year, data = baltimore, sum)

baltimore.bytype <- aggregate(Emissions ~ year + type, data = baltimore, sum)
baltimore.bytype <- dcast(baltimore.bytype, year ~ type)
