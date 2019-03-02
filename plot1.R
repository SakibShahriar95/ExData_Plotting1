#download file to my local repo and unzip
file.url<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
download.file(file.url,destfile='C:/Users/skb67/Desktop/CourseraDS/Exploratory Data Analysis/Week1-Assignment/power_consumption.zip')
unzip('C:/Users/skb67/Desktop/CourseraDS/Exploratory Data Analysis/Week1-Assignment/power_consumption.zip',exdir='source data',overwrite=TRUE)
library(data.table)
library(lubridate)
#read in table format and create a data frame
t <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))

#format the date
t$Date <- as.Date(t$Date, "%d/%m/%Y")
#select the data between 2007-2-1 and 2007-2-2 (Feb 1 and 2)
t <- subset(t,Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))
#make sure there are only complete readings
t <- t[complete.cases(t),]
#use paste to merge the columns
CombDT <- paste(t$Date, t$Time)
#name of the column is DateTimeCombined
CombDT <- setNames(CombDT, "DateTimeCombined")
#remove the old columns
t <- t[ ,!(names(t) %in% c("Date","Time"))]
#add the new column using cbind
t <- cbind(CombDT, t)
t$CombDT <- as.POSIXct(dateTime)
#necessary margin adjustment
par(mar=c(3,3,3,3))


hist(t$Global_active_power, main="Global Active Power", xlab = "Global Active Power (kilowatts)", ylab="Frequency",col="orange")


dev.copy(png,"plot1.png", width=480, height=480)
#close file device
dev.off()