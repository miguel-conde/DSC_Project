
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(navbarPage(
  
  # Application title
  titlePanel("Predicting Words"),
  #  title = 'Ya veremos'  
  tabPanel("Predicting",
           sidebarLayout(
             wellPanel(
               tags$style(type="text/css", 
                          '#leftPanel { width:200px; float:left;}'),
               id = "leftPanel",
               conditionalPanel(condition = "input.SBO == 'Simple Back Off'",
                                h4("Simple Back Off"),
                                hr(),
                                radioButtons("SBO_Model", "Choose model:",
                                             c("Blogs"   = "blogs",
                                               "News"    = "news",
                                               "Twitter" = "twitter",
                                               "Global"  = "global"),
                                             selected = 'global'),
                                hr(),
                                strong("Options:"),
                                checkboxInput("finalSample", "Final Sample?", FALSE),
                                checkboxInput("fullResults", "Full results?", FALSE),
                                numericInput(inputId = 'numPred', label = "Max. Predictions", 
                                             value = 5, min = 1, max = 100, step = 1)
               ),
               conditionalPanel(condition = "input.SBO == 'Backoff + Interpolation'",
                                h4("Backoff + Interpolation"), 
                                hr()
               )
             ), # wellPanel
             
             mainPanel(
               id = 'mainPredict',
               tabsetPanel(
                 id = 'SBO',
                 tabPanel('Simple Back Off', 
                          
                          helpText("This is a teaching tool for Introductory Statistics. It displays a t-Distribtuion and a normal curve with user defined degrees of freedom and numbr of observations.
                                   The purpose is to help visualize difference between the two distributions. 
                                   See the instructions on the side panel."),
                          wellPanel(
                            textInput(inputId = "userText", label = 'Enter your text:')
                          ),
                          h3('Prediction:'),
                          verbatimTextOutput('wordPredicted'),
                          h3('Other likely predictions:'),
                          verbatimTextOutput('otherPredictions')
                 ),
                 tabPanel('Backoff + Interpolation',
                          helpText("This is a teaching tool for Introductory Statistics. It displays a t-Distribtuion and a normal curve with user defined degrees of freedom and numbr of observations.
                                   The purpose is to help visualize difference between the two distributions. 
                                   See the instructions on the side panel."),
                          hr()
                          
                 ),
                 tabPanel('Chart',
                          helpText("This is a teaching tool for Introductory Statistics. It displays a t-Distribtuion and a normal curve with user defined degrees of freedom and numbr of observations.
                                   The purpose is to help visualize difference between the two distributions. 
                                   See the instructions on the side panel.")
                 ),
                 tabPanel('Pest14')
               ) # tabsetPanel
             ) # mainPanel - este o el de arriba ¿no? Sobra uno...
           ) # sidebarLayout - ¿TODO está dentro del sideBarPanel??????
  ), # tabPanel Data
  tabPanel("Help",
           wellPanel(
             tags$style(type="text/css", 
                        '#leftPanel { width:200px; float:left;}'),
             id = "leftPanel",
             conditionalPanel(condition = "!is.null(dim(symbol))",
                              sliderInput("range", "Range:",
                                          min = 1, max = 10000, 
                                          step = 10, value = c(1,10000),
                              ),
                              checkboxGroupInput('chart_patterns', 'Patterns:',
                                                 c("Dragonfly", "Engulfing Bullish",
                                                   "Engulfing Bearish")
                              )
             )
             
           ),
           mainPanel(
             helpText("This is a teaching tool for Introductory Statistics. It displays a t-Distribtuion and a normal curve with user defined degrees of freedom and numbr of observations.
                      The purpose is to help visualize difference between the two distributions. 
                      See the instructions on the side panel."),
             plotOutput('chart', 
                        width = "800px", height = "600px")
           )
  ),
  navbarMenu("About",
             tabPanel("More1"),
             tabPanel("More2")
  ),
  tabPanel("Menu 4")
  
))
