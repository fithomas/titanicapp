#

library(shiny)

shinyServer(function(input, output) {
  
  library(datasets)
  library(rpart)
  library(titanic)
  library(rpart.plot)
  
  smp_size <- floor(0.75 * nrow(titanic_train))
  
  ## set the seed to make your partition reproductible
  set.seed(123)
  train_ind <- sample(seq_len(nrow(titanic_train)), size = smp_size)
  
  train <- titanic_train[train_ind, ]
  test <- titanic_train[-train_ind, ]
  
  output$titanicdata <- DT::renderDataTable(
    DT::datatable(train, options = list(pageLength = 25))
  )
  
  output$titanictestdata <- DT::renderDataTable(
    DT::datatable(test, options = list(pageLength = 25))
  )
  
  fit <- eventReactive(input$trainModel, {
    rpart(Survived ~ ., data=train[,names(train) %in% c("Survived",input$variables)], method="class")
  })
  
  output$trainResult <- renderPlot({
    f<-fit()
    rpart.plot(f,type=1,extra=2)
  })
  
  output$testResult <- renderText({
    preds <- predict(fit(), newdata = test, type = c("class"))
    cm<-confusionMatrix(test$Survived,preds)
    paste(capture.output(cm),collapse="<br>")
  })

})
