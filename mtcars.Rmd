---
title       : mtcarsApp1
subtitle    : Playing With 'mtcars' Data Model
author      : karbalas
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Introduction to my application

This shiny app that I have developed is based on the data `mtcars`. This is part of the samples that comes with the `datasets` library. 

Using this data set, I created a prediction algorithm to predict the miles per gallon (`mpg`) for a vehicle with the selected values for predictors:
- `wt` : weight of the vehicle
- `cyl` : number of engine cylinders and 
- `hp` : horse power of the engine. 

Though other predictors might have influence on the `mpg` of a vehicle, to keep the model simple, I chose only the 3 mentioned here.

--- .class #id 

## Application specific details

The shinyUI displays a set of input slider selections for the 3 predictors mentioned in earlier slide. Based on the user selection of the predictors, sends the information to server.r to predict the outcome and to render the histogram of the `mpg` plot along with the predicted value `mu` and the error in terms of `MSE` (mean squared error).

The shinyServer gets the input values, applies them to the prediction model to calculate the miles per gallon for selected predictor values. Then it generates the histogram of the `mpg` and predicted value `mu` and also calculates the error in terms of `MSE` (mean sqared error) and displays in the plot. This plot is then sent to the ui.r for final rendering.

--- .class #id 

## User interface
`ui.r`

```
library(shiny)
shinyUI(
    pageWithSidebar(
        headerPanel("Playing With 'mtcars' Data Model"), sidebarPanel(
            sliderInput('wt', 'Guess at the weight(wt)',value = 3, min = 1, max = 5.5, step = 0.5,), sliderInput('cyl', 'Guess for the cylinders(cyl)',value = 4, min = 2, max = 8, step = 2,), sliderInput('hp', 'Guess at the horsepower(hp)',value = 150, min = 50, max = 300, step = 50,)
        ), mainPanel(
            h3("Results of prediction"), h4("Weight (wt) selected: "),
            verbatimTextOutput("wtIn"), h4("Cylinders (cyl) selected: "),
            verbatimTextOutput("cylIn"), h4("HorsePower (hp) selected: "),
            verbatimTextOutput("hpIn"), plotOutput('wtHist')
        ) ) )
```  

--- .class #id 

## Server side
`server.r`

```  
library(shiny); library(datasets); data(mtcars)  
mpgPred <- function(mydata) predict(train(mpg ~ cyl+wt+hp, data=mtcars, method="lm"),newdata=mydata) 
shinyServer(  function(input, output) {  
    output$wtIn <- renderPrint({input$wt}); output$hpIn <- renderPrint({input$hp})  
    output$cylIn <- renderPrint({input$cyl}); 
    output$wtHist <- renderPlot({  
        hist(mtcars$mpg, xlab='Miles per gallon (mpg)', col='lightblue',main='Histogram'); mydata <- data.frame(wt = input$wt, hp = input$hp, cyl = input$cyl)
        mu <- mpgPred (mydata); lines(c(mu, mu), c(0, 20),col="red",lwd=5)  
        mse <- mean((mtcars$mpg - mu)^2); text(30, 12, paste("mu = ", round(mu, 2)))  
        text(30, 10, paste("MSE = ", round(mse, 2))) })  
    }      
)  
```    
