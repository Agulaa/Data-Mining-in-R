library(shiny)
library(ECharts2Shiny)

shinyServer(
  pageWithSidebar(
    headerPanel("Titanic"),
    
    sidebarPanel(
      textInput("firstname", "First Name"),
      textInput("lastname", "Last Name"),
      numericInput("age", "Age:", 45, min = 0, max = 100),
      selectInput("sex", "Sex",
                  choices = c("female", "male")),
      selectInput("class", "Passenger Class",
                  choices = c(1, 2, 3)),
      actionButton("submit", "Submit")
    ),
    
    
    
    mainPanel(
      headerPanel("Will you survive?"),
      
      fluidPage(
        loadEChartsLibrary(),
        
        tags$div(id="plot", style="padding-left:10px;height:400px;"),
        deliverChart(div_id = "plot")
      )
      

    )
  )
)