library(shiny)
library(shinydashboard)
library(googleway)
<<<<<<< HEAD
library(dygraphs)
=======
library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)

>>>>>>> e316b3677093971e6ba1bf3660ed0e4a6e78a533

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
          dygraphOutput(outputId = "timetrend")))
=======
          box(title = "Number Of Violation",
              dygraphOutput(outputId = "timetrend"), height = 500),
          
          box(title = "Category of Violation",
              plotOutput("cat")),
          
          box(google_mapOutput("street"))
          ))
      
          
>>>>>>> e316b3677093971e6ba1bf3660ed0e4a6e78a533
    )
  )
)