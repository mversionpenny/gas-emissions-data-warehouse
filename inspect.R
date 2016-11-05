# Data ware house #
# Margot Selosse et Thu Nguyen #
# Just inspecting the data, changing nothing #

# http://data.europa.eu/euodp/fr/data/dataset/data_national-emissions-reported-to-the-unfccc-and-to-the-eu-greenhouse-gas-monitoring-mechanism-12
#Margot
#setwd("D:/data-warehouse/")
#Thu
setwd("C:/Users/Hoai Thu Nguyen/Dropbox/DM/BD/Projet")

#### Loading data ####
data <- read.csv("UNFCCC_V19.csv", sep="\t")

#### Format_name ####
levels(data$Format_name)
# Only one levels -> can remove this factor

#### Unit ####
levels(data$Unit)
# Only one levels -> can remove this factor

#### Sector_name ####
weird_sectors <- data[grepl("4\\(", data$Sector_name),] #extract the lines with weird sector name
sum(weird_sectors$emissions) # not 0 -> cannot remove
not_zero <- weird_sectors[which(weird_sectors$emissions!=0),]
not_zero$Sector_name <- factor(not_zero$Sector_name) # drop levels that don't exist anymore
not_zero$Pollutant_name <- factor(not_zero$Pollutant_name) 
levels(not_zero$Sector_name) # All weird sectors have non-zero values
levels(not_zero$Pollutant_name)
# Only CH4, CO2, N2O ==> Not coherent at all because normally, the "All greenhouse gas" is the sum of all the gas
# if one of the gas != 0, the "All green house gas" mustnot be 0 
# number of lines != 0 with weird sector name is 2000 ~ 1% of the data -> can be considered negligeable
# We can remove all the weird sectors but will have to recalculate the sums in the parent sectors !!!!