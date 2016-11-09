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

## Remove 3.1
levels(data$Parent_sector_code)[levels(data$Parent_sector_code)=="3.1"] <- "3"
data <- subset(data, Sector_code != "3.1")
data$Sector_code <- factor(data$Sector_code)

#### Remove sector code from Sector_name ####
levels(data$Sector_name)[levels(data$Sector_name)=="- 4(IV)  Indirect N2O Emissions from Managed Soils"] <- "Indirect N2O Emissions from N Mineralization/Immobilization"
sector_names <- levels(data$Sector_name)
for (i in 1:length(sector_names)){
  sector <- sector_names[i]
  name = unlist(strsplit(sector, split="-"))
  if (length(name) == 2){
    levels(data$Sector_name)[levels(data$Sector_name)==sector] <- trimws(name[2])
  }
  if (length(name) < 2){
    if (grepl("4\\(", sector))
      levels(data$Sector_name)[levels(data$Sector_name)==sector] <- trimws(unlist(strsplit(sector, split="\\)"))[2])
  }
  if (length(name) > 2){
    new_name <- paste(trimws(name[2]), '-', trimws(name[3]), sep='')
    levels(data$Sector_name)[levels(data$Sector_name)==sector] <- new_name
  }
}

#### Remove total + all green house gases ####
data <- subset(data, Pollutant_name != "All greenhouse gases - (CO2 equivalent)")
data$Pollutant_name <- factor(data$Pollutant_name)

levels(data$Parent_sector_code)[levels(data$Parent_sector_code)=="Sectors/Totals_incl_incl"] <- ""
data <- subset(data, !grepl("Sector", Sector_code))

#### Creat new big sectors about international activities, bioamss and indirect CO2 ####
levels(data$Sector_code)[levels(data$Sector_code)=="ind_CO2"] <- "7"
levels(data$Parent_sector_code)[levels(data$Parent_sector_code)=="1.D"] <- ""
levels(data$Sector_code)[levels(data$Sector_code)=="1.D.1"] <- "8"
levels(data$Sector_code)[levels(data$Sector_code)=="1.D.1.a"] <- "8.A"
levels(data$Sector_code)[levels(data$Sector_code)=="1.D.1.b"] <- "8.B"
levels(data$Parent_sector_code)[levels(data$Parent_sector_code)=="1.D.1"] <- "8"
levels(data$Sector_code)[levels(data$Sector_code)=="1.D.2"] <- "9"
levels(data$Sector_code)[levels(data$Sector_code)=="1.D.3"] <- "10"

#### Recompute the sum sector 4 and 1 ####
for(i in which(data$Sector_code == "4.F")){
  temp <- subset(data, Country == data$Country[i] & Pollutant_name == data$Pollutant_name[i] & Year == data$Year[i] & Parent_sector_code == "4.F")
  data$emissions[i] <- sum(temp$emissions)  
}
for(i in which(data$Sector_code == "4")){
  temp <- subset(data, Country == data$Country[i] & Pollutant_name == data$Pollutant_name[i] & Year == data$Year[i] & Parent_sector_code == "4")
  data$emissions[i] <- sum(temp$emissions)  
}
for(i in which(data$Sector_code == "1")){
  temp <- subset(data, Country == data$Country[i] & Pollutant_name == data$Pollutant_name[i] & Year == data$Year[i] & Parent_sector_code == "1")
  data$emissions[i] <- sum(temp$emissions)  
}

#### Save cleaned data ####
write.table(data, "clean_data.csv", row.names = F, append = F, sep = ";") 
