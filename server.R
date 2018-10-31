library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {
  
	getData <- reactive({
		newTitanicData <- read_csv("titanic.csv") %>% filter(pclass == input$class) %>% group_by(age, sex) %>% 
		  summarise(meanFare = round(mean(fare, na.rm = TRUE), 2))
	})
	
  #create plot
  output$vlinePlot <- renderPlot({
  	#get filtered data
  	newData <- getData() 
  	
  	#create plot
  	#Creating plot and adding the condition of adding a vertical line based on user input.
  	
  	g <- ggplot(newData, aes(x = age, y = meanFare))
  	
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
    #Creating the same plot of age and average fare, this time with a regression line.
    
    g <- ggplot(newData, aes(x = age, y = meanFare))
    g + geom_point(size = input$size, aes(col = sex)) +
      geom_smooth(method='lm',color="Blue", formula=y~x, size=1.5)
    
  })
  # Dynamically decresing the points sizes after adding a vertical line to put more visibility on the line
  
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
  	      "Plot 1 - Age and average fare with a vertical line the possibility to add a vertical line.",
  	      "Plot 2 - Age and average fare with a regression line.",
  	      "A Summary table containing the subset of the Titanic data with the ability to export the data",
  	      sep = " ")
  	
  	  })
  
  #create output of observations    
  output$table <- renderTable({
		getData()
  })
  
  
  output$link <- renderUI({
    a("Rise and fall of Titanic", href="http://www.bbc.co.uk/history/titanic")
    
  })
  
})
