read_epc <- function(){
    #specifically reads the household_power_consumption.txt dataset.
    compressed_file <- 'epc.zip'
    data_file <- 'household_power_consumption.txt'
    if(!file.exists(compressed_file)) {
        print("downloading the file")
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url, compressed_file, method = "curl")
    }
    if(!file.exists(data_file)) {
        print("uncompressing the file")
        unzip(compressed_file)
    }
    print("reading the file")
    df <- read.table(data_file, header = TRUE, sep = ';', 
                     colClasses = c('factor', 'factor', 'numeric', 'numeric', 'numeric', 
                                    'numeric', 'numeric', 'numeric', 'numeric'),
                     na.strings = "?")
    df$Date <- as.Date(df$Date, format('%d/%m/%Y'))
    interesting_dates <- as.Date(c('2007-02-01', '2007-02-02'), format('%Y-%m-%d'))
    df$datetime <- with(df, as.POSIXct(paste(Date, Time), format="%Y-%m-%d %H:%M:%S"))
    return(df[df$Date %in% interesting_dates,])
    
}

epc <- read_epc()
png(width = 480, height = 480, file = "plot3.png")

with(epc, {
    plot(datetime, Sub_metering_1, type = 'l', ylab = "Energy sub metering")
    lines(datetime, Sub_metering_2, col = 'red')
    lines(datetime, Sub_metering_3, col = 'blue')
    legend('topright', c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
           col = c('black', 'red', 'blue'), lty = 1)
    
})
dev.off()


