library(shiny)
library(shinydashboard)
library(googleway)
library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)

#set working directory and load finaldata#
setwd('C:/Users/mkars/Documents/GitHub/Spring2019-Proj2-grp3/app')
load(file = 'finaldata.RData')


#CITY SUMMARY data processing#
smry_trends <-
  finaldata %>%
  filter(!is.na(GRADE.DATE) & GRADE %in% c('A', 'B', 'C')) %>%
  group_by(GRADE.DATE, GRADE) %>%
  summarise(CNT = n())

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
streetview <- data.frame(lat = 40.7128,
                 long = -74.0060)
map_key <- "AIzaSyBfQD4gSCEB6BJEVlC7gS7jpj-BMIZvCYE"