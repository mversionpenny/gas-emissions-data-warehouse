list.of.packages <- c("data.table","RMySQL")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.rstudio.com/")
library(data.table)
library(RMySQL)


#Margot
setwd("D:/data-warehouse/")
#Thu
#setwd("C:/Users/Hoai Thu Nguyen/Dropbox/DM/BD/Projet")

####
data <- fread("clean_data.csv", sep=";", stringsAsFactors=T)

#### Connection to Database ####
# install.packages("RMySQL")

con <- dbConnect(MySQL(), user="root", password="",dbname="gas-emissions", host="localhost")
#rs <- dbSendQuery(con, "select * from h_year")

#### Insert values in Database ####
# Insert countries
codes <- levels(data$Country_code)
names <- rep("",length(codes))
levels <- levels(data$Country)
for(i in 1:length(codes)){
  temp <- subset(data, Country_code == codes[i])
  names[i] <- levels[temp$Country[1]]
}

for(j in 1:length(codes)){
  sql <-sprintf( "insert into `h_country` (`id_country`, `name`) values ('%s', '%s');", codes[j], names[j])
  rs <- dbSendQuery(con, sql)
}

# Insert sectors
codes <- levels(data$Sector_code)
names <- rep("",length(codes))
parents <- rep("", length(codes))
levelsNames <- levels(data$Sector_name)
levelsParents <- levels(data$Parent_sector_code)
for(i in 1:length(codes)){
  temp <- subset(data, Sector_code == codes[i])
  names[i] <- levelsNames[temp$Sector_name[1]]
  parents[i] <- levelsParents[temp$Parent_sector_code[1]]
  
}


for(j in 1:length(codes)){
  sql <- sprintf( "insert into `h_sector` (`id_sector`, `name`) values ('%s', '%s');", codes[j], names[j])
  rs <- dbSendQuery(con, sql)
}


for(j in 1:length(codes)){
  if(parents[j] != ""){
    sql <- sprintf( "update `gas-emissions`.`h_sector` SET `id_parent`='%s' where `id_sector`='%s';",parents[j], codes[j])
    rs <- dbSendQuery(con, sql)
  }
}

# Insert sectors
for(k in 1:nrow(data)){
  sql <- sprintf( "insert into `fact_emission` (`quantity`, `id_sector`, `id_country`, `id_gas`, `id_year` ) values ('%f', '%s', '%s', '%s','%d');", data$emissions[k], data$Sector_code[k], data$Country_code[k], substr(data$Pollutant_name[k],1,3), data$Year[k])
  rs <- dbSendQuery(con, sql)
}

