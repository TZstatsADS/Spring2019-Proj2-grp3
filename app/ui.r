library(shiny)
library(shinydashboard)
library(googleway)


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
        fluidRow()),
      
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
          box(title = "Number Of Violation",
              dygraphOutput(outputId = "timetrend"), height = 500),
          
          box(title = "Category of Violation",
              plotOutput("cat")),
          
          box(google_mapOutput("street"))
          ))
      
          
    )
  )
)