# ui.R

library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("Randomization table for clinical trials!"),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    # Simple integer interval
    textInput("title", "Set your study title:", "My trial name"),
    numericInput("ncases", label = "Total number of patients:", value = 60),
    numericInput("seed", label = "Set your secret passcode:", value = 12345),
    selectInput("branches", "Number of branches:", 
                choices = c("2", "3")),  
    textInput("tta", "Name your first branch:", "First branch"),
    textInput("ttb", "Name your second branch:", "Second branch"),
    conditionalPanel(
      condition = "input.branches == 3",
      textInput("ttc", "Name your third branch:", "Third branch")),
    textOutput("text1"),
    textOutput("text2"),
    textOutput("text3"),
    textOutput("version"),
    helpText("Random table for blind clinical trials. 
             Written in R/Shiny by A. Baluja."),
    downloadButton('downloadChave', 'Download PIN table'),
    downloadButton('downloadData', 'Download random table')
  ),
  
  # Show a table summarizing the values entered
  mainPanel(
    div(dataTableOutput("randChave"), style = "font-size:80%"),
    div(dataTableOutput("randTable"), style = "font-size:80%")
  )
)
) 

# To execute this script from inside R, you need to have the ui.R and server.R files into the session's working directory. Then, type:
# runApp()
# To execute directly this Gist, from the Internet to your browser, type:
# shiny:: runGist(' ')
