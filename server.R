
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
                     if (sel == 'blogs' ) {
                       model <<- loadModelBlogs()
                       l <<- l_Blogs
                     }
                     else
                       if (sel == 'news' ) {
                         model <<- loadModelNews()
                         l <<- l_News
                       }
                     else
                       if (sel == 'twitter' ) {
                         model <<- loadModelTwitter()
                         l <<- l_Twitter
                       }
                     else
                       if (sel == 'global' ) {
                         model <<- loadModelTotal()
                         l <<- l_Total
                       }
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
                   res <- predictNG_v2(model, tokens, 
                                       finalSample = input$finalSample, 
                                       fullRes = TRUE, 
                                       NPredictions = input$numPred,
                                       interpol = input$interpolation)
                 })
    
    #    if(!input$fullResults)
    #      Best <- as.list(c(Choose = '',res[[2]]))
    #    else {
    choiceList <- arrangeSelList(res)
    if(length(choiceList$Max.Prob) == 1)
      Best <- list(Choose = '', 
                   choiceList$Max.Prob, 
                   Other.Possibilities = choiceList$Others )
    else
      Best <- list(Choose = '', 
                   Max.Prob = choiceList$Max.Prob, 
                   Other.Possibilities = choiceList$Others )
    #    }
    updateSelectInput(session, 'selWord',  
                      choices = Best,
                      selected = NULL)
    res
  })
  
  output$otherPredictions <- renderPrint({
    pred <- predict()[[2]]
    if(!input$fullResults)
      writeLines(arrangePred(pred))
    else
      predict()[[2]]
  })
  
  output$wordPredicted <- renderPrint({
    pred <- predict()[[1]]
    if(!input$fullResults) {
      colPredict <- grep("WG[1234]", names(pred))
      colPredict <- colPredict[length(colPredict)]
      writeLines(as.character(as.matrix(pred[colPredict])))
      #writeLines(pred)
    }
    else
      pred
  })
  
  observe({
    x <- input$selWord
    if (oldSelWord != input$selWord & x != '') {
      res <- paste0(input$userText, " ", input$selWord)
      oldSelWord <<- input$selWord
      updateTextInput(session, 'userText', value = res)
    }
  })
  
})
