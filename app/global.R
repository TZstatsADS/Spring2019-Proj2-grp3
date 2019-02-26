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

#set working directory and load finaldata#
setwd('/Users/apple/Documents/GitHub/Spring2019-Proj2-grp3/Spring2019-Proj2-grp3/app')
#load restaurant violation data#
load(file = 'finaldata.RData')
finaldata$zip <- str_sub(finaldata$ADDRESSS, start = -5)
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
  filter(!is.na(GRADE.DATE) & GRADE %in% c('A', 'B', 'C')) %>%
  group_by(GRADE.DATE, GRADE) %>%
  summarise(CNT = n())
#create data for zip counts#
smry_zips <-       
  finaldata %>%
  filter(!is.na(zip)) %>%
  group_by(zip) %>%
  summarise(cnt = n()) %>%
  top_n(10, cnt)
#create data for summary map#
smry_maps <- 
  finaldata %>%
  filter(!is.na(zip)) %>%
  group_by(zip, latitude, longitude) %>%
  summarise(cnt = n())
register_google('AIzaSyBfQD4gSCEB6BJEVlC7gS7jpj-BMIZvCYE')
map <- get_googlemap(location= c(lon = 40.7128, lat = -74.0060), zoom = 9)

#SEARCH RESTAURANTS data processing#
#create data frame to load map#

df <- finaldata %>%
  filter(!is.na(lat) & !is.na(long)) %>%
  filter(as.numeric(lat) > 40.60000 & as.numeric(lat) < 40.80000) %>%
  filter(as.numeric(long) > -74.00000 & as.numeric(long) < -73.70000) %>%
  group_by(DBA, BORO,CUISINE.DESCRIPTION) %>%
  dplyr::summarize(lat = max(as.numeric(lat)),
                   long = max(as.numeric(long)))

#RESTAURANT SUMMARY data processing#
#create streetview#

streetview <- data.frame(lat = -37.817714,
                 long = 144.967260,
                 info = "Flinders Street Station")
map_key <- "AIzaSyBfQD4gSCEB6BJEVlC7gS7jpj-BMIZvCYE"


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

streetview <- finaldata %>% subset(select=c(DBA, lat, long))%>%distinct()

map_key <- "AIzaSyBfQD4gSCEB6BJEVlC7gS7jpj-BMIZvCYE"

