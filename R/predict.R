#'
#' MODULE predict.R
#' 

#source("./R/dfNames.R")
library(data.table)

sumProbs <- function(x) sum(10^x)


#'
#'@name loadModelBlogs()
#'

loadModelBlogs <- function() {
  
  # Load model 4G
  load(m.BlogsFile)
  
  ## Create TFLs for 1,2 ang 3-grams
  ## Add frequency and logprob columns
  tfl_Blogs_4G <- addProbs4G(tfl_Blogs_4G)
  tfl_Blogs_3G <- getTFL3G(tfl_Blogs_4G)
  tfl_Blogs_2G <- getTFL2G(tfl_Blogs_4G)
  tfl_Blogs_1G <- getTFL1G(tfl_Blogs_4G)

  m.Blogs   <- list(m.1G = tfl_Blogs_1G, m.2G = tfl_Blogs_2G,
                    m.3G = tfl_Blogs_3G, m.4G = tfl_Blogs_4G)
  return(m.Blogs)
  
}

loadModelNews <- function() {
  
  # Load model 4G
  load(m.NewsFile)
  
  ## Create TFLs for 1,2 ang 3-grams
  ## Add frequency and logprob columns
  tfl_News_4G <- addProbs4G(tfl_News_4G)
  tfl_News_3G <- getTFL3G(tfl_News_4G)
  tfl_News_2G <- getTFL2G(tfl_News_4G)
  tfl_News_1G <- getTFL1G(tfl_News_4G)
  
  m.News   <- list(m.1G = tfl_News_1G, m.2G = tfl_News_2G,
                   m.3G = tfl_News_3G, m.4G = tfl_News_4G)
  return(m.News)
  
}

loadModelTwitter <- function() {
  
  # Load model 4G
  load(m.TwitterFile)
  
  ## Create TFLs for 1,2 ang 3-grams
  ## Add frequency and logprob columns
  tfl_Twitter_4G <- addProbs4G(tfl_Twitter_4G)
  tfl_Twitter_3G <- getTFL3G(tfl_Twitter_4G)
  tfl_Twitter_2G <- getTFL2G(tfl_Twitter_4G)
  tfl_Twitter_1G <- getTFL1G(tfl_Twitter_4G)
  
  m.Twitter   <- list(m.1G = tfl_Twitter_1G, m.2G = tfl_Twitter_2G,
                      m.3G = tfl_Twitter_3G, m.4G = tfl_Twitter_4G)
  return(m.Twitter)
  
}

loadModelTotal <- function() {
  
  # Load model 4G
  load(m.TotalFile)
  
  ## Create TFLs for 1,2 ang 3-grams
  ## Add frequency and logprob columns
  tfl_Total_4G <- addProbs4G(tfl_Total_4G)
  tfl_Total_3G <- getTFL3G(tfl_Total_4G)
  tfl_Total_2G <- getTFL2G(tfl_Total_4G)
  tfl_Total_1G <- getTFL1G(tfl_Total_4G)
  
  m.Total   <- list(m.1G = tfl_Total_1G, m.2G = tfl_Total_2G,
                    m.3G = tfl_Total_3G, m.4G = tfl_Total_4G)
  return(m.Total)
  
}

#'
#' @name FUNCTION predictNG()
#' 
#' @description This function takes one of the models - Blogs, News, Twitter - Total - and a
#' set of tokens and predicts the next word.
#' 
#' @param model list; object that contains the model to use: m.Blogs, m.News,
#' m.Twitter, m.Total
#' @param words strings vector; contains the 3 tokens to take as input to 
#' prediction
#' @finalSample logical; if TRUE, returns a sample of words based on probability
#' weights
#' @Npredictions integer; number of word to predict
#' 
#' @return
#' 
#' @include library(data.table
#' @usage the model must be loaded before using.
#' @example m.BlogsFile <- file.path(trainingBlogsModelDirectory, "m.Blogs.RData")
#' load(m.BlogsFile)
#' predictNG(m.Blogs, c("thank", "you", "very"), NPredictions = 5, 
#' finalSample = TRUE)

## NEW VERSION
predictNG4 <- function(model, words) {
  nWords <- length(words)
#print(words)  
  if (nWords < 3)
    stop("predictNG4: Number of words must be at least 3")
  if (nWords > 3)
    tokens <- words[(nWords - 3 + 1):nWords]
  else
    tokens <- words
#print(tokens)  
  # Search the 4-Gram table 
  setkey(model[["m.4G"]], "WG1", "WG2", "WG3")
  
  prediction <- as.data.frame(model[["m.4G"]][as.list(tokens), ])
  
  if (!is.na(prediction$WG4[1])) # found 4-gram
  {
    prediction <- prediction[order(prediction$logProb, decreasing = TRUE),]
  } else # search in 3-grams
  { 
    prediction <- predictNG3(model, words)
  }
  return(prediction)
}

predictNG3 <- function(model, words) {
  nWords <- length(words)
  
  if (nWords < 2)
    stop("predictNG3: Number of words must be at least 2")
  if (nWords > 2)
    tokens <- words[(nWords - 2 + 1):nWords]
  else
    tokens <- words
  
  # Search the 3-Gram table 
  setkey(model[["m.3G"]], "WG1", "WG2")
  
  prediction <- as.data.frame(model[["m.3G"]][as.list(tokens), ])
  
  if (!is.na(prediction$WG3[1])) # found 3-gram
  {
    prediction <- prediction[order(prediction$logProb, decreasing = TRUE),]
  } else # search in 2-grams
  { 
    prediction <- predictNG2(model, words)
  }
  return(prediction)
}

predictNG2 <- function(model, words) {
  nWords <- length(words)
  
  if (nWords < 1)
    stop("predictNG2: Number of words must be at least 1")
  if (nWords > 1)
    tokens <- words[(nWords - 1 + 1):nWords]
  else
    tokens <- words
  
  # Search the 2-Gram table 
  setkey(model[["m.2G"]], "WG1")
  
  prediction <- as.data.frame(model[["m.2G"]][as.list(tokens), ])
  
  if (!is.na(prediction$WG2[1])) # found 2-gram
  {
    prediction <- prediction[order(prediction$logProb, decreasing = TRUE),]
  } else # search in 1-grams
  { 
    prediction <- predictNG1(model)
  }
  return(prediction)
}

predictNG1 <- function(model) {
  # Search the 1-Gram table 
  p_weights <-  model[["m.1G"]][ , Freq]
  prediction <- sample(1:dim(model[["m.1G"]])[1], size = 50, prob = p_weights)
  prediction <- model[["m.1G"]][prediction]
  prediction <- prediction[order(prediction$logProb, decreasing=TRUE), ]
  return(prediction)
}

predictNG_v2 <- function(model, words, NPredictions = 5, 
                       finalSample = FALSE, fullRes = TRUE) {

  nWords <- length(words)
#print(sprintf("predictNG_v2:"))  
#print(words)
  if (nWords >= 3)
    prediction <- predictNG4(model, words) 
  else if (nWords == 2)
    prediction <- predictNG3(model, words)
  else if (nWords == 1)
    prediction <- predictNG2(model, words)    
  
  if (finalSample == FALSE) 
  {
    mostFreq <- which(prediction$logProb == max(prediction$logProb))
    ## At least 2 words have the same probability: sample 1 among them and return 
    ## it
    if (length(mostFreq) > 1) {
      idx_max_prediction <- sample(1:length(mostFreq), size = 1,
                                   prob = rep(1/length(mostFreq),
                                              length(mostFreq)))
      #print(idx_max_prediction)
      max_prediction <- prediction[mostFreq[idx_max_prediction],]
    } else
      ## ELSE: return the most frequent word
      max_prediction <- prediction[1,]
    
  } else ## finalSample == TRUE: sample all words (weighted) and return 1
  {
    idx_max_prediction <- sample(1:dim(prediction)[1], size = 1, 
                                 prob = prediction$Freq )
    max_prediction <- prediction[idx_max_prediction,]
  }
  if (fullRes == TRUE)
    return(list(max_prediction, 
                prediction[1:min(dim(prediction)[1], NPredictions), ]))
  colPred <- grep("WG[1234]", names(prediction), value=T)
  colPred <- length(colPred)
  return(list(as.vector(as.matrix(max_prediction[colPred])), 
              as.vector(prediction[1:min(dim(prediction)[1], 
                                         NPredictions), colPred])))
}

