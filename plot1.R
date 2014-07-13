# Select your working directory
setwd("C:/Temp")

# Create a folder to save the zip file on it
if (!file.exists("./data")) {dir.create("./data")}
zipUrl= "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile = "./data/data.zip"
download.file (zipUrl, destfile=zipFile, method="auto")

# Unzip the file
unzip (zipFile)

# After that you will have a txt file called household_power_consumption.txt
textFile = "household_power_consumption.txt";
consumptionData = read.csv (textFile,header=F, sep=";");

# Take a look at the first rows of the file
head (consumptionData);

# Assign names to each column
arr_cols <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", 
              "Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

for (i in 1:length(arr_cols)){
  names (consumptionData)[i] <-arr_cols[i]
}

# Load the package
# install.packages("sqldf", repos="http://cran.us.r-project.org", dependencies=TRUE)
library(sqldf)

# We will only be using data from the dates 2007-02-01 and 2007-02-02. One alternative is to read the data from 
# just those dates rather than reading in the entire dataset and subsetting to those dates.
dataFrame<-sqldf("select * from consumptionData where Date = '1/2/2007' or Date = '2/2/2007'") 

# If you make the following sentence, you'll see that there are NA elements on the subset
str(dataFrame)

# So we remove them
aux <-  dataFrame['Global_active_power'][!is.na( dataFrame['Global_active_power'])]

# And now there is no error
str (aux)

# Transform the info into numeric
aux <- sapply(aux, as.numeric)

# So we can make the histogram
hist(aux, col="red", main ="Global Active Power",xlab="Global Active Power (kilowatts)")

# And save it as PNG as asked on the project
dev.copy(png, file="plot1.png")
dev.off()
