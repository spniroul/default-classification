###Classification for potential defaults########################################
###ML-Example###################################################################
##Import of dataset
##Source: https://www.kaggle.com/datasets/uciml/default-of-credit-card-clients-dataset

##Set Your Directory
#setwd("")

dat <- read.csv("UCI_Credit_Card.csv")

library(tidyverse)
dat <- dat %>%
 mutate_at(vars(1:25), as.numeric) %>% 
 dplyr::select(-ID)
 
##Checking Relationship among variables
summary(lm(`default.payment.next.month`~., data=dat))
   
##Splitting dataset into test and train
set.seed(7)
defaultNumRows <- dim(dat)[1]
defaultTestNumRows <- 5000
   
    
# separate dataset into train and test
test_idx <- sample(x = 1:defaultNumRows, size = defaultTestNumRows)
Default_train <- dat[-test_idx,]
Default_test <- dat[test_idx,]
  
#Fitting Logistic Regression
logistic_default <- glm(`default.payment.next.month`~ ., data=Default_train, 
                                                   family=binomial)
  
#Since in default classification, we want to correctly predict default as much as
#possible, we would want a high specificity value.
   
#Prediction
pred.a <- predict(logistic_default, newdata = Default_test[,(1:23)], type="response")
  
metric_calc <- function(pred.a, testcol, cutoff){
    matrix_comb <- as.matrix(table(pred.a > cutoff, Default_test[,testcol]))
     #Test Error
      print(paste("Test Error:", round((matrix_comb[2,1]+matrix_comb[1,2])/sum(matrix_comb), 4)))
     #Sensitivity
      print(paste("Sensitivity:", round(matrix_comb[2,2]/(matrix_comb[2,2]+matrix_comb[1,2]), 4)))
     #Specificity
      print(paste("Specificity:", round(matrix_comb[1,1]/(matrix_comb[2,1]+matrix_comb[1,1]), 4)))
     #Precision
      print(paste("Precision:", round(matrix_comb[2,2]/(matrix_comb[2,1]+matrix_comb[2,2]), 4)))
     cat("\n")
     }
  
metric_calc(pred.a, "default.payment.next.month", 0.09)
 
  
#ROC Curve
library(ROCR)
roc.default <- prediction(pred.a, Default_test$default)
 
#ROC curve
perf.default <- performance(roc.default, "tpr", "fpr")
plot(perf.default, colorize=TRUE)
  
#AUC values
print("AUC:")
performance(roc.default, measure="auc")@y.values[[1]]

#Using AIC for feature selection
library(MASS)
best_model <- stepAIC(logistic_default, direction="both", trace=FALSE)
selected_features <- names(coef(best_model))
selected_features <- setdiff(selected_features, "(Intercept)")
selected_features

#Dropping non-significant term
new_dat <- dat %>% dplyr::select(all_of(selected_features), default.payment.next.month)
  
Default_train <- new_dat[-test_idx,]
Default_test <- new_dat[test_idx,]
   
#Regression
    
logistic_default <- glm(`default.payment.next.month`~ ., data=Default_train, 
                                                         family=binomial)
round(summary(logistic_default)$coef, dig=4)
  
pred.b <- predict(logistic_default, newdata = Default_test, type="response")
   
metric_calc(pred.b, "default.payment.next.month", 0.2)
 
#ROC Curve
roc.default <- prediction(pred.b, Default_test$default)
#ROC curve
perf.default <- performance(roc.default, "tpr", "fpr")
plot(perf.default, colorize=TRUE)

#Increasing specificity
#Trying with cutoff 0.08
  
metric_calc(pred.b, "default.payment.next.month", 0.08)

################################################################################
################################################################################

  

  
 