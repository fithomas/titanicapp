
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(DT)
library(datasets)
library(rpart)
library(titanic)
library(rpart.plot)
library(caret)
library(e1071)

shinyUI(
  navbarPage(title="Titanic Survivor Analysis!",
             tabPanel("Description",
                      h3("How to use the app:"),
                      p("In this application you can train a decision tree on different variables of the titanic dataset.
                        Please see https://github.com/paulhendricks/titanic for more details on the dataset."),
                      br(),
                      p("You can have a look on the datasets for training and testing at the respective tabs."),
                      br(),
                      p("At the prediction tab you can select different variables that should be used in the prediction. 
                        The model is then automatically validated against a test set. With the app you can evaluate easily
                        how different variable selections influence the accuracy on the testset.")
             ),
             tabPanel("Training Dataset",
                      DT::dataTableOutput('titanicdata')
             ),
             tabPanel("Test Dataset",
                      DT::dataTableOutput('titanictestdata')
             ),
             tabPanel("Prediction",
                    sidebarLayout(
                        sidebarPanel(
                          selectInput('variables', 'Select variables for prediction', names(titanic_train)[c(3,5,6,7,8,10,12)], multiple=TRUE, selectize=FALSE),
                          actionButton("trainModel","Train and test the model")
                        ),
                        mainPanel(
                          h3("Trained Decision Tree"),
                          plotOutput("trainResult"),
                          h3("Test"),
                          htmlOutput("testResult")
                        )
                      )
             )
  
))
