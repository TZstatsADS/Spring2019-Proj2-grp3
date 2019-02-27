server <- function(input,output){

#CITY SUMMARY#
  output$smry_stats01 <- renderText({smry_stats01})
  output$smry_stats02 <- renderText({smry_stats02})
  
  output$smry_trend <- 
    renderPlot({(ggplot(smry_trends, aes(x = date, y = CNT, group = GRADE, color = GRADE)) + 
                   geom_line(size = 2) +
                   xlab('Month/Year') +
                   ylab('Number of Assessments'))})
  
  output$smry_scatter <-
    renderPlot({(ggplot(smry_scatter, aes(x = BORO, y = Inspections)) +
                   geom_bar(stat = 'identity'))})
  
  output$zip_infractions <- 
    renderLeaflet({tm <- tm_shape(shape) +
                         tm_polygons('ViolationsPerRestaurant', id = 'ZIPCODE')
                         tmap_mode("view")
                         tmap_last()
            tmap_leaflet(tm)})

  #SEARCH RESTAURANTS#
  #drive the map of restaurants#
  data <- reactive({x <- df})
  output$map <- renderLeaflet({
    df <- data()
    
    m <- leaflet(data = df) %>%
      addTiles() %>%
      addMarkers(lng = ~as.numeric(long),
                 lat = ~as.numeric(lat),
                 popup = paste("Restaurant Name: ", df$DBA,
                               "<br>",
                               "Borough: ", df$BORO,
                               "<br>",
                               "Cuisine Type: ",df$CUISINE.DESCRIPTION))
    m
    
  })
  
  #filter data by boros and cuisine
  datafiltered <- reactive({
    df[which(df$BORO == input$boroselected & df$CUISINE.DESCRIPTION == input$cuisineselected), ] # Filter by boro
    
  })
  
  ## respond to the filtered data
  observe({
    
    leafletProxy(mapId = "map", data = datafiltered()) %>%
      clearMarkers() %>%   ## clear previous markers
      addMarkers(lng = ~as.numeric(long),
                 lat = ~as.numeric(lat),
                 popup = paste("Restaurant Name: ", datafiltered()$DBA,
                               "<br>",
                               "Borough: ", datafiltered()$BORO,
                               "<br>",
                               "Cuisine Type: ", datafiltered()$CUISINE.DESCRIPTION))
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
                                     size = c(600,600), output = "html",
                                     key = map_key),  width = 600, height = 600)
  })
  #output$street <- renderGoogle_map({
  #  google_map(location = c(streetview$lat, streetview$lon), key = map_key, search_box = T)
  #})
  
  #time series
  output$timetrend2 <- renderDygraph({
    scores <- subset(score,select=c(DBA,INSPECTION.YEAR,INSPECTION.MONTH,score))
    data <- scores[scores$DBA==input$rest_name,]
    dataxts <- xts(data$score, as.Date(paste0(data$INSPECTION.YEAR,"-",data$INSPECTION.MONTH,"-01")))
    d1<-dygraph(dataxts, main = "SCORES") %>% 
      dySeries("V1", label = "scores")
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