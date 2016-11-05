# Data ware house #
# Margot Selosse et Thu Nguyen #
# Just inspecting the data, changing nothing #
list.of.packages <- c("data.table")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.rstudio.com/")
library(data.table)

# http://data.europa.eu/euodp/fr/data/dataset/data_national-emissions-reported-to-the-unfccc-and-to-the-eu-greenhouse-gas-monitoring-mechanism-12
#Margot
#setwd("D:/data-warehouse/")
#Thu
setwd("C:/Users/Hoai Thu Nguyen/Dropbox/DM/BD/Projet")

#### Loading data ####
data <- fread("UNFCCC_V19.csv", sep="\t", stringsAsFactors=T)

#### Format_name ####
levels(data$Format_name)
# Only one levels -> can remove this factor

#### Unit ####
levels(data$Unit)
#[1] "Gg"                "Gg CO2 equivalent"
#  -> can remove this factor

#### Sector_name ####
weird_sectors <- data[grepl("4\\(", data$Sector_name),] #extract the lines with weird sector name
sum(weird_sectors$emissions) # not 0 -> cannot remove
not_zero <- weird_sectors[which(weird_sectors$emissions!=0),]
not_zero$Sector_name <- factor(not_zero$Sector_name) # drop levels that don't exist anymore
not_zero$Pollutant_name <- factor(not_zero$Pollutant_name) 
levels(not_zero$Sector_name) # All weird sectors have non-zero values
levels(not_zero$Pollutant_name)
# number of lines != 0 with weird sector name is ~5000 ~ 1% of the data -> can be considered negligeable
# We can remove all the weird sectors but will have to recalculate the sums in the parent sectors !!!!