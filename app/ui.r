#Define UI for inspector dashboard application#
ui <- 
dashboardPage(
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
            width = 12,
            title = ('New York City Restaurant Inspector Dashboard'),
            "This series of dashboards summarizes and visualizes NYC restaurant inspection data from 2013-2016.
            These dashboards are primarily designed for restaurant inspectors to better analyze their business, 
            but could be used by consumers to look for the cleanest of restaurants. The first two dashboards
            examine the entire city, while the final two dashboards analyze a particular restaurant in question.",
            (smry_stats01), 
            "insepections are included in this report.",
            height = "20vh")),
        fluidRow(
          column(width = 5,
              fluidRow(column(12,
               box(
                width = 12,
                title = 'Inspections per Borough',
                plotOutput("smry_scatter", height = '22vh'),
                height = "30vh"))),
              fluidRow(column(12,
                box(
                  width = 12,
                  title = 'Grades Over Time',
                  plotOutput("smry_trend", height = '22vh'),
                  height = "30vh")))),
          column(width = 7,
              box(
                  title = 'Avg. # Violations per Restaurant (by Zip Code)',
                  width = 12,
                  leafletOutput("zip_infractions", height = "56vh"))))),
      #SEARCH RESTAURANTS#
      tabItem(
        tabName = "search",
        fluidRow(
          height = '20vh',
          box(
            selectInput(inputId = "boroselected", label = "Select Borough",
                        choices = c("BROOKLYN","QUEENS","BRONX","STATEN ISLAND","MANHATTAN")),
            width = 3),
          box(
            selectInput(inputId = "cuisineselected", label = "Select a Cuisine",
                        choices = c("Thai","Italian","Pizza","French","Pizza/Italian","American","Chinese","Sandwiches/Salads/Mixed Buffet","Latin (Cuban, Dominican, Puerto Rican, South & Central American)",
                                    "Japanese","Jewish/Kosher","Other","Russian","Delicatessen","Spanish","Ice Cream, Gelato, Yogurt, Ices","Bakery","Caribbean","Indian","Hamburgers","Chicken",
                                    "Greek","Korean","CafÃ©/Coffee/Tea","Bottled beverages, including water, sodas, juices, etc.","Irish","Mexican","Juice, Smoothies, Fruit Salads","Middle Eastern","Asian",
                                    "Soul Food","Steak","Sandwiches","Mediterranean","Turkish","Seafood","Vegetarian","Donuts","Peruvian","Filipino","Bangladeshi","Vietnamese/Cambodian/Malaysia","Chinese/Cuban",
                                    "Armenian","Bagels/Pretzels","Barbecue","Tex-Mex","African","Continental","Creole","Eastern European","Chinese/Japanese","Soups & Sandwiches","Southwestern","Chilean",
                                    "German","Pakistani","Polish","Salads","Tapas","Fruits/Vegetables","Scandinavian","Brazilian","Indonesian","Hotdogs","Australian","Czech","Afghan")),
            width = 3),
          box(
            textInput(inputId = "rest_name", label= "Select a Restaurant")),
          width = 3),
        fluidRow(
          box(
          width = 12,
          height = '75vh',
          title = 'Selected Restaurants',
          leafletOutput("map", height = '65vh')))),

        #RESTAURANT SUMMARY#
      tabItem(
        tabName = 'summary',
      tabsetPanel(
        type = "tabs",
        tabPanel("Number Of Violation", dygraphOutput(outputId = "timetrend1")),
        tabPanel("Category of Violation", plotOutput("cat")),
        tabPanel("Scores", dygraphOutput(outputId = "timetrend2")),
        tabPanel("Streetview", uiOutput(outputId = "street")))))
))