library(shiny)
library(leaflet)
library(dplyr)

setwd('C:/Users/mkars/Documents/GitHub/Spring2019-Proj2-grp3/app')
load(file = 'finaldata.RData')
df <- finaldata %>%
        filter(!is.na(lat) & !is.na(long)) %>%
        filter(as.numeric(lat) > 40.60000 & as.numeric(lat) < 40.80000) %>%
        filter(as.numeric(long) > -74.00000 & as.numeric(long) < -73.70000) %>%
        group_by(DBA, BORO) %>%
        summarize(lat = max(as.numeric(lat)),
                  long = max(as.numeric(long)))