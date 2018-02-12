
library(shiny)


shinyUI(fluidPage(

  titlePanel("What's the next best word?"),
  
  sidebarLayout(
    sidebarPanel(
            p(strong("Description")),
            p("This is a Shiny app that takes an incomplete sentence and predicts the next word to come.
              For this purpose we apply data science in the area of Natural Language Processing (NLP). 
              This prediction algorithm is based on n-grams derived using the text files", 
              span("en_US.blogs.txt, en_US.news.txt, en_US.twitter.txt", style="font-family:monospace"), "in the" ,
                   span("en_US", style="font-family:monospace"), "folder from the following source:"),
            p(a( "Dataset",
                href= "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip")),
            
            p("\n"),
            p(strong("How to Use: ")), 
            p("1. In the 'Predictions' tab, type the first few words of your sentence in the 'Your input' textbox."), 
            p("2. Click on the 'Submit' button."),
            p("You will get the three best predictions the algorithm comes up with."),
            
            p("\n"),
            p(strong("Algorithm")),
            p("For further details about the core algorithm, please click on 'About' tab.")
            
    ),
    
    mainPanel(
       tabsetPanel(
               tabPanel("Predictions",
                        p("\n"),
                        p("Enter an incomplete sentence.\n"),
                        textInput("stringInput", label = "Your input:", value = "What will you do"),     
                        
                        p("\n"),
                        submitButton("Submit"),
                        p("\n"),
                       h3("Three best predictions"),
                       verbatimTextOutput("Pred1", placeholder = TRUE),
                       verbatimTextOutput("Pred2", placeholder = TRUE),
                       verbatimTextOutput("Pred3", placeholder = TRUE),
                       p("\n"),
                       span(textOutput("runTime"),style = "text-align:right")
               ),
               
               tabPanel("About", 
                        h3("Prediction Algorithm"),
                        p(strong("Introduction")),
                        p("In this capstone project we are applying data science for natural language processing.
                          We used all the three text files;", span("en_US.blogs.txt, en_US.news.txt, en_US.twitter.txt", style="font-family:monospace"),
                        "in the", span("en_US", style="font-family:monospace"), "folder from the following source."),
                        p("Dataset :", a( "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip",
                                                href= "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip")),
                        
                        p("\n"),
                        p(strong("Cleaning the Data")),
                        p("1. Replace non-ASCII characters with an empty string."),
                        p("2. Merge all the three data sets into a single vector."),
                        p("3. Divide the vector into ten equal subsets."),
                        p("4. For each subset: Use the", span("qdap", style="font-family:monospace"), "R package to replace the abbreviations
                          and contractions. Use", span("NLP", style="font-family:monospace"), "and", span("tm", style="font-family:monospace"), "R packages to make a vector source and a
                          volatile corpus. Then remove the punctuations and numbers in the created volatile corpus."),
                        p("5. Create a corpus using the quanteda r package."),

                        p(strong("Creating the n-gram")),
                        p("Create document-feature matrices of bigrams, trigrams and quadrigrams for each of the 10 corpuses."),
                        p("Then sort them and save each of them in a data frame with columns",
                          span("term", style="font-family:monospace"), "and", span("frequency.", style="font-family:monospace")),
                        p("First connect all the 10 bigram data frames using", span("merge,", style="font-family:monospace"), "and then sort the
                          result in the descending order of the frequency using", span("arrange.", style="font-family:monospace"),
                          "Repeat this process for the trigrams and quadrigrams to create the full frequency data frames for each of them."),
                        p("Finally, split the last word in each string in", span("term", style="font-family:monospace"),
                          "column into a separate column named", span("word.", style="font-family:monospace"),
                          "This needs to be done for all three final n-grams."),

                        p(strong("Prediction Algorithm")),
                        p("To predict the next word I used a set of custom developed functions " ,
                          span("prediction(), word_tokens(), min_1_wordString(), min_2_wordString()", style="font-family:monospace"), "and" ,
                          span("min_3_wordString()", style="font-family:monospace"),"that use the three full n-grams created above."),

                        p("Source code : ", 
                          a("https://github.com/chamikaKity/NLP_CapstoneProject/blob/master/BusinessLogic.R",
                            href="https://github.com/chamikaKity/NLP_CapstoneProject/blob/master/BusinessLogic.R")),

                        img(src="diagram_1.png", align="center"),

                        p(span("prediction()", style="font-family:monospace")),
                        p("When you enter a partial sentence into the", span("prediction()", style="font-family:monospace"), "function,
                          it preprocesses the input using", span("word_tokens()", style="font-family:monospace"), "and redirects the input
                          to a suitable function below. This function also returns the final result to the UI."),

                        p(span("word_tokens()", style="font-family:monospace")),
                        p("When this function receives an input string, it first replaces any abbreviations and contractions,
                          converts it into lowercase and removes any numbers and punctuations. Then, depending on the number
                          of words in the resulting string, it splits out the last word, last two words, or the last three words
                          into a single vector."),

                        p(span("min_3_wordString()", style="font-family:monospace")),
                        p("This function receives a vector that may contain three separate strings. If the input has a
                          string with three words, it uses the full quadrigram to find the best three predictions for the
                          next word. If it doesn't find a good solution it redirects the input to",
                          span("min_2_wordString()", style="font-family:monospace"), "function below."),

                        p(span("min_2_wordString()", style="font-family:monospace")),
                        p("This function receives a vector that may contain three separate strings.
                          If the input has a string with two words, it uses the full trigram to find the best three predictions
                          for the next word. If it doesn't find a good solution it redirects the input to",
                          span("min_1_wordString()", style="font-family:monospace"), "function below."),

                        p(span("min_1_wordString()", style="font-family:monospace")),
                        p("This function receives a vector that may contain three separate strings.
                          If the input has a string with a single word, it uses the bigram to find the
                          best three predictions for the next word."),

                        p("")
               )
       )
    )
  )
))
