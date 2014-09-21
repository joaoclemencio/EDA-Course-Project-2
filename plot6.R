#Plot 6

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

fips <- data.frame("ID" = c("24510", "06037"), "Location" = c("Baltimore", "Los Angeles County"))

ba.la.on.road.emissions <- NEI[NEI$fips %in% fips.vector & NEI$type == "ON-ROAD", ]

total.ba.la.on.road.emissions <- aggregate(Emissions ~ year + fips, data = ba.la.on.road.emissions, sum)

total.ba.la.on.road.emissions <- merge(x = total.ba.la.on.road.emissions, y = fips, by.x = "fips", by.y = "ID")
total.ba.la.on.road.emissions$fips = NULL

png(filename = "plot6.png", width = 480, height = 480, units = "px")

ggplot(total.ba.la.on.road.emissions, aes(year, Emissions, group=Location)) + 
  geom_point(stat = "identity") + geom_line() + facet_grid(Location~., scales = "free_y") + 
  ggtitle("Total On-Road Emissions by Location") + 
  ylab("Emissions (Tons of PM2.5)") + xlab("Year")

dev.off()
