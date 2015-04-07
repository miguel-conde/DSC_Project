
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

source("Global.R")

shinyServer(function(input, output, session) {
  
  ## Reactives
  changeModel <- reactive({

    sel <- input$SBO_Model

    if (sel != oldSelModel) {
      withProgress(message = sprintf("Loading model '%s'", sel),
                   detail = "Can take a few seconds...", {
        if (sel == 'blogs' )
          model <<- loadModelBlogs()
        else
          if (sel == 'news' )
            model <<- loadModelNews()
        else
          if (sel == 'twitter' )
            model <<- loadModelTwitter()
        else
          if (sel == 'global' )
            model <<- loadModelTotal()
      })
      
      oldSelModel <<- sel
    }
  })
  
  predict <- reactive({
    
    changeModel()
    
    tokens = splitIntoTokens(model, input$userText)
    
    validate(
      need(input$numPred > 0 & input$numPred <= 100, 
           "Please, 'Max. Predictions' must be a number between 1 and 100")
    )
    
    withProgress(message = sprintf("Predicting"),
                 detail = "Wait...", {
      predictNG_v2(model, tokens, 
                   finalSample = input$finalSample, 
                   fullRes = input$fullResults, 
                   NPredictions = input$numPred)
                 })
  })
  
  output$otherPredictions <- renderPrint({
    if(!input$fullResults)
      writeLines(arrangePred(predict()[[2]]))
    else
      predict()[[2]]
  })
  
  output$wordPredicted <- renderPrint({
    if(!input$fullResults)
      writeLines(predict()[[1]])
    else
      predict()[[1]]
  })
  
  
  
})
