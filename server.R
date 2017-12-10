library(shiny)
library(leaflet)
library(sqldf)
library(dplyr)
library(shinydashboard)
source("source.R")


shinyServer <- function(input, output) {
   
  output$Top5Table <- renderTable({
    
    x <- input$top_5_variable
    xTable <- table(data[, x]) %>% as.data.frame()
    xTable <- xTable[with(xTable, order(-Freq)),] %>% as.data.frame()
    xTable <- subset(xTable, Freq >= 5) %>% 
      setNames(c(x, "Number of Public Art Work"))
  })
  
  output$sayNeighborhoodMap <- renderText({
    name <- input$For_Neighborhood
    paste("The neighborhood you choose:", name)
    
  })
  
  output$MapSummary3 <- renderLeaflet({
    Neighborhood_map <- input$For_Neighborhood
    Neighborhood_map <- subset(data, NEIGHBORHOOD == Neighborhood_map, select = c(lng, lat))
    
    leaflet() %>%
      addTiles() %>% 
      setView(lng = Neighborhood_map[1 , 1], lat = Neighborhood_map[1, 2], zoom = 14) %>%
      addMarkers(lng = Neighborhood_map[, 1], lat = Neighborhood_map[, 2],
                 icon = makeIcon(iconUrl ="treasure2.png",
                                 iconWidth = 40, iconHeight = 40,
                                 iconAnchorX = 20, iconAnchorY = 20))
  })
  
  
  output$sayNeighborhoodTable <- renderText({
    name <- input$For_Neighborhood
    paste("The art information of", name)
    
  })
  
  output$VariableTable3 <- renderTable({
    Neighborhood <- input$For_Neighborhood
    Neighborhood_table <-  filter(data, NEIGHBORHOOD == Neighborhood ) %>%
      select(ARTIST, TITLE, MEDIUM, ART_TYPE) %>%
      arrange(desc(ARTIST), desc(TITLE), desc(MEDIUM), desc(ART_TYPE)) %>%
      as.data.frame()
  })

  
  output$count <- renderText({
    artist <- input$For_Artist
    artist <- subset(data, ARTIST == artist)
    paste("Number of Work:", nrow(artist))
    
  })
  

  output$MapSummary <- renderLeaflet({
    artist_map <- input$For_Artist
    artist_map <- subset(data, ARTIST == artist_map, select = c(lng, lat))
    
    leaflet() %>%
      addTiles() %>% 
      setView(lng = data[1 , 1], lat = data[1, 2], zoom = 11) %>%
      addMarkers(lng = artist_map[, 1], lat = artist_map[, 2],
                 icon = makeIcon(iconUrl ="artist-icon.png",
                                   iconWidth = 40, iconHeight = 40,
                                   iconAnchorX = 20, iconAnchorY = 20))
  })
  
  output$VariableTable <- renderTable({
    artist <- input$For_Artist
    # artist <- subset(data, ARTIST == artist, select = c(ADDRESS, ARTIST,TITLE, MEDIUM,
    #                                                     ART_TYPE, NEIGHBORHOOD))

    artist_table <- select(data, ARTIST, NEIGHBORHOOD) %>%
      filter(ARTIST == artist) %>%
      group_by(ARTIST, NEIGHBORHOOD) %>% 
      summarise(number_of_work = n()) %>% 
      arrange(desc(number_of_work)) %>%
      as.data.frame()
  })
  
  output$VariableTable1_2 <- renderTable({
    artist <- input$For_Artist
    artist_table <- filter(data, ARTIST == artist) %>%
      select(NEIGHBORHOOD, TITLE, ART_TYPE, MEDIUM) %>%
      arrange(desc(NEIGHBORHOOD)) %>%
      as.data.frame()
  })
  
  output$count2 <- renderText({
    artType <- input$For_Art_Type
    artType <- subset(data, ART_TYPE == artType)
    paste("Number of Work:", nrow(artType))
    
  })
  
  output$MapSummary2 <- renderLeaflet({
    artType_map <- input$For_Art_Type
    artType_map <- subset(data, ART_TYPE == artType_map, select = c(lng, lat))
    
    leaflet() %>%
      addTiles() %>% 
      setView(lng = data[1 , 1], lat = data[1, 2], zoom = 11) %>%
      addMarkers(lng = artType_map[, 1], lat = artType_map[, 2],
                 icon = makeIcon(iconUrl ="art-type2.png",
                                 iconWidth = 30, iconHeight = 30,
                                 iconAnchorX = 20, iconAnchorY = 20))
  })
  
  output$VariableTable2 <- renderTable({
    artType <- input$For_Art_Type
    artType_table <- select(data, ART_TYPE, NEIGHBORHOOD) %>%
      filter(ART_TYPE == artType ) %>%
      group_by(ART_TYPE, NEIGHBORHOOD) %>% 
      summarise(number_of_work = n()) %>% 
      arrange(desc(number_of_work)) %>%
      as.data.frame()
  })
  
  output$VariableTable2_2 <- renderTable({
    artType <- input$For_Art_Type
    artType_table <- filter(data, ART_TYPE == artType ) %>%
      select(NEIGHBORHOOD, ARTIST ,TITLE, MEDIUM) %>%
      arrange(desc(NEIGHBORHOOD)) %>%
      as.data.frame()
  })
 
  
  output$for_artist_total <- renderUI({
    if (is.null(input$Artist_for_total_map))
      return()
    
    switch(
      input$Artist_for_total_map,
      "Lize Mogel" = selectInput(inputId = "Art_type_For_total_map", 
                                 label = "Lize Mogel only has works in one art type",
                                 choices = list("Tour"),
                                 selected = "Tour"),
      
      "Wilfredo Valladares" = selectInput(inputId = "Art_type_For_total_map", 
                                          label = "Choose one art type for Wilfredo Valladares",
                                          choices = list("Sculpture", "Mural and Sculpture"),
                                          selected = "Sculpture"),
      
      "Byron Peck" = selectInput(inputId = "Art_type_For_total_map", 
                                          label = "Byron Peck only has works in one art type",
                                          choices = list("Mural"),
                                          selected = "Mural"),
      
      "Words, Beats and Life" = selectInput(inputId = "Art_type_For_total_map", 
                                          label = "Words, Beats and Life only has works in one art type",
                                          choices = list("Mural"),
                                          selected = "Mural"),
      
      "Cheryl Foster" = selectInput(inputId = "Art_type_For_total_map", 
                                          label = "Choose one art type for Cheryl Foster",
                                          choices = list("Mural", "Sculpture", "Mosaic mural"),
                                          selected = "Mural"),
      
      "Floating Lab Collective" = selectInput(inputId = "Art_type_For_total_map", 
                                              label = "Floating Lab Collective only has works in one art type",
                                              choices = list("Lecture"),
                                              selected = "Lecture"),
      
      "Walter Kravitz" = selectInput(inputId = "Art_type_For_total_map", 
                                     label = "Choose one art type for Cheryl Foster",
                                     choices = list("Mural, glass", "Sculpture", 
                                                    "Suspended", "Suspended installation",
                                                    "Sculpture, suspended"),
                                     selected = "Mural, glass")
    )
  })

  output$count5 <- renderText({
    artist <- input$Artist_for_total_map
    art_type <- input$Art_type_For_total_map
    artistaaa <- filter(data, ARTIST == artist, ART_TYPE == art_type)
    paste("Number of Work:", nrow(artistaaa))
    
  })
  
  
  output$MapSummary5 <- renderLeaflet({
    artist_total_map <- input$Artist_for_total_map
    artType_total_map <- input$Art_type_For_total_map
    total_map <- subset(data, ARTIST == artist_total_map &
                        ART_TYPE == artType_total_map, select = c(lng, lat))
    
    leaflet() %>%
      addTiles() %>% 
      setView(lng = data[1 , 1], lat = data[1, 2], zoom = 11) %>%
      addMarkers(lng = total_map[, 1], lat = total_map[, 2],
                 icon = makeIcon(iconUrl ="total.png",
                                 iconWidth = 30, iconHeight = 30,
                                 iconAnchorX = 20, iconAnchorY = 20))
  })
  
  output$VariableTable5 <- renderTable({
    artist_total_map <- input$Artist_for_total_map
    artType_total_map <- input$Art_type_For_total_map
    
    totalMap_table <- filter(data, ARTIST == artist_total_map, 
                             ART_TYPE == artType_total_map) %>%
      select(ARTIST, ART_TYPE, TITLE, MEDIUM, NEIGHBORHOOD) %>%
      arrange(desc(NEIGHBORHOOD)) %>%
      as.data.frame()
  })
}
