#'
#' MODULE Global.R
#' 

dirModelsSBO <- file.path(".", "models", "modelsSBO")
dirR <- file.path(".", "R")

m.BlogsFile   <- file.path(dirModelsSBO,  "m.Blogs.RData")
m.NewsFile    <- file.path(dirModelsSBO,  "m.News.RData")
m.TwitterFile <- file.path(dirModelsSBO,  "m.Twitter.RData")
m.TotalFile   <- file.path(dirModelsSBO,  "m.Total.RData")

source(file.path(dirR, "predict.R"))
source(file.path(dirR, "makeTFLs.R"))
source(file.path(dirR, "managePunct.R"))
source(file.path(dirR, "splitIntoTokens.R"))
source(file.path(dirR, "arrangeSelList.R"))


library(RWeka)
library(tm)
library(data.table)

oldSelModel <<- ""

hlp_txt_1 <<- "You can type or paste your text in the text box below. The main 
candidate word will be predicted under the text box, but other possible words 
will be shown in the drop down list. You can select from this list the next 
word to be added to your text.\nPrediction settings can be accessed and
changed in the left sidebar."

l_Blogs   <<- c(0.01561975, 0.03848051, 0.04571407, 0.90018566)
l_News    <<- c(0.02095653, 0.05361416, 0.06220533, 0.86322398)
l_Twitter <<- c(0.05549261, 0.10944140, 0.15447238, 0.68059362)
l_Total   <<- c(0.01906878, 0.05788172, 0.06563039, 0.85741911)
l <<- NULL

#model <<- loadModelTotal()

oldSelWord <<- ""

#' 
#' @name arrangePred(words)
#' 

arrangePred <- function(words) {
  
  res <- words[1]
  
  nWords <- length(words)
  if (nWords > 1)
  sapply(words[2:nWords], function(x) {
    res <<- paste0(res, ", ", x)
  })
  
  return(res)
}