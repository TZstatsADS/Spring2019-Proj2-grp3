library(shiny)
library(leaflet)
library(dplyr)

#set working directory and load finaldata#
setwd('C:/Users/lenovo/Documents/GitHub/Spring2019-Proj2-grp3/app')
load(file = 'finaldata.RData')


#CITY SUMMARY data processing#


#SEARCH RESTAURANTS data processing#
#create data frame to load map#
df <- finaldata %>%
        filter(!is.na(lat) & !is.na(long)) %>%
        filter(as.numeric(lat) > 40.60000 & as.numeric(lat) < 40.80000) %>%
        filter(as.numeric(long) > -74.00000 & as.numeric(long) < -73.70000) %>%
        group_by(DBA, BORO) %>%
        summarize(lat = max(as.numeric(lat)),
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


