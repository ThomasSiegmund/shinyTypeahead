.onAttach <- function(...) {

  # Create link to javascript and css files for package
  shiny::addResourcePath("typeahead", system.file('typeahead',
                                     package='shinyTypeahead'))

}




# # Wrapper to add the appropriate singletons to the head of the shiny app
# sbsHead <- function(...) {
#
#   tagList(singleton(tags$head(tags$script(src = "shinyTypeahead/bootstrap3-typeahead.js"),
#                               tags$link(rel = "stylesheet", type = "text/css", href = "sbs/shinyBS.css"))),
#           ...
#   )
# }
#
#

# Wrapper to add the appropriate singletons to the head of the shiny app
sbsHead <- function(...) {

  shiny::tagList(singleton(tags$head(tags$script(src = "shinyTypeahead/bootstrap3-typeahead.js"),
                            tags$link(rel = "stylesheet", type = "text/css", href = "shinyTypeahead/typehead.js-bootstrap3.css")

                                     )),
          ...
  )
}




# Create a typeahead text input
bsTypeAhead <- function(inputId, label, value = "", choices, items=8, minLength=1) {

    shiny::addResourcePath(
    prefix='shinyTypeahead',
    directoryPath=system.file('typeahead',
                              package='shinyTypeahead'));

  choices <- paste0("[\'", paste0(choices, collapse="\', \'") , "\']")

  sbsHead(shiny::tagList(
            shiny::div(class = 'form-group shiny-input-container',
            tags$label(label, `for` = inputId),
                  tags$input(id = inputId, type="text",
                             class="form-control shiny-bound-input typeahead sbs-typeahead",
                             "data-provide" = "typeahead", autocomplete="off",
                             value = value),
                  tags$script(paste0("$('#", inputId, "').typeahead({source: ", choices, ",
                                                                     items: ", items, ",
                                                                     minLength: ", minLength, "})"))
                  )
          )
  )


}


# Update a typeahead element from server.R
updateTypeAhead <- function(session, inputId, label=NULL, value=NULL, choices=NULL) {

  data <- dropNulls(list(label=label, value=value, choices=choices))

  session$sendInputMessage(inputId, data)

}
