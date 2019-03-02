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
#specify we want 4 graphs in 2 row and 2 columns
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(t, {
    plot(Global_active_power~CombDT, type="l", 
         ylab="Global Active Power (kilowatts)", xlab="")
    plot(Voltage~CombDT, type="l", 
         ylab="Voltage (volt)", xlab="")
    plot(Sub_metering_1~CombDT, type="l", 
         ylab="Global Active Power (kilowatts)", xlab="")
    lines(Sub_metering_2~CombDT,col='Red')
    lines(Sub_metering_3~CombDT,col='Blue')
    legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2,bty="n",
           legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(Global_reactive_power~CombDT, type="l", 
         ylab="Global Rective Power (kilowatts)",xlab="")
})

dev.copy(png, file="plot4.png", height=400, width=400)
dev.off()