#Plot 3

require(lubridate)
require(ggplot2)

#Download and read files
if(!(file.exists("Source_Classification_Code.rds"))){
  download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "dataset.zip")
  unzip("dataset.zip")
  file.remove("dataset.zip")
}

#Variable creation and general cleanup
SCC <- readRDS(file = "Source_Classification_Code.rds")
for(i in names(SCC)){
  SCC[[i]] <- as.factor(SCC[[i]])
  SCC[[i]][SCC[[i]]==""] <- NA
  SCC[[i]][SCC[[i]]==" "] <- NA
}
SCC <- droplevels(SCC)
SCC$Created_Date <- mdy_hms(SCC$Created_Date)
SCC$Revised_Date <- mdy_hms(SCC$Revised_Date)

NEI <- readRDS(file = "summarySCC_PM25.rds")
NEI$Pollutant <- NULL
for(i in names(NEI)){
  if(i!="Emissions"){
    NEI[[i]] <- as.factor(NEI[[i]])
  }
}
NEI$fips[NEI$fips == "   NA"] <- NA
NEI$fips <- droplevels(NEI$fips)
rm(i)

#### Cleanup ends here ####

baltimore.fips <- "24510"

baltimore <- NEI[NEI$fips==baltimore.fips,]

baltimore.bytype <- aggregate(Emissions ~ year + type, data = baltimore, sum)

baltimore.bytype$Category <- c(rep("POINT", 4), rep("ROAD", 8), rep("POINT", 4))
baltimore.bytype$OnNon <- c(rep("NON", 8), rep("ON", 8))

png(filename = "plot3.png", width = 480, height = 480, units = "px")

ggplot(baltimore.bytype, aes(year, Emissions, fill=type)) + 
  geom_bar(stat = "identity") + facet_grid(Category~OnNon) + 
  ggtitle("Total Baltimore Emissions by Type") + 
  ylab("Emissions (Tons of PM2.5)") + xlab("Year") + theme(legend.position = "bottom")

dev.off()
