library(shiny)
library(shinydashboard)
library(googleway)
#ls("package:shiny", pattern="Output$")

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
  
#number of violation plot
  output$timetrend <- renderDygraph({
    dataxts <- NULL
    rest <- unique(df1$DBA)
    datacounty <- df1[df1$DBA == rest[1],]
    datacounty <- distinct(datacounty,INSPECTION.YEAR, .keep_all = T)
    
    dd <- xts(datacounty[, "n"],as.Date(paste0(datacounty$INSPECTION.YEAR, "-12-31")))
    dataxts <- cbind(dataxts, dd)
    dygraph(dataxts) %>% dyHighlight(highlightSeriesBackgroundAlpha = 0.2)
  })
  
#drive streetview
output$street <- renderGoogle_map({
  google_map(location = c(streetview$lat, streetview$lon), key = map_key, search_box = T)
})

#category of violation
output$cat <- renderPlot({
  data_cat <- df2[df2$DBA==rest[1],] #?change
  data_cat <- data.frame(data_cat)
  ggplot(data_cat, aes(x=VIOLATION.DESCRIPTION, y=n.cat))+
    geom_bar(stat="identity", col="light green", fill="light green") +
    labs(x="Number of violation", y="Violation Description",  title="Category of Violation") +
    coord_flip() 
})







}