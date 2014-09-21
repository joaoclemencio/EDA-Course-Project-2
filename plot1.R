#Plot 1

require(lubridate)

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

total.emissions <- aggregate(Emissions ~ year, data = NEI, sum)

png(filename = "plot1.png", width = 480, height = 480, units = "px")

barplot(total.emissions$Emissions, names.arg = total.emissions$year, xlab = "Year", ylab = "Emissions (Tons of PM2.5)", main = "Total Emissions of PM2.5")

dev.off()
