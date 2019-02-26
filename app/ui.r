library(shiny)
library(shinydashboard)
library(googleway)
library(dygraphs)
library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggmap)

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
            title = ('citywide KPIs'),
            height = 280,
            ("Total Number of Incidents   "),
            br(),
            (smry_stats01),
            br(),
            ("Average Score:   "),
            br(),
            (smry_stats02)),
          box(
            title = 'top zip codes',
            plotOutput("smry_zip"),
            height = 280)),
        fluidRow(
          box(
            title = 'Grades Over Time',
            plotOutput("smry_trend"),
            height = 280),
          box(
            title = 'Zip Code Incident Frequencies',
            plotOutput("smry_map"),
            height = 280))),
      
      #SEARCH RESTAURANTS#
      tabItem(
        tabName = "search",
        fluidRow(
          box(
            title = 'Select a Borough',
            selectInput(inputId = "boroselected", label = "Select Borough",
                        choices = c("BROOKLYN","QUEENS","BRONX","STATEN ISLAND","MANHATTAN")),
            width = 3),
          box(
            title = 'Select a Cuisine',
            selectInput(inputId = "cuisineselected", label = "Select a Cuisine",
                        choices = c("Thai","Italian","Pizza","French","Pizza/Italian","American","Chinese","Sandwiches/Salads/Mixed Buffet","Latin (Cuban, Dominican, Puerto Rican, South & Central American)",
                                    "Japanese","Jewish/Kosher","Other","Russian","Delicatessen","Spanish","Ice Cream, Gelato, Yogurt, Ices","Bakery","Caribbean","Indian","Hamburgers","Chicken",
                                    "Greek","Korean","CafÃ©/Coffee/Tea","Bottled beverages, including water, sodas, juices, etc.","Irish","Mexican","Juice, Smoothies, Fruit Salads","Middle Eastern","Asian",
                                    "Soul Food","Steak","Sandwiches","Mediterranean","Turkish","Seafood","Vegetarian","Donuts","Peruvian","Filipino","Bangladeshi","Vietnamese/Cambodian/Malaysia","Chinese/Cuban",
                                    "Armenian","Bagels/Pretzels","Barbecue","Tex-Mex","African","Continental","Creole","Eastern European","Chinese/Japanese","Soups & Sandwiches","Southwestern","Chilean",
                                    "German","Pakistani","Polish","Salads","Tapas","Fruits/Vegetables","Scandinavian","Brazilian","Indonesian","Hotdogs","Australian","Czech","Afghan")),
            width = 3),
          box(
            title = "Search A Restaurant",
            textInput(inputId = "rest_name", label= "Text input:")),
            width = 3),
          fluidRow(
            title = 'Map',
            leafletOutput("map"))),
      
      #RESTAURANT SUMMARY#
      tabItem(
        tabName = "summary",
        fluidRow(
          tabsetPanel(
            type = "tabs",
            tabPanel("Number Of Violation", dygraphOutput(outputId = "timetrend1")),
            tabPanel("Category of Violation", plotOutput("cat")),
            tabPanel("Scores", dygraphOutput(outputId = "timetrend2")),
            tabPanel("Streetview", uiOutput(outputId = "street"))
          )
          ))
    )
  )
)