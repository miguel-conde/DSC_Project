
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
                                             c("Blogs" = "blogs",
                                               "News" = "news",
                                               "Twitter" = "twitter",
                                               "Global" = "global"),
                                             selected = 'global'),
                                hr(),
                                checkboxInput("finalSample", "Final Sample?", FALSE)
               ),
               conditionalPanel(condition = "input.SBO == 'Backoff + Interpolation'",
                                h4("Backoff + Interpolation")
                                )
             ), # wellPanel
             
             mainPanel(
               
               tabsetPanel(
                 id = "SBO",
                 tabPanel("Simple Back Off", 
                          helpText("This is a teaching tool for Introductory Statistics. It displays a t-Distribtuion and a normal curve with user defined degrees of freedom and numbr of observations.
                                   The purpose is to help visualize difference between the two distributions. 
                                   See the instructions on the side panel."),
                          wellPanel(
                          fluidRow(
                            column(8,
                                   textInput('userText', 'Enter your text:'), 
                                   actionButton('validateInput', 
                                                label = 'Validate')
                            ),
                            column(4, offset = 0,
                                   strong('Prediction:'),
                                   verbatimTextOutput('wordPredicted')
                            )
                          )
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
                          hr(),
                          h2("ESTADÍSTICA DE LA MUESTRA"),
                          hr(),
                          dataTableOutput('table_est1'),
                          hr(),
                          h2("HISTOGRAMA DE VOLUMEN"),
                          plotOutput('volHistogram', 
                                     width = "800px", height = "450px"), 
                          hr(),
                          h2("DISTRIBUCIÓN POR TIPOS DE VELA"),
                          dataTableOutput('table_distr_candles'),
                          hr(),
                          h2("DISTRIBUCIÓN DE VALORES POR TIPO DE VELA"),
                          plotOutput('tipoVelaHistogram'),
                          hr(),
                          h2("HISTOGRAMA POR TAMAÑO DEL CUERPO DE VELA"),
                          plotOutput("s_bHistogram", 
                                     width = "800px", height = "900px"),
                          hr(),
                          h2("RESULTADOS"),
                          h3("Patrón A"),
                          verbatimTextOutput('res_P_A')
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
