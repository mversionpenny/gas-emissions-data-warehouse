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

#### Deleting coloumns we are not interested in  : Unit and Format_name ####
data <- data[,c(4, 10, 11):=NULL]
colnames(data)

#### Delete years before 1990 ####
data <- subset(data, Year != '1985-1987')
data$Year <- as.numeric(levels(data$Year))[data$Year]
data <- subset(data, Year >= 1990)

#### Reorganize Sector_code ####
## Replace 1.AA by 1.A
levels(data$Sector_code)[levels(data$Sector_code)=="1.AA"] <- "1.A"
levels(data$Parent_sector_code)[levels(data$Parent_sector_code)=="1.AA"] <- "1.A"

## Replace the bad Sector_code of sector 4
levels(data$Sector_code)[levels(data$Sector_code)=="4.A Emissions/Removal"] <- "4.A.3"
levels(data$Sector_code)[levels(data$Sector_code)=="4.B Emissions/Removal"] <- "4.B.3"
levels(data$Sector_code)[levels(data$Sector_code)=="4.C Emissions/Removal"] <- "4.C.3"
levels(data$Sector_code)[levels(data$Sector_code)=="4.D Emissions/Removal"] <- "4.D.3"
levels(data$Sector_code)[levels(data$Sector_code)=="4.E Biomass Burning"] <- "4.E.3"
levels(data$Sector_code)[levels(data$Sector_code)=="-"] <- "4.F.1"
data$Parent_sector_code[which(data$Sector_code=="4.F.1")] <- "4.F"

## Replace the bad Sector_code of sector 3
levels(data$Parent_sector_code)[levels(data$Parent_sector_code)=="3.1"] <- "3"
data <- subset(data, Sector_code != "3.1")
data$Sector_code <- factor(data$Sector_code)

#### Inspecting sector_name ####
#sector_name <- as.character(data$Sector_name)
for (i in 1:length(levels(data$Sector_name))){
  name = unlist(strsplit(levels(data$Sector_name)[i], split=" - "))
  if (length(name) != 2){
    print(levels(data$Sector_name)[i])
  }
}

#### Deleting sector_code from sector_name ####
sector_name <- sapply(levels(data$Sector_name), function(x) unlist(strsplit(x, split=" - "))[2])
le
