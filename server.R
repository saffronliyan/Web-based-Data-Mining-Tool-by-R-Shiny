library(shiny)

audit<- read.csv("C:\\work\\shinyapp\\audit.csv",header = TRUE)
wine <- read.csv("C:\\work\\shinyapp\\wine_training.csv",header=TRUE)


# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

    datasetInput<- reactive({
     switch(input$libData,
           "audit" = audit,
           "wine" = wine)
     
  })
  
  welcomeText<-reactive({
  
  paste("Welcome to ShinyR!")
  })
  
  output$welcome<-renderText({
  welcomeText()
  })    
  
     
  output$dataset <- renderTable({      
    
    if(input$library ==TRUE)
       dataset <- datasetInput()
#        head(datasetInput(), n = input$partition*0.01*nrow(datasetInput()))
    if(input$library == FALSE)
       dataset<- read.csv(input$clientData[,"datapath"],header = TRUE)
       
       
       head(dataset, n = input$partition*0.01*nrow(dataset))
        
   # ifelse(input$library ==TRUE, head(datasetInput(), n = input$obs), head(dataset, n = input$obs))
  })
  

  output$downloadData <- downloadHandler(
   
       
    filename = function() { 
    if(input$library ==TRUE)
       dataset <- datasetInput()
   if(input$library == FALSE)
       dataset<- read.csv(input$clientData[,"datapath"],header = TRUE) 
    
    paste(dataset, '.csv', sep='') },
    content = function(file) {
      write.csv(dataset, file)
    }
  )


  formulaText <- reactive({
#    dataset <- datasetInput()
if(input$library == TRUE)
 {
  inputs<-input$inputs
  target<-input$target }
  if(input$library == FALSE)
  {
  vars<-  read.csv(input$clientData[,"datapath"],header = TRUE)
  names <- colnames(vars)
  inputs<-names[-length(names)]
  target<- names[length(names)]
  }

inputForm<-paste(inputs[1])
#if(length(inputs)>1)
#   inputForm<-paste(inputForm,"+",inputs[2])
if(length(inputs)>=2){
for ( i in 2:(length(inputs)))
{
   inputForm<-paste(inputForm,"+",inputs[i])
}

}
    paste(target,"~", inputForm)
    
#    input$formula <-  paste(target,"~", inputForm)

  })

  output$caption <- renderText({
    
    formulaText()
  
  })

  output$summary <- renderPrint({
  
  
   if(input$library ==TRUE)     
       { dataset <- datasetInput()
       inputs<-input$inputs
  target<-input$target }
        
   if(input$library == FALSE)
      { dataset<- read.csv(input$clientData[,"datapath"],header = TRUE)
       vars<-  read.csv(input$clientData[,"datapath"],header = TRUE)
  names <- colnames(vars)
  inputs<-names[-length(names)]
  target<- names[length(names)]
  }
  
    if(input$model == "Decision Tree")
    {
         require("rpart")
         summary(rpart(as.formula(input$formula),data = dataset))
    }
    if (input$model == "Random Forest")
    {
        require(randomForest, quietly=TRUE)
#       print(randomForest(as.factor(target) ~.,
      print(randomForest(as.formula(input$formula),
      data=dataset,
      ntree=input$treeSize,
      mtry=input$varNum,
      importance=TRUE,
      na.action=na.roughfix,
      replace=FALSE))
    }
    if(input$model == "Boost")
    {
      require(ada, quietly=TRUE)
      require("rpart") 
      print(ada(as.formula(input$formula),
      data=dataset,
      control=rpart.control(maxdepth=30,
           cp=0.010000,
           minsplit=20,
           xval=10),
      iter=input$boostSize))
      
    }
    if(input$model =="SVM")
    {
       require(kernlab, quietly=TRUE)
#       print(ksvm(as.factor(target) ~ .,
      print(ksvm(as.formula(input$formula),
      data=dataset,
      kernel=input$kernel,
      type = input$options,
      prob.model=TRUE))

    }
    if(input$model == "Neural Net")
    {
     require(nnet, quietly=TRUE)
#     nnet(as.factor(target) ~ .,
    print(nnet(as.formula(input$formula),
    data=dataset,
    size=input$nodes,
    skip=input$layer, MaxNWts=10000, trace=FALSE, maxit=100) ) 
    }
    if(input$model == "Regression")
    {   
         
         summary(lm(as.formula(input$formula),data = dataset)) 
    }
  })
  
  output$dataPlot <- renderPlot({
   if(input$library ==TRUE)     
        dataset <- datasetInput()
   if(input$library == FALSE)
       dataset<- read.csv(input$clientData[,"datapath"],header = TRUE) 

if(input$model == "Decision Tree")
    {
    require(rpart)
    require(rpart.plot)
    
    #dataset <- datasetInput()
    
    tree <- rpart(as.formula(input$formula),
    data = dataset)
    
    cols <- ifelse(tree$frame$yval == 1, "darkred", "green4")
                         # green if survived
    prp(tree,
    type = as.numeric(input$type) ,
    extra= 0,           # display prob of survival and percent of obs
    nn=TRUE,             # display the node numbers
    fallen.leaves=TRUE,  # put the leaves on the bottom of the page
    branch=.5,           # change angle of branch lines
#    faclen=0,            # do not abbreviate factor levels
    trace=1,             # print the automatically calculated cex
    shadow.col="gray",# shadows under the leaves
    branch.type = as.numeric(input$branch),
    branch.lty=1,        # draw branches using dotted lines
    split.cex=1.2,       # make the split text larger than the node text
#    split.prefix="is ",  # put "is " before split text
#    split.suffix="?",    # put "?" after split text
    col=cols, border.col=cols,   # green if survived
    split.box.col="lightgray",   # lightgray split boxes (default is white)
    split.border.col="darkgray", # darkgray border on split boxes
    split.round=.5)    
    }
    if(input$model == "Regression")
    {
       #dataset <- datasetInput() 
    plot(lm(as.formula(input$formula),
    data = dataset))
    }
    })


})
