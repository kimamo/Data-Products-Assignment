
 

library(shiny)
library(leaflet)
library(shinydashboard)
library(htmlwidgets)

# Define UI for application that draws an Interactive Map in leaflet
ui <-
  shinyUI(# dashboardHeader(title = "Data Products Week 2 Assignment : Interactive Map in leaflet "),
    
    fluidPage(# Application title
      titlePanel(
        paste(
          "Data Products Week 2 Assignment : - leaflet Interactive Map showing all cities in state of Georgia, USA   ",
          ".           by :
            Kimamö Wachira . ",
          " date: Dec 3rd  2016  ",
          sep = "\n"
        )
      ),
      
      mainPanel(bootstrapPage(
        div(
          class = "outer",
          tags$style(
            type = "text/css",
            ".outer {position: fixed; top: 120px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"
          ),
          
          leafletOutput("mainPanel", width = "100%", height = "100%" ),
          absolutePanel(
            top = 60,
            right = 10,
            draggable = TRUE 
          )
        )
      ))))


# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  set.seed(12032016)
  
  require(leaflet)
  require(shiny)
  
  output$mainPanel <- renderLeaflet({
    ### add read/load data
    projDir <- getwd()
    filename <- "Georgia Cities.csv"
    
    
    dataDir <-  paste(projDir,"data" , sep = "/")
    csvFilePath <- paste(dataDir, filename, sep = "/")
    
    df <-
      as.data.frame(read.csv(csvFilePath, header = TRUE, colClasses = "character"))
    #head(df)
    names(df) <- tolower(names(df))
    
    
    
    ## create map
    leaflet(data = df, padding = 0) %>%
      addTiles() %>%
      setView(df,
              lng = -84.423142,
              lat = 33.762652,
              zoom = 10) %>%
      addMarkers(
        data = df,
        lat = ~ latitude,
        lng = ~ longitude,
        popup =  ~ location,
        options = markerOptions(draggable = TRUE, riseOnHover = TRUE)
      ) %>%
      
      addCircleMarkers(
        data = df,
        lat = ~ latitude,
        lng = ~ longitude,
        popup =  ~ location ,
        fillColor = "red",
        opacity = 1,
        options = markerOptions(draggable = FALSE, title = "Cities")
      )
    
  })
})

 
# Export as HTML file
#saveWidget(ui, 'mapOfCitiesOfGA.html', selfcontained = FALSE)

# Run the application
 shinyApp(ui = ui, server = server)
