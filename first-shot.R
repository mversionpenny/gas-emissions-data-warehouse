# Data ware house #
# Margot Selosse et Thu Nguyen #

# http://data.europa.eu/euodp/fr/data/dataset/data_national-emissions-reported-to-the-unfccc-and-to-the-eu-greenhouse-gas-monitoring-mechanism-12
#Margot
#setwd("D:/data-warehouse/")
#Thu
setwd("C:/Users/Hoai Thu Nguyen/Dropbox/DM/BD/Projet")

#### Loading data ####
data <- read.csv("UNFCCC_V19.csv", sep="\t")
# levels(data$Sector_name)
# levels(data$Sector_code)
# 
# which(typeof(data$Year) != integer)
# levels(data$Notation)

#### Deleting coloumns we are not interested in  : Unit and Format_name ####
data <- data[,- c(4,10)]
colnames(data)

#### Inspecting sector_name
#sector_name <- as.character(data$Sector_name)
for (i in 1:length(levels(data$Sector_name))){
  name = unlist(strsplit(levels(data$Sector_name)[i], split=" - "))
  if (length(name) != 2){
    print(levels(data$Sector_name)[i])
  }
}

#### Deleting sector_code from sector_name ####
sector_name <- sapply(levels(data$Sector_name), function(x) unlist(strsplit(x, split=" - "))[2])
