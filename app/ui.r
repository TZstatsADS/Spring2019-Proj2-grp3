library(shiny)
library(shinydashboard)
library(googleway)
library(dygraphs)
library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)

<<<<<<< HEAD

=======
>>>>>>> edfeea97dabb4cb9ab78c6dc5a51d719b234d066

#Define UI for inspector dashboard application#
ui <- dashboardPage(
  dashboardHeader(title = "Inspector Dashboard"),
  #add sidebar menu options#
  dashboardSidebar(
    sidebarMenu(
      menuItem("City Summary", tabName = "city", icon = icon("dashboard")),
      menuItem("Search Restaurants", tabName = "search", icon = icon("dashboard")),
      menuItem("Restaurant Summary", tabName = "summary", icon = icon("th")))),
  
  #content of body#
  dashboardBody(
    tabItems(
      #CITY SUMMARY#
      tabItem(
        tabName = "city",
        fluidRow(
          box(
            title = 'Grades Over Time',
            plotOutput("smry_trend")))),
      
      #SEARCH RESTAURANTS#
      tabItem(
        tabName = "search",
        fluidRow(
          box(
              title = 'Select a Restaurant',
              leafletOutput("map")))),
      
      #RESTAURANT SUMMARY#
      tabItem(
        tabName = "summary",
        fluidRow(
<<<<<<< HEAD
=======

          

>>>>>>> edfeea97dabb4cb9ab78c6dc5a51d719b234d066
          box(title = "Number Of Violation",
              dygraphOutput(outputId = "timetrend1"), height = 500),
          box(title = "Category of Violation",
<<<<<<< HEAD
              plotOutput("cat"), height = 500),
          box(dygraphOutput(outputId = "timetrend2"), height = 500),
          box(uiOutput(outputId = "street"),height = 500)
          ))
      
          
      
          
>>>>>>> edfeea97dabb4cb9ab78c6dc5a51d719b234d066
    )
  )
)