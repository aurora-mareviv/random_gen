# server.R

shinyServer(function(input, output) {
  
  f <- function(seed, ncases, branches){
    set.seed(seed)
    branch <- branches
    if(branch==2){ # table creation
      rond1 <- round(ncases/2, 0)
      rond2 <- ncases-rond1
      
      patient <- seq(1:ncases)
      code <- paste("P", patient, sep="")
      patient <- paste("patient", patient, sep="")
      treatment <- c(rep("group 1", rond1), rep("group 2", rond2))
      order <- seq(1:ncases)
    }
    if(branch==3){ # table creation
      rond1 <- round(ncases/3, 0)
      rond2 <- rond1
      rond3 <- ncases-(rond1+rond2)    
      patient <- seq(1:ncases)
      code <- paste("P", patient, sep="")
      patient <- paste("patient", patient, sep="")
      treatment <- c(rep("group 1", rond1), rep("group 2", rond2), rep("group 3", rond3))
      order <- seq(1:ncases)
    }
    random.0 <- data.frame(patient, code, treatment, order)   
    random.1 <- transform(random.0, treatment = sample(treatment)) # here goes the randomisation (sampling the treatment column)
    random.1 
  }
  
  g <- function(seed, branches){
    set.seed(seed)
    branch <- branches
    if(branch==2){ # table creation
      Treatment.Key <- c(paste(input$tta), paste(input$ttb))
      Group <- c("group 1", "group 2")
    }
    if(branch==3){ # table creation
      Treatment.Key <- c(paste(input$tta), paste(input$ttb), paste(input$ttc))
      Group <- c("group 1", "group 2", "group 3")
    }
    chave <- data.frame(Treatment.Key, Group)
    chave.rand <- transform(chave, Group = sample(Group)) # here goes the randomisation (sampling the Group column)
    names(chave.rand)[1] <- paste("Treatment.PIN_is_", seed, sep="")
    chave.rand
  }
  
  
  mydata <- reactive(f(input$seed,
                       input$ncases,
                       input$branches))
  
  mydatachave <- reactive(g(input$seed,
                            input$branches))
  
  #   Show the final calculated values from RAND table
  
  output$randTable <- renderDataTable(
    {mydata <- f(input$seed,
                 input$ncases,
                 input$branches)
    mydata}
  )
  
  output$randChave <- renderDataTable(
    {mydatachave <- g(input$seed,
                      input$branches)
    mydatachave},
    options = list(searching = FALSE, paging = FALSE, caption = 'Table 1: This is it')
  )
  
  output$text1 <- renderText({ 
    paste("This is a randomization table for a study involving ",
          input$ncases,
          " patients and ",
          input$branches,
          " branches of treatment.",
          sep="")
  })  
  
  output$text2 <- renderText({ 
    paste("- The treatment PIN table can be used to mask treatments when the group allocation must be unblinded (e.g. for data analysis).",
          sep="")   
  })
  
  output$text3 <- renderText({ 
    paste("- The random table assigns patients to the ", input$branches, " branches/groups.",
          sep="")   
  })
  
  info <- sessionInfo() 
  output$version <- renderText({ 
    paste(info$R.version[c(13, 2)]$version.string, info$R.version[c(13, 2)]$arch,
          sep=", ")   
  })
  
  output$downloadChave <- downloadHandler(
    filename = function() { paste(input$title, 'treatment_allocation_PIN.csv', sep='-') },
    content = function(file) {
      write.csv(mydatachave(), file, na="")
    }
  )
  
  output$downloadData <- downloadHandler(
    filename = function() { paste(input$title, 'random_table.csv', sep='-') },
    content = function(file) {
      write.csv(mydata(), file, na="")
    }
  )
  
  
})
