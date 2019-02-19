library(shiny)
library(shinydashboard)
library(googleway)


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








}