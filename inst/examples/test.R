# --------------------------------------------------------
# Minimal shiny app testing the typeahead widget

library(shiny)
library(shinyTypeahead)
data(mtcars)
data(islands)

# ui.R
# --------------------------------------------------------
ui <- shinyUI(fluidPage(
  title = 'shinyTypeahead test app',
  fluidRow(
    textInput('standard', label = "Normal textInput"),
    textOutput("standardoutput"),
    selectInput("choices", "Choices", choices = c("cars", "islands")),
    bsTypeAhead('firstTypeaheadInput', label = "My first typeahead", choices = c("eins", "zwei", "drei")),

    textOutput('firstoutput'),
    bsTypeAhead('secondTypeaheadInput', label = "My second typeahead", choices = 'function () {return ["one", "two", "three"]}'),
    textOutput('secondoutput')
  )
))

# server.R
# --------------------------------------------------------
server <- shinyServer(function(input, output, session) {
  output$standardoutput <- renderText(input$standard)
  output$firstoutput <- renderText(input$firstTypeaheadInput)
  output$secondoutput <- renderText(input$secondTypeaheadInput)

  observe( {
    if(input$choices == "cars") {
      choices <- rownames(mtcars)
    } else if (input$choices == "islands") {
      choices <- names(islands)
    } else {
      choices <- c("eins", "zwei", "drei")
    }

    updateTypeAhead(session, "firstTypeaheadInput", choices = choices);
  })

})


runApp(list(ui=ui,server=server))
