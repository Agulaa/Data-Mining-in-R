library(shiny)
library(ECharts2Shiny)
library(caret)
library(rpart)



shinyServer(function(input, output, session) {
  
  titanic <- read.table("titanic.csv", header = TRUE, sep = ",")
  df<- na.omit(titanic)
  columns <- c(3,5,6)
  df[columns]
  df$Sex <- as.character(df$Sex)
  df$Age <- as.integer(df$Age)
  columns <- c(3,5,6)
  X <- df[columns]
  y <- df[2]
  y$Survived <- as.factor(y$Survived )
  
  #schemat uczenia 
  ctrl <- trainControl(
    # powtórzona ocena krzyżowa
    method = "repeatedcv",
    # liczba podziałów
    number = 5,
    # liczba powtórzeń
    repeats = 5)
  
  set.seed(23)
  grid <- expand.grid(.cp = c(0.0005, 0.001, 0.005)) 
  classifier_cart <- train(x = X, y=y[,1], 
                           method = "rpart",
                           trControl = ctrl,
                           tuneGrid = grid)
  
  
  Pclass <- c(as.integer(1))
  Sex <- c(as.character("female"))
  Age <- c(as.integer(45))
  row <- data.frame(Pclass, Sex, Age)
  y_pred <- predict(classifier_cart, newdata = row, type="prob")
  print(y_pred)
  
  
  observeEvent(input$submit, {

    
    dat <- reactive({
      
      Age <- c(as.integer(input$age))
      Pclass <- c(as.integer(input$class))
      Sex <- c(as.character(input$sex))
      row <- data.frame(Pclass, Sex, Age)
      y_pred <- predict(classifier_cart, newdata = row, type="prob")
      
      pred_0 <- as.numeric(y_pred[1])
      pred_1 <- as.numeric(y_pred[2])

      dat <- c(rep("Yes", pred_1*100),rep("No", pred_0*100))
    })
    
    # Call functions from ECharts2Shiny to render charts
    renderPieChart(div_id = "plot",
                   data = dat(),
                   radius = "70%",center_x = "50%", center_y = "50%")
    
    
          
  })
      
      

  
})