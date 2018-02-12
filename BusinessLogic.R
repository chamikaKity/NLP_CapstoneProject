# next word prediction functions

min_1_wordString <- function(last_word,df_freq_2_gram){
        x <- which(df_freq_2_gram$term==last_word)
        pred_2_gram <- df_freq_2_gram[x,]
        n1 <- dim(pred_2_gram)[1]
        
        no_word <- 0
        if(n1>=3){
                pred1 <- pred_2_gram$word[1:3]
                return(c(pred1))
                
        }
        if(n1==0){
                x <- c()
                maxFreq_words <-  c("the","to","and","a","of","in","i","that","for",
                                    "is","it","on","you","with","was")
                for(i in 1:3){x[i]<-maxFreq_words[i]}
                return(c(x))
        }
        if(n1>0 & n1<3){
                no_word <- no_word+n1
                pred2 <- pred_2_gram$word[1:no_word]
                n_pred2 <- length(pred2)
                x <- c()
                maxFreq_words <-  c("the","to","and","a","of","in","i","that","for",
                                    "is","it","on","you","with","was")
                if(n_pred2==1){
                        x0 <- length(which(maxFreq_words==pred2))
                        if(x0!=0){maxFreq_words <- maxFreq_words[-(which(maxFreq_words==pred2))]}
                }
                if(n_pred2==2){
                        for(i in 1:2){
                                x0 <- length(which(maxFreq_words==pred2[i]))
                                if(x0!=0){maxFreq_words <- maxFreq_words[-(which(maxFreq_words==pred2[i]))]}
                        }
                }
                for(i in 1:(3-no_word)){x[i]<-maxFreq_words[i]}
                return(c(pred2,x))
        }
}

#-------------------------------------------------------------------------------

min_2_wordString <- function(last_2_words, last_word,df_freq_2_gram,df_freq_3_gram){
        x <- which(df_freq_3_gram$term==last_2_words)
        pred_3_gram <- df_freq_3_gram[x,]
        n1 <- dim(pred_3_gram)[1]
        
        no_word <- 0
        if(n1>=3){
                pred1 <- pred_3_gram$word[1:3]
                return(c(pred1))
        }
        if(n1==0){
                return(c(min_1_wordString(last_word,df_freq_2_gram)))
                
        }
        if(n1>0 & n1<3){
                no_word <- no_word+n1
                pred2 <- pred_3_gram$word[1:no_word]
                n_pred2 <- length(pred2)
                k2 <- c()
                k <- min_1_wordString(last_word,df_freq_2_gram)
                if(n_pred2==1){
                        k0 <- length(which(k==pred2))
                        if(k0!=0){k <- k[-(which(k==pred2))]}
                }
                if(n_pred2==2){
                        for(i in 1:2){
                                k0 <- length(which(k==pred2[i]))
                                if(k0!=0){k <- k[-(which(k==pred2[i]))]}
                        }
                }
                for(i in 1:(3-no_word)){k2[i]<- k[i]}
                return(c(pred2,k2))
                
        }
}

#-------------------------------------------------------------------------------

min_3_wordString <- function(last_3_words,last_2_words,last_word,df_freq_2_gram,df_freq_3_gram,df_freq_4_gram){
        x <- which(df_freq_4_gram$term==last_3_words)
        pred_4_gram <- df_freq_4_gram[x,]
        n1 <- dim(pred_4_gram)[1]
        
        no_word <- 0
        if(n1>=3){
                pred1 <- pred_4_gram$word[1:3]
                return(c(pred1))
        }
        if(n1==0){
                return(c(min_2_wordString(last_2_words,last_word,df_freq_2_gram,df_freq_3_gram)))
                
        }
        if(n1>0 & n1<3){
                no_word <- no_word+n1
                pred2 <- pred_4_gram$word[1:no_word]
                n_pred2 <- length(pred2)
                k2 <- c()
                k <- min_2_wordString(last_2_words,last_word,df_freq_2_gram,df_freq_3_gram)
                if(n_pred2==1){
                        k0 <- length(which(k==pred2))
                        if(k0!=0){k <- k[-(which(k==pred2))]}
                }
                if(n_pred2==2){
                        for(i in 1:2){
                                k0 <- length(which(k==pred2[i]))
                                if(k0!=0){k <- k[-(which(k==pred2[i]))]}
                        }
                }
                # k <- k[-(which(pred2==k))]
                for(i in 1:(3-no_word)){k2[i]<- k[i]}
                return(c(pred2,k2))
                
        }
}

#-------------------------------------------------------------------------------

library(stringr)
library(qdap)
library(NLP)
library(tm)

word_tokens <- function(testing){
        testing <- replace_abbreviation(testing)
        testing <- replace_contraction(testing)
        testing <- tolower(testing)
        testing <- removeNumbers(testing)
        testing <- removePunctuation(testing)
        tokens <- unlist(strsplit(testing," "))
        n <- length(tokens)
        
        if(n==0){return("no word")}
        if(n==1){
                last_word <- word(testing,-1)
                return(c(last_word=last_word))
        }
        if(n==2){
                last_word <- word(testing,-1)
                last_2_words <- paste2(word(testing,-(2:1)), " ")
                return(c(last_word=last_word,
                         last_2_words=last_2_words))
        }
        if(n>=3){
                last_word <- word(testing,-1)
                last_2_words <- paste2(word(testing,-(2:1)), " ")
                last_3_words <- paste2(word(testing,-(3:1)), " ")
                return(c(last_word=last_word,
                         last_2_words=last_2_words,
                         last_3_words=last_3_words))
        }
        
}

#-------------------------------------------------------------------------------

#  word prediction

prediction <- function(x,df_freq_2_gram,df_freq_3_gram,df_freq_4_gram){
        word_input <- word_tokens(x)
        length_word_input <- length(word_input)
        if(length_word_input!=0){
                if(length_word_input==1){
                        return(c(min_1_wordString(word_input[1],df_freq_2_gram)))
                }
                if(length_word_input==2){
                        return(c(min_2_wordString(word_input[2],word_input[1],df_freq_2_gram,df_freq_3_gram)))
                }
                if(length_word_input==3){
                        # return(c("a1","b","c"))
                        return(c(min_3_wordString(word_input[3],word_input[2],word_input[1],df_freq_2_gram,df_freq_3_gram,df_freq_4_gram)))
                }
                
        }#else{return(c("The","To","I"))}
}

