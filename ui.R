library(ggplot2)
library(readr)
#titanicData <- read_csv("titanic.csv")


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
      checkboxInput("pred", h4("Survival Predictions Model", style = "color:blue;")),
      conditionalPanel(condition = "input.pred", 
                       numericInput("agesel",h4("Select the age of the passenger"),
                                    value = 0, min = 1, max = 99, step = 1),
                       selectizeInput("sexsel", "Select Sex of the passenger", 
                          selected = "female", choices = levels(as.factor(titanicData$sex)))
                       ),
      
      checkboxInput("vline", h4("Add a vertical line plot 1", style = "color:blue;")),
      
    conditionalPanel(condition = "input.vline", 
      numericInput("int",h4("Please choose an intercept between 1 and 80"),
      value = 30, min = 1, max = 80, step = 1)
      
                     
                     )),
    
      
    #conditionalPanel(condition = "input.poisson", 
                     #selectizeInput("age1", "Select Sex of the passenger", selected = "female", choices = levels(as.factor(titanicData$sex)))
                     
                 
                     
    #)),
      # Show outputs
  mainPanel(
    
    
    tabsetPanel(
      
      tabPanel("About", textOutput("info")),
      tabPanel("Survival Prediction Model", uiOutput("poisson")),
      tabPanel("Survival Class Tree.Prediction Vs Actual", tableOutput("ML")),
      tabPanel("PC Plot", plotOutput("PCPlot")),
      tabPanel("Plot 1", plotOutput("vlinePlot")),
      tabPanel("Plot 2", plotOutput("regPlot")),
      tabPanel("Table", tableOutput("table")),
      tabPanel("Article about Titanic", uiOutput("link"))
    )
  )
  )
))




