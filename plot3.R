# add in required library package. 
install.packages("data.table")
require("data.table")

# standard practice of making sure the work environment is clean
# and free from any holdovers from previous sessions. 
rm(list=ls())

if(!file.exists("./workspace"))
{
	dir.create("./workspace")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile="./workspace/household_power_consumption_data.zip")
unzip(zipfile = "./workspace/household_power_consumption_data.zip", exdir="./workspace")

# perform the file read using fread(). 
# Although fread() can read the file, it will start triggering warnings because of the '?'.
# For some reason, the library is not detecting '?' automatically as part of its na.string components. 
# '?' needs to be explicitly specified as an na.string value. 
# The rest of the explicit parameter calls are just for sanity checks.
# Once successful, there should be about 2075259 lines inside the target variable. 

fileContents = fread("./workspace/household_power_consumption.txt", sep=";", header=TRUE, stringsAsFactors=FALSE, dec=".", na.strings="?")

# We then do a data type conversions and data subset in the next lines. 
fileContents$Date <- as.Date(fileContents$Date, format="%d/%m/%Y")
power.df <- subset(fileContents, (fileContents$Date == '2007-02-01' | fileContents$Date == '2007-02-02'))

# This will be evident later. 
power.df$DateTime <- as.POSIXct(paste(power.df$Date, power.df$Time))

# Dealing with the required column conversions. (optional, but executed in the event of not being the case.)
# -- Global_active_power. (Plot 1, Plot 2, Plot 4)
# -- Global_reactive_power. (Plot 4)
# -- Voltage. (Plot 4)
# -- Global_intensity. 
# -- Sub_metering_1. (Plot 3)
# -- Sub_metering_2. (Plot 3)
# -- Sub_metering_3. (Plot 3)

# Performing only data type conversions by plot type. 
power.df$Global_active_power <- as.numeric(power.df$Global_active_power)
power.df$voltage <- as.numeric(power.df$voltage)

power.df$Global_reactive_power <- as.numeric(power.df$Global_reactive_power)
power.df$Global_intensity <- as.numeric(power.df$Global_intensity)

power.df$Sub_metering_1 <- as.numeric(power.df$Sub_metering_1)
power.df$Sub_metering_2 <- as.numeric(power.df$Sub_metering_2)
power.df$Sub_metering_3 <- as.numeric(power.df$Sub_metering_3)


# Now that we have our required data, we plot them using base plotting system (or plot()).
# If needed, these can all be turned into functions. But for the time being, they are left as is. 

# This is for plot 3. 3 overlayed graphs in one chart. 
png(filename = './workspace/plot3.png', width=480, height=480, units = 'px')
plot(power.df$DateTime, power.df$Sub_metering_1, xlab="", ylab='Energy sub-metering', type='l')
	# indentation is mainly just for personal formatting preferences. 
	lines(power.df$DateTime, power.df$Sub_metering_2, col="red")
	lines(power.df$DateTime, power.df$Sub_metering_3, col="blue")
	legend("topright", legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col=c('black', 'red', 'blue'), lwd=1)
dev.off()