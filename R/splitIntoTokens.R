# source("./R/managePunct.R")
# source("./R/makeTFLs.R")
# source("./R/predict.R")
# 
# library(tm)
# library(RWeka)
# library(data.table)

#' 
#' @name splitIntoTokens(line)
#' 
#' @description this function takes a text "line" and returns it splitted
#' into 1-grams
#' 
#' @param model to use (to search for <unk>s)
#' @param line character; text string to split into 4-grams
#' 
#' @return a vector, each element is an 1-gram
#' 
splitIntoTokens <- function(model, line) {
  
  # Process punctuation
  s <- managePunct(line)
  
  # tolower
  s <- tolower(s)
  
  # stripwhitespaces
  s <- stripWhitespace(s)
  
  # Add seudowords
  s <- paste0("<stx> <stx> <stx> ", grep("^.*$", s, value = TRUE))
  
  # Tokenize
  NGrams <- NGramTokenizer(s, Weka_control(min = 1, max = 1,
                                           delimiters = ' \r\n\t"'))
  
  # Split into tokens and reemplace OOV words by "<unk>"
  NGrams <- sapply(NGrams, function(x) {
    if (x != "<stx>" & x != "<etx>" & prob1G(model, x) == -Inf) 
      "<unk>"
    else
      x
  })
  
  return(as.character(NGrams))
}


prob1G <- function(model, w) {
  setkey(model$m.1G, WG1)
  
  Prob <- model$m.1G[.(w)]
  
  if(is.na(Prob$logProb)) 
      return(-Inf) 

  return(Prob$logProb)
}