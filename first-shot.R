# Data ware house #
# Margot Selosse et Thu Nguyen #

# http://data.europa.eu/euodp/fr/data/dataset/data_national-emissions-reported-to-the-unfccc-and-to-the-eu-greenhouse-gas-monitoring-mechanism-12

#### Loading data ####
data <- read.csv("D:/data-warehouse/UNFCCC_V19.csv", sep="\t")
# levels(data$Sector_name)
# levels(data$Sector_code)
# 
# which(typeof(data$Year) != integer)
# levels(data$Notation)

#### Deleting coloumns we are not interested in  : Unit and Format_name ####
data <- data[,- c(4,10)]
colnames(data)

#### Deleting sector_code from sector_name ####
data$Sector_name2 <- sapply()
test2 <- strsplit(test, split="-")
