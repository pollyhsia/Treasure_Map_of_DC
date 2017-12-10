library(shiny)
library(leaflet)
library(shinydashboard)


header <- dashboardHeader(
  title = "Treasure Map of DC"
)


body <- dashboardBody(
  fluidRow(
    column(4,
           wellPanel(
             selectInput(inputId = "top_5_variable", 
                         label = "Table for at least 5 ",
                         choices = list("ARTIST", 
                                        "ART_TYPE",
                                        "NEIGHBORHOOD",
                                        "MEDIUM"),
                         selected = "NEIGHBORHOOD"),
             
             radioButtons("For_Neighborhood",
                          label = "Choose one of 'at least 5' Neighborhood to show on the map",
                          choices = list("Anacostia",
                                         "shaw",
                                         "Downtown",
                                         "columbia heights",
                                         "Southwest Waterfront",
                                         "columbia heights",
                                         "old city",
                                         "dupont circle",
                                         "saint elizabeth's",
                                         "Capitol Hill",
                                         "congress heights",
                                         "adams morgan"),
                          selected = "Anacostia")
           ),
           
           wellPanel(
             selectInput(inputId = "For_Artist", 
                         label = "Artist Map -- Choose one of 'at least 5' Artist",
                         choices = list("Lize Mogel", 
                                        "Wilfredo Valladares",
                                        "Byron Peck",
                                        "Words, Beats and Life",
                                        "Cheryl Foster",
                                        "Floating Lab Collective",
                                        "Walter Kravitz"),
                         selected = "Lize Mogel")
           ),
           
           wellPanel(
             selectInput(inputId = "For_Art_Type", 
                         label = "Art Type Map -- Choose one of 'at least 5' Art Type",
                         choices = list("Mural", 
                                        "Sculpture",
                                        "Installation",
                                        "Tour",
                                        "Sculpture, Installation",
                                        "Performance",
                                        "Lecture"),
                         selected = "Sculpture")
           ),
           
           
           
           wellPanel(
             radioButtons(inputId = "Artist_for_total_map",
                          label = "Total Map -- Choose your 'at least 5' Artist",
                          choices = list("Lize Mogel",
                                         "Wilfredo Valladares",
                                         "Byron Peck",
                                         "Words, Beats and Life",
                                         "Cheryl Foster",
                                         "Floating Lab Collective",
                                         "Walter Kravitz"),
                          selected = "Byron Peck"),
             
             uiOutput("for_artist_total")
           )
           
    ),
    
    column(8,
           tabsetPanel(
             tabPanel(title = "Table for at least 5", tableOutput("Top5Table"), 
                      h2(textOutput(outputId = "sayNeighborhoodMap")), 
                      leafletOutput(outputId = "MapSummary3"),
                      h2(textOutput(outputId = "sayNeighborhoodTable")),
                      tableOutput("VariableTable3")),
             
             tabPanel(title = "Artist Map", h2(textOutput(outputId = "count")), 
                      leafletOutput(outputId = "MapSummary"), 
                      tableOutput("VariableTable"), tableOutput("VariableTable1_2")),
             
             tabPanel(title = "Art Type Map", h2(textOutput(outputId = "count2")), 
                      leafletOutput(outputId = "MapSummary2"), 
                      tableOutput("VariableTable2"), tableOutput("VariableTable2_2")),
             
             
             tabPanel(title = "Total Map", h2(textOutput(outputId = "count5")), 
                      leafletOutput(outputId = "MapSummary5"), 
                      tableOutput("VariableTable5")) 
           )
           
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)