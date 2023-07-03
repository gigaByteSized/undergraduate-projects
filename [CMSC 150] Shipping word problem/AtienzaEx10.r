#
  # ** Name: Jonas R. Atienza
  # ** Lab Section: AB-3L
  # ** Program Description: This program implements a web application with a user interface for both exercises 8 and 9 # nolint
#

library(shiny)
library(gridlayout)
library(DT)

source("AtienzaEx08.R")
source("AtienzaEx09.R")
source("RegexHelper.R")

constraints <- list()

ui <- grid_page(
  layout = c(
    "header  header  header  header ",
    "sidebar sidebar sidebar sidebar",
    "sidebar sidebar sidebar sidebar"
  ),
  row_sizes = c(
    "75px",
    "2fr",
    "0.3fr"
  ),
  col_sizes = c(
    "415px",
    "1fr",
    "0.59fr",
    "1.41fr"
  ),
  gap_size = "1rem",
  grid_card_text(
    area = "header",
    content = "Exercise 10: Integration",
    alignment = "center",
    is_title = TRUE
  ),
  grid_card(
    area = "sidebar",
    tabsetPanel(
      tabPanel(
        title = "poly.qsi",
        grid_container(
          layout = c(
            "baseMatOut baseMatOut baseMatOut resultantMatOut",
            "baseMatOut baseMatOut baseMatOut resultantMatOut",
            "input      input      yInput     fxnOutQsi      ",
            "input2     input2     qsiButton  fxnOutQsi      ",
            "input2     input2     qsiButton  yOutQsi        ",
            ".          .          .          .              "
          ),
          row_sizes = c(
            "1fr",
            "1fr",
            "1fr",
            "0.29fr",
            "1fr",
            "1.71fr"
          ),
          col_sizes = c(
            "0.6fr",
            "0.43fr",
            "0.92fr",
            "2.05fr"
          ),
          gap_size = "10px",
          grid_card(
            area = "baseMatOut",
            scrollable = TRUE,
            DTOutput(
              outputId = "baseMat",
              width = "100%"
            )
          ),
          grid_card(
            area = "resultantMatOut",
            scrollable = TRUE,
            DTOutput(
              outputId = "resultantMat",
              width = "100%"
            )
          ),
          grid_card(
            area = "input",
            textInput(
              inputId = "qsiXInput",
              label = "x",
              value = "",
              width = "100%"
            )
          ),
          grid_card(
            area = "input2",
            textInput(
              inputId = "qsiYInput",
              label = "f(x)",
              value = "",
              width = "100%"
            )
          ),
          grid_card(
            area = "yInput",
            numericInput(
              inputId = "qsiValToApprox",
              label = "Value of x to approximate y at",
              value = 0L,
              step = 0.1
            )
          ),
          grid_card(
            area = "qsiButton",
            actionButton(
              inputId = "qsiSubmitBtn",
              label = "Submit",
              width = "100%"
            )
          ),
          grid_card(
            area = "fxnOutQsi",
            uiOutput(outputId = "qsiFxnsOut")
          ),
          grid_card(
            area = "yOutQsi",
            textOutput(outputId = "qsiApproxOut")
          )
        )
      ),
      tabPanel(
        title = "simplex",
        grid_container(
          layout = c(
            "simplexObjectiveFunction simplexObjectiveFunction tableOut",
            "simplexConstraints       simplexButtons           tableOut",
            "simplexConstraints       simplexButtons           tableOut",
            "simplexConstraints       simplexButtons           textOut ",
            "simplexConstraints       simplexButtons           textOut "
          ),
          row_sizes = c(
            "1fr",
            "0.75fr",
            "1.28fr",
            "0.72fr",
            "1.25fr"
          ),
          col_sizes = c(
            "0.85fr",
            "0.36fr",
            "1.79fr"
          ),
          gap_size = "10px",
          grid_card(
            area = "simplexButtons",
            actionButton(
              inputId = "simplexAddBtn",
              label = "Add 1 Constraint",
              width = "100%"
            ),
            actionButton(
              inputId = "simplexRmBtn",
              label = "Remove 1 Constraint",
              width = "100%"
            ),
            radioButtons(
              inputId = "simplexOperation",
              label = "Operation",
              choices = list(
                Maximize = "simplexMax",
                Minimize = "simplexMin"
              ),
              width = "100%"
            ),
            actionButton(
              inputId = "simplexSubmitBtn",
              label = "Submit",
              width = "100%"
            )
          ),
          grid_card(
            area = "simplexObjectiveFunction",
            textInput(
              inputId = "simplexZ",
              label = "Objective Function",
              value = "",
              width = "200%"
            )
          ),
          grid_card(
            area = "simplexConstraints",
            scrollable = TRUE,
            uiOutput(outputId = "simplex.Constraints")
          ),
          grid_card(
            area = "tableOut",
            scrollable = TRUE,
            DTOutput(
              outputId = "tableau",
              width = "100%"
            )
          ),
          grid_card(
            area = "textOut",
            textOutput(outputId = "basicSoln"),
            textOutput(outputId = "optVal")
          )
        )
      ),
      tabPanel(
        title = "simplex (problem)",
        grid_container(
          layout = c(
            "simplexPObjectiveFunction simplexPObjectiveFunction tableOutP tableOutP     ", # nolint
            "simplexPConstraints       simplexPButtons           tableOutP tableOutP     ", # nolint
            "simplexPConstraints       simplexPButtons           textOutP  shippingNumOut", # nolint
            "simplexPConstraints       simplexPButtons           textOutP  shippingNumOut" # nolint
          ),
          row_sizes = c(
            "0.8fr",
            "1.1fr",
            "1.39fr",
            "1.26fr"
          ),
          col_sizes = c(
            "1fr",
            "0.4fr",
            "1.4fr",
            "1.2fr"
          ),
          gap_size = "10px",
          grid_card(
            area = "simplexPButtons",
            actionButton(
              inputId = "simplexPAddBtn",
              label = "Add 1 Constraint",
              width = "100%"
            ),
            actionButton(
              inputId = "simplexPRmBtn",
              label = "Remove 1 Constraint",
              width = "100%"
            ),
            radioButtons(
              inputId = "simplexPOperation",
              label = "Operation",
              choices = list(
                Maximize = "simplexMax",
                Minimize = "simplexMin"
              ),
              width = "100%"
            ),
            actionButton(
              inputId = "simplexPSubmitBtn",
              label = "Submit",
              width = "100%"
            )
          ),
          grid_card(
            area = "simplexPObjectiveFunction",
            textInput(
              inputId = "simplexPZ",
              label = "Objective Function",
              value = "",
              width = "200%"
            )
          ),
          grid_card(
            area = "simplexPConstraints",
            scrollable = TRUE,
            uiOutput(outputId = "simplex.PConstraints")
          ),
          grid_card(
            area = "tableOutP",
            scrollable = TRUE,
            DTOutput(
              outputId = "tableauP",
              width = "100%"
            )
          ),
          grid_card(
            area = "textOutP",
            textOutput(outputId = "basicSolnP"),
            textOutput(outputId = "optValP")
          ),
          grid_card(
            area = "shippingNumOut",
            scrollable = TRUE,
            DTOutput(
              outputId = "shippingNum",
              width = "100%"
            )
          )
        )
      )
    )
  )
)

server <- function(input, output) {
  # For poly.qsi tab

  observeEvent(input$qsiSubmitBtn, {
    if (input$qsiXInput == "" || input$qsiYInput == ""){
      # Do nothing if x and y vec is empty
    } else {
      # Split the string inputs delimited with "," and unlist it as a numerical vector  # nolint
      tempX <- as.numeric(unlist(strsplit(input$qsiXInput, ",")))
      tempY <- as.numeric(unlist(strsplit(input$qsiYInput, ",")))

      if (length(tempX) != length(tempY) || (input$qsiValToApprox < min(tempX) || input$qsiValToApprox > max(tempX))) { # nolint
        # If values are out of bounds, reset output
        output$qsiFxnsOut <- renderUI({ })
        output$qsiApproxOut <- renderText({ "Values out of bounds!" })
      } else{
        # Perform quadratic spline interpolation and assign it to z
        z <- poly.qsi(list(tempX,tempY), input$qsiValToApprox)
        # Print qsi fxns
        print(z$baseMat)
        print(z$newMat)
        output$baseMat <- renderDataTable({ round(z$baseMat, 4) })
        output$resultantMat <- renderDataTable({ round(z$newMat, 4) })
        output$qsiFxnsOut <- renderUI({ HTML(paste(z$qsi.fxns, sep = '<br/>', collapse = "<br/>")) }) # nolint
        output$qsiApproxOut <- renderText({ paste("y =", round(z$y, 4)) })
      }
    }
  })


  # For simplex tab
  # Track the number of input boxes to render
  counter <- reactiveValues(n = 0)

  #Track the number of input boxes previously
  prevcount <- reactiveValues(n = 0)

  observeEvent(input$simplexAddBtn, {
        counter$n <- counter$n + 1
        prevcount$n <- counter$n - 1})

  observeEvent(input$simplexRmBtn, {
    if (counter$n > 0) {
      counter$n <- counter$n - 1 
      prevcount$n <- counter$n + 1
    }
  })

  output$counter <- renderPrint(print(counter$n))

  textboxes <- reactive({

    n <- counter$n

    if (n > 0) {
      # If the no. of textboxes previously where more than zero, then
      #save the text inputs in those text boxes
      if (prevcount$n > 0) {
         vals <- c()
        if(prevcount$n > n){
          lesscnt <- n
          isInc <- FALSE
        }else{
          lesscnt <- prevcount$n
          isInc <- TRUE
        }
        for(i in 1:lesscnt){
          inpid <- paste0("simplex_constraint",i)
         vals[i] <- input[[inpid]]
        }
        if(isInc){
          vals <- c(vals, "")
        }
        lapply(seq_len(n), function(i) {
          textInput(inputId = paste0("simplex_constraint", i),
                    label = paste0("Constraint ", i), value = vals[i])
        })
      }else{
        lapply(seq_len(n), function(i) {
          textInput(inputId = paste0("simplex_constraint", i),
                    label = paste0("Constraint ", i), value = "")
        })
      }
    }
  })

  output$simplex.Constraints <- renderUI({ textboxes() })

  observeEvent(input$simplexSubmitBtn, {
    temp <- c()
    colnames <- c()
    rownames <- c()

    for (i in 1:counter$n) {
      if (input[[paste0("simplex_constraint", i)]] != "") {
        if (i == 1) {
          if (input$simplexOperation == "simplexMax") temp <- regexTransform(input[[paste0("simplex_constraint",i)]], TRUE) # nolint
          else temp <- regexTransform(input[[paste0("simplex_constraint",i)]], FALSE) # nolint
        } else {
          if (input$simplexOperation == "simplexMax"){
            temp <- rbind(temp, regexTransform(input[[paste0("simplex_constraint",i)]], TRUE)) # nolint
          } else{
            temp <- rbind(temp, regexTransform(input[[paste0("simplex_constraint",i)]], FALSE)) # nolint
          }
        }
      }
    }

    for(i in 1:nrow(temp)) {
      rownames <- append(rownames, paste0("c", i))
    }

    row.names(temp) <- rownames
    if (input$simplexOperation == "simplexMax") {
      Z <- regexTransform(input$simplexZ, TRUE)
      temp <- rbind(temp, Z)
    } else {
      Z <- regexTransform(input$simplexZ, FALSE)
      temp <- rbind(temp, Z)
    }

    tempColNames <- c()
    for (i in 1:(length(Z))) {
      if (i == length(Z)) tempColNames <- append(tempColNames, "solutions")
      else tempColNames <- append(tempColNames, paste0("x",i))
    }
    colnames(temp) <- tempColNames

    if (input$simplexOperation == "simplexMax") {
      isMax <- TRUE
    } else{
      isMax <- FALSE
    }

    simplexOut <- simplex(temp, isMax, FALSE)

    if (is.character(simplexOut) || identical(simplexOut, "No feasible solution!")) { # nolint
      output$tableau <- renderDataTable({ })
      output$basicSoln <- renderText({ "No feasible solution" })
      output$optVal <- renderText({ })
    } else {
      baseRow <- simplexOut$final.tableau[nrow(simplexOut$final.tableau),]
      baseRow <- baseRow[-(length(baseRow))]
      names(baseRow)[length(baseRow)] <- "Z"
      baseRow <- names(baseRow)
      output$tableau <- renderDataTable({round(simplexOut$final.tableau, 4)})

      solnOut <- "Basic Solution: "
      for (i in 1:length(simplexOut$basic.solution)) {
        if (i == length(simplexOut$basic.solution)) solnOut <- paste(solnOut, baseRow[i], " = ", round(simplexOut$basic.solution[i], 4), sep = "") # nolint
        else solnOut <- paste(solnOut, baseRow[i], " = ", round(simplexOut$basic.solution[i], 4), "  |  ", sep = "") # nolint
      }
      output$basicSoln <- renderText({solnOut})
      if (input$simplexOperation == "simplexMax") {
        optValOut <- paste0("Maximum value = ", round(simplexOut$opt.val, 4))
      } else{
        optValOut <- paste0("Minimum value = ", round(simplexOut$opt.val, 4))
      }
      output$optVal <- renderText({optValOut})
    }
  })

  # For simplex problem tab
  # Track the number of input boxes to render
  counterP <- reactiveValues(n = 0)
  #Track the number of input boxes previously
  prevcountP <- reactiveValues(n = 0)

  observeEvent(input$simplexPAddBtn, {
        counterP$n <- counterP$n + 1
        prevcountP$n <- counterP$n - 1})

  observeEvent(input$simplexPRmBtn, {
    if (counterP$n > 0) {
      counterP$n <- counterP$n - 1
      prevcountP$n <- counterP$n + 1
    }

  })

  output$counterP <- renderPrint(print(counterP$n))

  textboxesP <- reactive({

    n <- counterP$n

    if (n > 0) {
      # If the no. of textboxes previously where more than zero, then
      #save the text inputs in those text boxes
      if (prevcountP$n > 0) {
        vals <- c()
        if (prevcountP$n > n) {
          lesscnt <- n
          isInc <- FALSE
        } else {
          lesscnt <- prevcountP$n
          isInc <- TRUE
        }

        for (i in 1:lesscnt) {
          inpid <- paste0("simplexP_constraint",i)
         vals[i] <- input[[inpid]]
        }
        if(isInc){
          vals <- c(vals, "")
        }

        lapply(seq_len(n), function(i) {
          textInput(inputId = paste0("simplexP_constraint", i),
                    label = paste0("Constraint ", i), value = vals[i])
        })

      } else {
        lapply(seq_len(n), function(i) {
          textInput(inputId = paste0("simplexP_constraint", i),
                    label = paste0("Constraint ", i), value = "")
        })
      }
    }
  })

  output$simplex.PConstraints <- renderUI({ textboxesP() })

  observeEvent(input$simplexPSubmitBtn,{
    temp <- c()
    colnames <- c()
    rownames <- c()

    for (i in 1:counterP$n) {
      if (input[[paste0("simplexP_constraint",i)]] != "") {
        if(i == 1){
          if (input$simplexPOperation == "simplexMax") temp <- regexTransform(input[[paste0("simplexP_constraint",i)]], TRUE) # nolint
          else temp <- regexTransform(input[[paste0("simplexP_constraint",i)]], FALSE) # nolint
        } else {
          if (input$simplexPOperation == "simplexMax"){
            temp <- rbind(temp, regexTransform(input[[paste0("simplexP_constraint",i)]], TRUE)) # nolint
          } else{
            temp <- rbind(temp, regexTransform(input[[paste0("simplexP_constraint",i)]], FALSE)) # nolint
          }
        }
      }
    }

    for(i in 1:nrow(temp)){
      rownames <- append(rownames, paste0("c", i))
    }

    row.names(temp) <- rownames
    if (input$simplexPOperation == "simplexMax"){
      Z <- regexTransform(input$simplexPZ, TRUE)
      temp <- rbind(temp, Z)
    } else{
      Z <- regexTransform(input$simplexPZ, FALSE)
      temp <- rbind(temp, Z)
    }

    tempColNames <- c()
    for(i in 1:(length(Z))){
      if (i == length(Z)) tempColNames <- append(tempColNames, "solutions")
      else tempColNames <- append(tempColNames, paste0("x",i))
    }
    colnames(temp) <- tempColNames

    if (input$simplexPOperation == "simplexMax"){
      isMax <- TRUE
    } else{
      isMax <- FALSE
    }

    simplexOut <- simplex(temp, isMax, TRUE)

    if (is.character(simplexOut) || identical(simplexOut, "No feasible solution!")) { # nolint
      output$tableauP <- renderDataTable({})
      output$shippingNum <- renderDataTable({})
      output$basicSolnP <- renderText({"No feasible solution"})
      output$optValP <- renderText({})
    } else {
      baseRow <- simplexOut$final.tableau[nrow(simplexOut$final.tableau),]
      baseRow <- baseRow[-(length(baseRow))]
      names(baseRow)[length(baseRow)] <- "Z"
      baseRow <- names(baseRow)
      output$tableauP <- renderDataTable({round(simplexOut$final.tableau, 4)})
      output$shippingNum <- renderDataTable({round(simplexOut$shipping.num, 4)})
      solnOut <- "Basic Solution: "
      for(i in 1:length(simplexOut$basic.solution)){
        if (i == length(simplexOut$basic.solution)) solnOut <- paste(solnOut, baseRow[i], " = ", round(simplexOut$basic.solution[i], 4), sep = "") # nolint
        else solnOut <- paste(solnOut, baseRow[i], " = ", round(simplexOut$basic.solution[i], 4), "  |  ", sep = "") # nolint
      }
      output$basicSolnP <- renderText({ solnOut })
      if (input$simplexOperation == "simplexMax") {
        optValOut <- paste0("Maximum value = ", round(simplexOut$opt.val, 4))
      } else{
        optValOut <- paste0("Minimum value = ", round(simplexOut$opt.val, 4))
      }
      output$optValP <- renderText({ optValOut })
    }
  })

} 

shinyApp(ui, server)