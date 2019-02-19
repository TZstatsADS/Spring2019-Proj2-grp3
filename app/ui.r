library(shiny)

# Define UI for inspector dashboard application
ui <- fluidPage(
  leafletOutput("mymap",height = 1000)
)