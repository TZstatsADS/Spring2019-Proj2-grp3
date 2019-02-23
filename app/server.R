library(shiny)
library(shinydashboard)
library(googleway)
library(xts)
library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)


server <- function(input,output){

  
#CITY SUMMARY#
output$smry_trend <- 
  renderPlot({city_counts_graph <- (ggplot(smry_trends, aes(x = GRADE.DATE, y = CNT, group = GRADE, color = GRADE)) + 
                geom_line())
              city_counts_graph
              })

#SEARCH RESTAURANTS#
#drive the map of restaurants#
  data <- reactive({x <- df})
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
  output$timetrend1 <- renderDygraph({
    dataxts <- NULL
    #rest <- unique(df1$DBA)
    #rest[1]
    datacounty <- df1[df1$DBA == "MYTHAI CAFE",]
    datacounty <- distinct(datacounty,INSPECTION.YEAR, .keep_all = T)
    
    dd <- xts(datacounty[, "n"],as.Date(paste0(datacounty$INSPECTION.YEAR, "-12-31")))
    dataxts <- cbind(dataxts, dd)
    dygraph(dataxts) %>% dyHighlight(highlightSeriesBackgroundAlpha = 0.2)
  })
  
#drive streetview
<<<<<<< HEAD
  output$street <- renderUI({
    tags$img(src = google_streetview(location = c(streetview$lat, streetview$lon),
                                     size = c(500,500), output = "html",
                                     key = map_key),  width = "500px", height = "500px")
  })
#output$street <- renderGoogle_map({
#  google_map(location = c(streetview$lat, streetview$lon), key = map_key, search_box = T)
#})
=======
output$street <- renderUI({
  tags$img(src = google_streetview(location = c(streetview$lat, streetview$lon), key = map_key, output = "html",size = c(500,500)), width = "500px", height ="500px")
})
>>>>>>> 9a66485ace573c22ac5838c1f68ecb8e6d217418

#time series
library(dygraphs)
output$timetrend2 <- renderDygraph({
  scores <- subset(score,select=c(DBA,INSPECTION.YEAR,INSPECTION.MONTH,score))
  data <- scores[scores$DBA=="ROMA PIZZA",]
  dataxts <- xts(data$score, as.Date(paste0(data$INSPECTION.YEAR,"-",data$INSPECTION.MONTH,"-01")))
  d1<-dygraph(dataxts, main = "SCORES") %>% 
    dySeries("V1", label = "scores") %>%
    dyLegend(show = "follow")
  d1
})


<<<<<<< HEAD

#category of violation
output$cat <- renderPlot({
  data_cat <- df2[df2$DBA==rest[1],] #change
=======


#category of violation
output$cat <- renderPlot({
  data_cat <- df2[df2$DBA=="ROMA PIZZA",] #change

>>>>>>> 9a66485ace573c22ac5838c1f68ecb8e6d217418
  data_cat <- data.frame(data_cat)
  ggplot(data_cat, aes(x=VIOLATION.DESCRIPTION, y=n.cat))+
    geom_bar(stat="identity", col="light green", fill="light green") +
    labs(x="Number of violation", y="Violation Description",  title="Category of Violation") +
    coord_flip() 
})


<<<<<<< HEAD
=======

>>>>>>> 9a66485ace573c22ac5838c1f68ecb8e6d217418
}



<<<<<<< HEAD
=======

>>>>>>> 9a66485ace573c22ac5838c1f68ecb8e6d217418
