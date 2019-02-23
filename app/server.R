library(shiny)
library(shinydashboard)
library(googleway)
library(xts)


server <- function(input,output, session){

  
#CITY SUMMARY#
  
  
#SEARCH RESTAURANTS#
#drive the map of restaurants#
  data <- reactive({
    x <- df
  })
  output$map <- renderLeaflet({
    df <- data()
    
    m <- leaflet(data = df) %>%
      addTiles() %>%
      addMarkers(lng = ~as.numeric(long),
                 lat = ~as.numeric(lat),
                 popup = paste("DBA", df$DBA,
                               "BORO", df$BORO,
                               "lat", df$lat,
                               "long", df$long))
    m
  })

  
#RESTAURANT SUMMARY#
#drive streetview
output$street <- renderGoogle_map({
  google_map(location = c(streetview$lat, streetview$lon), key = map_key, search_box = T)
})
#time series
library(dygraphs)
output$timetrend <- renderDygraph({
  scores <- subset(score,select=c(DBA,INSPECTION.YEAR,INSPECTION.MONTH,score))
  data <- scores[scores$DBA=="ROMA PIZZA",]
  dataxts <- xts(data$score, as.Date(paste0(data$INSPECTION.YEAR,"-",data$INSPECTION.MONTH,"-01")))
 # d1 <- dygraph(dataxts) %>% dyHighlight(highlightSeriesBackgroundAlpha = 0.2)
  d1<-dygraph(dataxts, main = "SCORES") %>% 
    dySeries("V1", label = "scores") %>%
    dyLegend(show = "follow")
  d1
})







}