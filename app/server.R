library(shiny)
library(shinydashboard)
library(googleway)
library(xts)
library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggmap)

server <- function(input,output){

  
#CITY SUMMARY#
  #CITY SUMMARY#
  output$smry_stats01 <- renderText({smry_stats01})
  output$smry_stats02 <- renderText({smry_stats02})
  
  output$smry_trend <- 
    renderPlot({(ggplot(smry_trends, aes(x = GRADE.DATE, y = CNT, group = GRADE, color = GRADE)) + 
                   geom_line() +
                   xlab('Date of Assessment') +
                   ylab('Number of Assessments'))}, height = 220)
  
  output$smry_zip <-
    renderPlot({(ggplot(smry_zips, aes(x = reorder(zip, -cnt), cnt)) +
                   geom_col(show.legend = FALSE) + 
                   xlab('Zip Code') +
                   ylab('Number of Incidents'))}, height = 220)
  
  output$smry_map <- 
    renderPlot({ggmap(map) +
        geom_point(aes(x=longitude, y=latitude, size=(cnt)), data = smry_maps, alpha=.5) + 
        theme(axis.title.x=element_blank(),
              axis.text.x=element_blank(),
              axis.ticks.x=element_blank(),
              axis.title.y=element_blank(),
              axis.text.y=element_blank(),
              axis.ticks.y=element_blank(),
              legend.title = element_blank(),
              legend.position = "none")}
        , height = 220)

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
                               "long", df$long,
                               "CUISINE.DESCRIPTION",finaldata))
    m
    
  })
  
  #filter data by boros
  datafiltered <- reactive({
    df[which(df$BORO == input$boroselected), ] # Filter by boro
    
  })
  
  ## respond to the filtered data
  observe({
    
    leafletProxy(mapId = "map", data = datafiltered()) %>%
      clearMarkers() %>%   ## clear previous markers
      addMarkers(lng = ~as.numeric(long),
                 lat = ~as.numeric(lat),
                 popup = paste("Restaurant Name:", df$DBA,
                               "BORO", df$BORO,
                               "lat", df$lat,
                               "long", df$long))
  })
  
  
  #filter data by cuisine
  datafiltered_c <- reactive({
    df[which(df$CUISINE.DESCRIPTION == input$cuisineselected), ] # Filter by cuisine
    
  })
  
  ## respond to the filtered data
  observe({
    
    leafletProxy(mapId = "map", data = datafiltered_c()) %>%
      clearMarkers() %>%   ## clear previous markers
      addMarkers(lng = ~as.numeric(long),
                 lat = ~as.numeric(lat),
                 popup = paste("DBA", df$DBA,
                               "BORO", df$BORO,
                               "lat", df$lat,
                               "long", df$long))
  })

  
#RESTAURANT SUMMARY#
  output$value <- renderPrint({input$rest_name})
#number of violation plot
  output$timetrend1 <- renderDygraph({
    dataxts <- NULL
    #rest <- unique(df1$DBA)
    #rest[1]
    datacounty <- df1[df1$DBA == input$rest_name,]
    datacounty <- distinct(datacounty,INSPECTION.YEAR, .keep_all = T)
    
    dd <- xts(datacounty[, "n"],as.Date(paste0(datacounty$INSPECTION.YEAR, "-12-31")))
    dataxts <- cbind(dataxts, dd)
    dygraph(dataxts) %>% dyHighlight(highlightSeriesBackgroundAlpha = 0.2)
  })
  
#drive streetview
  output$street <- renderUI({
    rest_str_view <- as.numeric(unlist(streetview[streetview$DBA==input$rest_name,]))[-1]
    tags$img(src = google_streetview(location = c(rest_str_view[1], rest_str_view[2]),
                                     size = c(500,500), output = "html",
                                     key = map_key),  width = "500px", height = "500px")
  })
#output$street <- renderGoogle_map({
#  google_map(location = c(streetview$lat, streetview$lon), key = map_key, search_box = T)
#})

#time series
library(dygraphs)
output$timetrend2 <- renderDygraph({
  scores <- subset(score,select=c(DBA,INSPECTION.YEAR,INSPECTION.MONTH,score))
  data <- scores[scores$DBA==input$rest_name,]
  dataxts <- xts(data$score, as.Date(paste0(data$INSPECTION.YEAR,"-",data$INSPECTION.MONTH,"-01")))
  d1<-dygraph(dataxts, main = "SCORES") %>% 
    dySeries("V1", label = "scores") %>%
    dyLegend(show = "follow")
  d1
})



#category of violation
output$cat <- renderPlot({
  data_cat <- df2[df2$DBA==input$rest_name,]
  data_cat <- data.frame(data_cat)
  ggplot(data_cat, aes(x=VIOLATION.DESCRIPTION, y=n.cat))+
    geom_bar(stat="identity", col="light green", fill="light green") +
    labs(x="Number of violation", y="Violation Description",  title="Category of Violation") +
    coord_flip() 
})


}


