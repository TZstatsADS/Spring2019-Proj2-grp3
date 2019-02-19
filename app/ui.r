library(shiny)
library(shinydashboard)
library(googleway)
library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)


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
          box(google_mapOutput("street"))))
    )
  )
)