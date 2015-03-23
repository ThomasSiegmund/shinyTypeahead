# --------------------------------------------------------
# Minimal shiny app testing the typeahead widget

library(shiny)
library(shinyTypeahead)
library(shinythemes)
library(randomNames)

data(mtcars)
data(islands)
rNames <- randomNames(131370) # max number of allowed choices 2 ^ 17 - 2

# ui.R
# --------------------------------------------------------
ui <- shinyUI(fluidPage(theme = shinytheme("journal"),
  title = 'shinyTypeahead test app',
  fluidRow(
    textInput('standard', label = "Normal textInput"),
    textOutput("standardoutput"),
    selectInput("choices", "Choices", choices = c("cars", "islands")),
    typeaheadInput('firstTypeaheadInput', label = "Updatable", choices = ""),

    textOutput('firstoutput'),

    # see: http://tatiyants.com/how-to-use-json-objects-with-twitter-bootstrap-typeahead/
    typeaheadInput('secondTypeaheadInput', label = "JavaScript generated", choices = htmlwidgets::JS('function (query, process) { states = ["California", "Arizona", "New York", "Nevada", "Ohio"];
    process(states);}')),
    textOutput('secondoutput'),
    typeaheadInput('thirdTypeaheadInput', label = "Random names", choices = rNames, items = 20),
    textOutput('thirdoutput')

  )
))

# server.R
# --------------------------------------------------------
server <- shinyServer(function(input, output, session) {
  output$standardoutput <- renderText(input$standard)
  output$firstoutput <- renderText(input$firstTypeaheadInput)
  output$secondoutput <- renderText(input$secondTypeaheadInput)
  output$thirdoutput <- renderText(input$thirdTypeaheadInput)

  observe( {
    if(input$choices == "cars") {
      choices <- rownames(mtcars)
    } else if (input$choices == "islands") {
      choices <- names(islands)
    } else {
      choices <- c("eins", "zwei", "drei")
    }

    updateTypeaheadInput(session, "firstTypeaheadInput", value = '', choices = choices);
  })

})


runApp(list(ui=ui,server=server))
