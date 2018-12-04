library(shiny)
library(dplyr)
library(ggplot2)
library(tree)
library(randomForest)

shinyServer(function(input, output, session) {
  
	getData <- reactive({
		newTitanicData <- read_csv("titanic.csv")
	})
	#getMLData <- reactive({
	 # newTitanicData <- read_csv("titanic.csv")
	#})
	
  #create plot
  output$vlinePlot <- renderPlot({
  	#get filtered data
  	newData <- getData() 
  	
  	#create plot
  	#Creating plot and adding the condition of adding a vertical line based on user input.
  	
  	g <- ggplot(newData, aes(x = age, y = fare))
  	
  	if(input$vline & input$int){
  	      g + geom_point(size = input$size, aes(col = sex)) +
  	      geom_vline(xintercept = input$int, color="red", 
  	      linetype="dashed", size=1.5)
  	   	}
  	else {
  	  g + geom_point(size = input$size, aes(col = sex))
  	
  	   }
  })
  output$regPlot <- renderPlot({
    #get filtered data
    newData <- getData() 
    
    #create plot
    #Creating the same plot of age and fare, this time with a regression line.
    
    g <- ggplot(newData, aes(x = age, y = fare))
    g + geom_point(size = input$size, aes(col = sex)) +
      geom_smooth(method='lm',color="Blue", formula=y~x, size=1.5)
    
  })
  # Dynamically decreasing the points sizes after adding a vertical line to put more visibility on the line
  
  observe({ if(input$vline) {
    updateSliderInput(session, "size", value = 3, min = 1)
     }  else {
       updateSliderInput(session, "size", value = 5, min = 1)
     }})
  # changing the title dynamically based on the p class
  output$title <- renderUI({ if(input$class == "1") {
    titlePanel("Titanic P Class 1")
  } else if(input$class == "2") {
    titlePanel("Titanic P Class 2")
  } else {
    titlePanel("Titanic P Class 3")
  }
    
    })

  #create text info
  output$info <- renderText({
  	#get filtered data
  	newData <- getData()
  	
  	paste("For Titanic P Class:", input$class,". Next tabs include:", 
  	      "Plot 1 - Age and fare with the possibility to add a vertical line.",
  	      "Plot 2 - Age and fare relationship with a regression line.",
  	      "A Summary table containing the Titanic data with the ability to export the data",
  	      sep = " ")
  	
  	  })
  output$poisson <- renderUI({
    
    newData <- getData()
    # Fitting POssion MOdel
    if(input$agesel) {
      titanicPoissonFit <- glm(survived ~ age*sex, data = newData, family = "poisson")
      poissonPreds <- predict(titanicPoissonFit, newdata = data.frame(age = input$agesel, sex = input$sexsel), 
                              type = "response", se.fit = TRUE)
      paste("Your survival predictions for", input$sexsel, "age", input$agesel, "are as follows:",
            poissonPreds, sep = " ")
    }  else {
      "Please select age and sex for your survival predictions"
    }
    
    
    #paste("Your predictions are: ",input$sexsel,"age",input$agesel,"are:", sep = " ")
    
    
         #  type = "response", se.fit = TRUE)
      #paste("Your predictions for",input$sexsel,"age",input$agesel,"are:", sep = " ")
      #poissonPreds
    
    
   
   })
  output$ML <- renderTable({
    
    newData <- getData()
    # Fitting Classification Tress
    
    titanicDataTree <- titanicData %>% dplyr::select(survived, name, sex, age, sibsp, parch, ticket, fare)# %>% filter(age != "NA")
    #remove NAs
    titanicDataTree <- titanicDataTree[complete.cases(titanicDataTree), ]
    titanicDataTree$survived <- as.factor(titanicDataTree$survived)
    
    set.seed(50)
    train <- sample(1:nrow(titanicDataTree), size = nrow(titanicDataTree)*0.8)
    test <- setdiff(1:nrow(titanicDataTree), train)
    titanicTrain <- titanicDataTree[train, ]
    titanicTest <- titanicDataTree[test, ]
    
    #bagTreeFit <- randomForest(survived ~ ., data = titanicTrain, mtry = ncol(titanicTrain) - 1, ntree = 50, importance = TRUE)
    classTreeFit <- tree(survived ~ ., data = titanicTrain, split = "deviance")
    pred1 <- predict(classTreeFit, newdata = dplyr::select(titanicTest, -survived), type = "class")
    
     # "Classification tree"
    treeTbl <- table(data.frame(Predictions = pred1, Actual = titanicTest$survived))
    treeTbl
    
  })
  output$PCPlot <- renderPlot({
   
    newData <- getData()
    # Fitting a Principal components model for a subset of titanic data which contain numeric variables.
    titanicDataPC <- titanicData %>% dplyr::select(survived, age, sibsp, parch, fare)
    #remove NAs
    titanicDataPC <- titanicDataPC[complete.cases(titanicDataPC), ]
    PCs <- prcomp(select(titanicDataPC, survived:fare), center = TRUE, scale = TRUE)
    # Plotting the first two principal components
    biplot(PCs, xlabs = titanicDataPC$fare, choices = c(1,2), cex = 0.5,
           xlim = c(-0.14, 0.12))
    
    
  })
  
  #create output of observations    
  output$table <- renderTable({
		getData()
  })
  
  
  output$link <- renderUI({
    a("Rise and fall of Titanic", href="http://www.bbc.co.uk/history/titanic")
    
  })
  
})
