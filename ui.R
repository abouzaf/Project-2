library(ggplot2)
library(readr)
titanicData <- read_csv("titanic.csv")


shinyUI(fluidPage(
  
  img(src="The-Titanic-006.jpg", align = "right"),
  
  # Application title
  uiOutput("title"),
  
  # Sidebar with options for the data set
  sidebarLayout(
    sidebarPanel(
      h3("Select the survivors class:"),
      selectizeInput("class", "P Class", selected = "1", choices = levels(as.factor(titanicData$pclass))),
      br(),
      sliderInput("size", "Size of Points on Graph",
                  min = 1, max = 10, value = 5, step = 1),
      br(),
      actionButton("savep", "Click to save Plot 2"),
      br(),
      downloadButton("downloadData", "Download Table Data"),
      br(),
      checkboxInput("vline", h4("Add a vertical line the the plot", style = "color:blue;")),
      
    conditionalPanel(condition = "input.vline", 
      numericInput("int",h4("Please choose an intercept between 1 and 80"),
      value = 30, min = 1, max = 80, step = 1)
                     
                     )),
      # Show outputs
  mainPanel(
    
    
    tabsetPanel(
      
      tabPanel("About", textOutput("info")),
      tabPanel("Plot 1", plotOutput("vlinePlot")),
      tabPanel("Plot 2", plotOutput("regPlot")),
      tabPanel("Table", tableOutput("table")),
      tabPanel("Article about Titanic", uiOutput("link"))
    )
  )
  )
))




