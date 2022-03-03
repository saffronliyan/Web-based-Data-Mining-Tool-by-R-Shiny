library(shiny)


shinyUI(pageWithSidebar(

  # Application title
  headerPanel("ShinyR"),

  sidebarPanel(
    wellPanel(
    tabsetPanel(
    tabPanel("Data",
    #selectInput("Data","Loading a Dataset", choices = c("audit","wine")),
#    submitButton("UpdateData"),
#    helpText("                                                                 "),
#    helpText("Please choose the way of loading dataset"),  
    checkboxInput("library","Use Dataset from Library", TRUE),
    
    helpText("                                                                 "),
    
    conditionalPanel(
    condition = "input.library==true",             
    selectInput("libData", "Data from Library",
                choices = c("audit","wine")),
                #),
   
    radioButtons("target","Set the Target", choices = c("TARGET_Adjusted"="TARGET_Adjusted",
                                                        "PRICE_1991" = "PRICE_1991")),
    
    checkboxGroupInput("inputs","Set the Inputs",c("Gender" = "Gender",
                                              "Education" = "Education",
                                              "VINTAGE_YEAR" = "VINTAGE_YEAR",
                                              "WRAIN" = "WRAIN"),
                                               selected = c("Gender" = "Gender",
                                              "Education" = "Education"))
                ),
    
    conditionalPanel(
    condition = "input.library== false",                
    fileInput("clientData", "Upload Data from Disk or Server:")),        
     
    sliderInput("partition","Partition(%)", 0,100,1,animate = animationOptions(1000, playButton="start",pauseButton="pause")),
             
    numericInput("obs","Numer of Observations",10),
    
    submitButton("Submit")
  ),  
#    tabPanel("Variables",
##    submitButton("UpdateVariables"),
#    
##    helpText("                                                               "),
#    checkboxInput("library2","Use Dataset from Library", TRUE),
#    
#    helpText("                                                                 "),
##    selectInput("target","Set the Target", choices = c("TARGET_Adjusted","PRICE_1991")),
#    conditionalPanel(
#    condition = "input.library2==true",
#    radioButtons("target","Set the Target", choices = c("TARGET_Adjusted"="TARGET_Adjusted",
#                                                        "PRICE_1991" = "PRICE_1991")),
##    radioButtons("inputs","Set the Input1", c("Gender" = "Gender",
##                                              "Education" = "Education",
##                                              "VINTAGE_YEAR" = "VINTAGE_YEAR",
##                                              "WRAIN" = "WRAIN")),
##    
###    selectInput("input1","Select the Input1", choices = c("Gender","Education","VINTAGE_YEAR","WRAIN")),
##    selectInput("input2","Select the Input2", choices = c("Employment","Marital","DEGREES_IN_C","HRAIN")),
#    
#    checkboxGroupInput("inputs","Set the Inputs",c("Gender" = "Gender",
#                                              "Education" = "Education",
#                                              "VINTAGE_YEAR" = "VINTAGE_YEAR",
#                                              "WRAIN" = "WRAIN"),
#                                               selected = c("Gender" = "Gender",
#                                              "Education" = "Education"))
#    ),
#    
#    conditionalPanel(
#    condition = "input.library2==false",
#    fileInput("clientVariables", "Upload Variables from Disk or Server:")
#    ),
#    
#     submitButton("Submit")
#     
#   ), 
   tabPanel("FormulaText",
   textInput("formula","Please Enter Your Own Formula",""),
   helpText("                                                                  "),
   submitButton("Submit")
   ),
    
   tabPanel("Model",
#    submitButton("UpdateModel"),
    
    helpText("                                                               "),
        
    selectInput("model","Select the Model Type", choices = c("Decision Tree","Random Forest", "Boost","SVM","Regression","Neural Net")),
#    radioButtons("model","Select the Model Type", c("Regression","Decision Tree")),
#    conditionalPanel(
#    condition = "input.model ==' ' ",
#    helpText("No Model was Selected."),
#    helpText("                                                               ")),
#    
#    conditionalPanel(
#    condition = "input.model != ' '",
#    helpText("                                                               "),
    
    conditionalPanel(
    condition = "input.model == 'Decision Tree' ",
    textInput("type", "Type of Plot", "0"),
    helpText("Note: type ranges from 0 to 4"),
    textInput("branch", "Type of Branch", "0"),
    helpText("Note: type ranges from 0 to 9"),
    helpText("Note: Some combinations of type and branch might be prohibted based on dataset.")),    

    helpText("                                                                  "),
    
    conditionalPanel(
    condition = "input.model == 'Random Forest' ",
    numericInput("treeSize", "Number of Trees", "500" ),
    numericInput("varNum", "Number of Variables","3")),
    
    helpText("                                                                  "),
    
    conditionalPanel(
    condition = "input.model == 'Boost' ",
    numericInput("boostSize", "Number of Trees","50")),
    
    helpText("                                                                  "),
    
    conditionalPanel(
    condition = "input.model == 'SVM' ",
    selectInput("kernel", "Kelnel Functions", choices = c("rbfdot","polydot",
    "vanilladot", "tanhdot","laplacedot","besseldot","anovadot","splinedot")),
    selectInput("options","SV type", choices = c("C-svc","nu-svc","C-bsvc",
    "spoc-svc","kbb-svc","one-svc","eps-svr",
    "nu-svr","eps-bsvr"))),
    
    helpText("                                                                  "),
    
    conditionalPanel(
    condition = "input.model == 'Neural Net' ",
    selectInput("layer","Skip-layer",choices = c("TRUE", "FALSE")),
    numericInput("nodes", "Hidden layer Nodes", "10")),
    
    submitButton("Submit")
    ),
    
    tabPanel("Export",
    downloadButton("downloadData","Download Data to Disk")
    )))
 ),


  mainPanel(
    

#    h4("DatasetView"),
#    tableOutput("dataset"),

#    
#    h4("Formula"),    
#    h3(textOutput("caption")),
#    
#    h4("Summary"),
#    verbatimTextOutput("summary"),
#
#    h4("Plot"),    
#    plotOutput("auditPlot")
    wellPanel(
     tabsetPanel(
          tabPanel("Welcome",textOutput("welcome")),
          tabPanel("DatasetView",tableOutput("dataset")),
          tabPanel("Variable",  textOutput("caption")),
          tabPanel("Summary",  verbatimTextOutput("summary")),
          tabPanel("Plot", plotOutput("dataPlot") ),
          id = NULL)

   )     
   )

))
