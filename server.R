
library(shiny)
library(stringr)
library(qdap)
library(NLP)
library(tm)

# input data
df_freq_2_gram <- readRDS(file = "./mydata/df_freq_2_gram.Rda")
df_freq_3_gram <- readRDS(file = "./mydata/df_freq_3_gram.Rda")
df_freq_4_gram <- readRDS(file = "./mydata/df_freq_4_gram.Rda")

# functions
source("./BusinessLogic.R")


shinyServer(function(input, output) {
          
          startTime <- Sys.time()
          predictions <- reactive({
                  prediction(input$stringInput,df_freq_2_gram,df_freq_3_gram,df_freq_4_gram)
          })  
          endTime <- Sys.time()
          run_Time <- round((endTime-startTime)*1000, digits=4)
          
          output$Pred1 <- renderText({paste("Prediction 1:", predictions()[1])})
          output$Pred2 <- renderText(paste("Prediction 2:", predictions()[2]))
          output$Pred3 <- renderText(paste("Prediction 3:", predictions()[3]))
          output$runTime <- renderText(paste("Runtime :",run_Time, "millisecond(s)"))
          
})
