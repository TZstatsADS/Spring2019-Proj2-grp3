library(shiny)
library(shinydashboard)
library(googleway)
library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)
library(mapdata)
library(zipcode)
library(stringr)
library(dygraphs)
library(ggmap)
library(tmap)
library(tmaptools)
library(sf)
library(xts)
library(rsconnect)

#set working directory and load finaldata#
#load restaurant violation data#
load(file = 'finaldata.RData')
finaldata$zip <- str_sub(finaldata$ADDRESSS, start = -5)
finaldata$mmyy <- paste(finaldata$INSPECTION.MONTH,finaldata$INSPECTION.YEAR, sep = "-01-")
#load official zip code record data#
data(zipcode)
zipcode <- zipcode %>% filter(state == 'NY')
#merge zip code with finaldataset#
finaldata <- inner_join(finaldata, zipcode, by = 'zip')


#CITY SUMMARY data processing#
#create data for summary statistics#
smry_stats01 <- nrow(finaldata)
smry_stats02 <- round(mean(!is.na(finaldata$SCORE)),3)
#create data for trend line#
smry_trends <-
  finaldata %>%
  filter(!is.na(GRADE.DATE) & GRADE %in% c('A', 'B', 'C') & 
  INSPECTION.YEAR %in% c(2013,2014,2015,2016)) %>%
  group_by(mmyy, GRADE) %>%
  summarise(CNT = n())
colnames(smry_trends) <- c('date', 'GRADE', 'CNT')
smry_trends$date <- as.Date(smry_trends$date, '%m-%d-%Y')
smry_trends <- as.data.frame(smry_trends)
#create data for zip counts#
smry_scatter <-       
  finaldata %>%
  filter(BORO != 'Missing') %>%
  group_by(BORO) %>%
  summarise(Inspections = n())

#create zip heat map data#
shape <- st_read(dsn = "ZIP_CODE_040114.shp")
smry_map <-       
  finaldata %>%
  filter(!is.na(zip)) %>%
  group_by(zip) %>%
  summarise(InfractionsPerRestaurant = (n() / n_distinct(DBA)))
colnames(smry_map) <- c('ZIPCODE', 'ViolationsPerRestaurant')
smry_map$ZIPCODE <- as.factor(smry_map$ZIPCODE)
shape <- inner_join(shape, smry_map, by = 'ZIPCODE')


#SEARCH RESTAURANTS data processing#
#create data frame to load map#
df <- head(finaldata,5000) %>%
  filter(!is.na(lat) & !is.na(long)) %>%
  filter(BORO != 'Missing') %>%
  filter(as.numeric(lat) > 40.50000 & as.numeric(lat) < 40.86000) %>%
  filter(as.numeric(long) > -74.05000 & as.numeric(long) < -73.85000) %>%
  group_by(DBA, BORO,CUISINE.DESCRIPTION) %>%
  dplyr::summarize(lat = max(as.numeric(lat)),
                   long = max(as.numeric(long)))


#RESTAURANT SUMMARY data processing#

score <-  finaldata %>%
  filter(!is.na(SCORE)) %>%
  group_by(DBA, INSPECTION.YEAR, INSPECTION.MONTH, lat, long) %>%
  summarise(score = mean(SCORE))

## 1. number of violation
#names(finaldata)
df1 <- finaldata %>% group_by(DBA,INSPECTION.YEAR)%>%
  mutate(n=n()) %>% subset(select=c(DBA,BORO,CUISINE.DESCRIPTION,VIOLATION.CODE, lat,long,INSPECTION.YEAR,n))
df1 <- df1%>%filter(!is.null(DBA) & !is.na(DBA))


df1$VIOLATION.CODE <- apply(matrix(as.character(df1$VIOLATION.CODE)),1,
                            function(x) substring(x,1,2))
df1$VIOLATION.CODE <- as.numeric(df1$VIOLATION.CODE)
df1 <- na.omit(df1)

df1$VIOLATION.DESCRIPTION <- NA
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="2")]<- "02-Food Temperature"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="3")]<- "03-Food Source"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="4")]<- "04-Food Protection"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="5")]<- "05-Working Environment Safety"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="6")]<- "06-Workers Cleanliness"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="7")]<- "07-Duties of Officer"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="8")]<- "08-Facility Issues"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="9")]<- "09-Food Storage"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="10")]<- "10-Utility Issues"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="15")]<- "15-Tabacco Issues"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="16")]<- "16-Food Nuitrition/Calories"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="18")]<- "18-Documents Not Present"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="20")]<- "20-Information Not Posted"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="22")]<- "22-Facility Issues 2"
df1$VIOLATION.DESCRIPTION[which(df1$VIOLATION.CODE=="99")]<- "99-Other General Violation"

## 2. violation category
df2 <- df1 %>% group_by(DBA, VIOLATION.CODE,VIOLATION.DESCRIPTION) %>% summarise(n.cat=n())
map_key <- 'insert the google API key'
streetview <- finaldata %>% subset(select=c(DBA, lat, long))%>%distinct()