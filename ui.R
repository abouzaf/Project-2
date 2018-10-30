library(ggplot2)
library(readr)
titanicData <- read_csv("titanic.csv")

shinyUI(fluidPage(
  
  # Application title
  #titlePanel("Investigation of Mammal Sleep Data"),
  uiOutput("title"),
  
  # Sidebar with options for the data set
  sidebarLayout(
    sidebarPanel(
      h3("Select the survivors class:"),
      selectizeInput("class", "P Class", selected = "1", choices = levels(as.factor(titanicData$pclass))),
      br(),
      sliderInput("size", "Size of Points on Graph",
                  min = 1, max = 10, value = 5, step = 1),
      checkboxInput("vline", h4("Add a vertical line the the plot", style = "color:blue;")),
      
    conditionalPanel(condition = "input.vline", 
      numericInput("sleep",h4("Please choose an intercept between 1 and 80"),
      value = 30, min = 1, max = 80, step = 1)
                     
                       )),
    # Show outputs
  mainPanel(
    tabsetPanel(
      tabPanel("Text", textOutput("info")),
      tabPanel("Plot", plotOutput("sleepPlot")),
      tabPanel("Table", tableOutput("table"))
    )
  )
  )
))




