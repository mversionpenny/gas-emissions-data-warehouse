list.of.packages <- c("data.table","RMySQL")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.rstudio.com/")
library(data.table)
library(RMySQL)


#Margot
#setwd("D:/data-warehouse/")
#Thu
setwd("C:/Users/Hoai Thu Nguyen/Dropbox/DM/BD/Projet")

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

# Insert relation between 2 sector
sectors <- levels(data$Sector_code)
relation_sectors <- data.frame(id_sector1=character(), id_sector2=character(), distance = integer(), stringsAsFactors=F)
line = 1
for (i in 1:length(sectors)){
  s1 = sectors[i]
  print(s1)
  split_s1 <- unlist(strsplit(s1, "[.]"))
  for (j in i:length(sectors)){
    s2 = sectors[j]
    split_s2 <- unlist(strsplit(s2, "[.]"))
    if (length(split_s1) <= length(split_s2)){
      same_branch = T
      for (k in 1: length(split_s1)){
        same_branch = same_branch & (split_s1[k] == split_s2[k])
      }
      if (same_branch){
        relation_sectors[line,] <- c(s1, s2, length(split_s2) - length(split_s1))
        line = line + 1
      }
    }
  }
}

for(i in 1:nrow(relation_sectors)){
    sql <- sprintf( "insert into `h_sector` (`id_sector1`, `id_sector2`, `distance`) values ('%s', '%s', '%s');", relation_sectors$id_sector1[i], relation_sectors$id_sector2[i], relation_sectors$distance[i])
    rs <- dbSendQuery(con, sql)
}