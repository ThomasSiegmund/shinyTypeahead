.onAttach <- function(...) {

  # Create link to javascript and css files for package
  shiny::addResourcePath("typeahead", system.file('typeahead',
                                     package='shinyTypeahead'))

}

shinyBSDep <- htmltools::htmlDependency("shinyTypeahead", packageVersion("shinyTypeahead"),
                                        src = c("href" = "typeahead"),
                                        script = c("bootstrap3-typeahead.js", "typeahead_inputbinding.js"),
                                        stylesheet = "typehead.js-bootstrap3.css");

# Create a typeahead text input
bsTypeAhead <- function(inputId, label, value = "", choices, items=8, minLength=1) {

  choices <- paste0("[\'", paste0(choices, collapse="\', \'") , "\']")

  typeahead <- shiny::tagList(
            shiny::div(class = 'form-group shiny-input-container',
                shiny::tags$label(label, `for` = inputId),
                  shiny::tags$input(id = inputId, type="text",
                             class="form-control shiny-bound-input typeahead",
                             "data-provide" = "typeahead", autocomplete="off",
                             value = value),
                  shiny::tags$script(paste0("$('#", inputId, "').typeahead({source: ", choices, ",
                                                                     items: ", items, ",
                                                                     minLength: ", minLength, "})"))
                  )
          )
  htmltools::attachDependencies(typeahead, shinyBSDep)
}


# Update a typeahead element from server.R
updateTypeAhead <- function(session, inputId, label=NULL, value=NULL, choices=NULL) {

  data <- dropNulls(list(id = inputId, label=label, value=value, choices=choices))
  session$sendCustomMessage("typeaheadUpdate", data)
}


# Copy of dropNulls function for shiny to avoid using shiny:::dropNulls
dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE = logical(1))]
}
