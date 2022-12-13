library(shiny)
library(dplyr)
library(leaflet)
library(DT)

#setwd("C:/Users/Master/Desktop/jeju1")

ui <- navbarPage("Location of Charging Station for Electric cars", id="main",
                 tabPanel("Map", leafletOutput("bbmap", height=1000)),
                 tabPanel("Data", DT::dataTableOutput("data")))


server <- shinyServer(function(input, output) {
  
  # Import Data and clean it
  bb_data <- read.csv("jeju_data.csv", stringsAsFactors = FALSE, fileEncoding = "euc-kr" )
  bb_data <- data.frame(bb_data)
  
  bb_data=filter(bb_data, lat != "NA") # removing NA values
  
  # new column for the popup label
  bb_data <- mutate(bb_data, cntnt=paste0(
    '<strong>업체:</strong> ',충전소,
    '<br><strong>요금:</strong> ',요금,
    '<br><strong>운영시간:</strong> ',이용가능시간,
    '<br><strong>타입:</strong> ',타입,
    '<br><strong>충전기 용량:</strong> ',충전기용량,
    '<br><strong>주소:</strong> ',주소)) 
  
  # create a color paletter for category type in the data file
  pal <- colorFactor(pal = c("#1b9e77", "#d95f02"), domain = c("충전소", "AS센터"))
  
  # create the leaflet map  
  output$bbmap <- renderLeaflet({
    leaflet(bb_data) %>% 
      addCircles(lng = ~lon, lat = ~lat) %>% 
      addTiles() %>%
      addCircleMarkers(data = bb_data, lat =  ~lat, lng =~lon, 
                       radius = 7, popup = ~as.character(cntnt), 
                       color = ~pal(분류),
                       stroke = FALSE, fillOpacity = 1)%>%
      addLegend(pal=pal, values=bb_data$분류,opacity=2, na.label = "Not Available")%>%
      addEasyButton(easyButton(
        icon="fa-crosshairs", title="ME",
        onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
  })
  
  #create a data object to display data
  output$data <-DT::renderDataTable(datatable(
    bb_data[,c(-1,-8,-9,-11)],filter = 'top',
    colnames = c("번호", "분류","업체" ,"주소", "이용가능시간", "타입", "충전기용량", "요금")))
  
})

shinyApp(ui, server)


