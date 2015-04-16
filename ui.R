
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(markdown)
source("Global.R")

shinyUI(navbarPage(
  
        #tagList(
        #  tags$head(
        #    tags$link(rel  = 'stylesheet',
        #              type = 'text/css', href = 'styles.css')
        #    )
        #  ),
  #tags$style(type="text/css", 
  #           '#shiny-progress { top: 50% !important;left: 50% !important;margin-top: -100px !important;margin-left: -250px !important;}'),
  
  
  # Application title
  titlePanel(h2("Predicting Words", style = "font-family: 'Lobster', cursive;
        font-weight: 500; line-height: 1.1; 
        color: #4d3a7d;")),
  
  #  titlePanel("",
  #             tags$head(
  #               tags$img(src="http://unbounce.com/photos/mvt-word-cloud.png", 
  #                        height="100px"))           
  #  ),
  #  title = 'Ya veremos' 
  
  tabPanel("Predicting",
           tags$link(rel  = 'stylesheet', type = 'text/css', href = 'styles.css'),
           includeCSS(file.path(".","www",'styles.css')),
           sidebarLayout(
             wellPanel(
               tags$style(type="text/css", 
                          '#leftPanel { width:200px; float:left;}'),
               id = "leftPanel",
               h4("Change settings"),
               hr(),
               checkboxInput('settings', "Access to settings", FALSE),
               hr(),
               conditionalPanel(
                 condition = "input.settings",
                 radioButtons("SBO_Model", "Choose model:",
                              c("Blogs"   = "blogs",
                                "News"    = "news",
                                "Twitter" = "twitter",
                                "Global"  = "global"),
                              selected = 'twitter'),
                 hr(),
                 strong("Options:"),
                 checkboxInput("interpolation", "Use interpolation?", TRUE),
                 checkboxInput("finalSample", "Final Sample?", FALSE),
                 checkboxInput("fullResults", "Detailed Results?", FALSE),
                 numericInput(inputId = 'numPred', label = "Max. Predictions:", 
                              value = 10, min = 1, max = 100, step = 1)
               )
             ), # wellPanel
             
             mainPanel(
               id = 'mainPredict',
               helpText(hlp_txt_1),
               hr(),
               wellPanel(
                 textInput(inputId = "userText", label = 'Enter your text:')
                 #tags$style(type='text/css', "#userText {  resize:vertical; max-height:300px; min-height:200px; }")
               ),
               hr(),
#               fluidRow(
#                 column(5, align = "top",
#                        h4('Main Prediction:')
#                 ),
#                 column(8, align = "bottom",
#                        verbatimTextOutput('wordPredicted')
#                 )
#               ),
               h4('Main Prediction:'),
               verbatimTextOutput('wordPredicted'),
               hr(),
               selectInput('selWord', 'Select next word', "", 
                           multiple=FALSE, selectize=FALSE),
               conditionalPanel(condition = 'input.fullResults',
                                h3('Detailed Results:'),
                                verbatimTextOutput('otherPredictions')
               )
             ) # mainPanel
           ) # sidebarLayout
  ), # tabPanel 'Predicting'
  navbarMenu("Help",
             tabPanel("User Help",
                      includeMarkdown("Help.md")
             ), 
             tabPanel("Inside the Box",
                      includeMarkdown("Inside.md")
             )),
  tabPanel("About",
           fluidRow(
             column(6,
                    includeMarkdown("About.md")
             ),
             column(3,
                    img(class="img-polaroid",
                        src=paste0("http://upload.wikimedia.org/",
                                   "wikipedia/commons/1/1a/",
                                   "ANI-wordcloud-3-17-2015.png"),
                        height = 320, width = 450
                    ),
                    tags$small(
                      "Source: Word cloud generated from current revision of WP:AN/I plus past 3 or 4 archives. Generated using R and wordcloud package. by MastCell (Own work) [CC BY-SA 4.0",
                      a(href="https://commons.wikimedia.org/w/index.php?title=User:MastCell&action=edit&redlink=1", "MastCell"), 
                      "or",
                      a(href="http://creativecommons.org/licenses/by-sa/4.0", "via Wikimedia Commons"),
                      "]"
                      
                    )
             )
           )
  ) # tabPanel 'About'
  
))
