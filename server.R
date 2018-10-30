library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {
  
	getData <- reactive({
		newTitanicData <- read_csv("titanic.csv") %>% filter(pclass == input$class) %>% group_by(age, sex) %>% 
		  summarise(meanFare = round(mean(fare, na.rm = TRUE), 2))
	})
	
  #create plot
  output$sleepPlot <- renderPlot({
  	#get filtered data
  	newData <- getData() 
  	
  	#create plot
  	#Creating plot and adding the condition of adding a line based on user input color coding by conservation if true and 
  	#changing the opacity of the point in the graph based on REM sleep variable
  	
  	g <- ggplot(newData, aes(x = age, y = meanFare))
  	#g + geom_point(size = input$size, aes(col = sex))
  	if(input$vline & input$sleep){
  	  g + geom_point(size = 5, aes(col = sex)) +
  	    geom_vline(xintercept = input$sleep, color="red", 
  	               linetype="dashed", size=1.5)
  	#	g + geom_point(size = input$size, aes(col = conservation, alpha = sleep_rem))
  	#} else if(input$conservation & !input$sleep) {
  	#  g + geom_point(size = input$size, aes(col = conservation))
  	}
  	else {
  	  g + geom_point(size = input$size, aes(col = sex))
  	#	g + geom_point(size = input$size)
  	}
  })
  observe({ if(input$sleep) {
    updateSliderInput(session, "size", min = 3)
     }  else {
       updateSliderInput(session, "size", min = 1)
     }})
  # changing the title dynamically based on the p class
  output$title <- renderUI({ if(input$class == "1") {
    titlePanel("Titanic Class 1")
  } else if(input$class == "2") {
    titlePanel("Titanic Class 2")
  } else {
    titlePanel("Titanic Class 3")
  }
    
    })

  #create text info
  output$info <- renderText({
  	#get filtered data
  	newData <- getData()
  	
  	paste("Next two tabs include a Summary table and a plot for average fare for class", input$class, "grouped by age and sex", sep = " ")
  })
  
  #create output of observations    
  output$table <- renderTable({
		getData()
  })
  
})
