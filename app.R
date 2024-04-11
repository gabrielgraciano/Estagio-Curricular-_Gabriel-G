#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
data(penguins, package = "palmerpenguins")

cards <- list(
  card(
    full_screen = TRUE,
    card_header("Sem Filtro"),
    plotOutput("bill_length")
  ),
  card(
    full_screen = TRUE,
    card_header("Sexo"),
    plotOutput("bill_depth")
  ),
  card(
    full_screen = TRUE,
    card_header("Faixa Etária"),
    plotOutput("body_mass")
  ),
  card(
    full_screen = TRUE,
    card_header('Ambos')
    )
)

color_by <- varSelectInput(
  "color_by", "Color by",
  penguins[c("species", "island", "sex")],
  selected = "species"
)

ui <- page_sidebar(
  title = "Penguins dashboard",
  sidebar = color_by,
  navset_card_underline(
    title = "Histograms by species",
    nav_panel('oi', cards[[1]]),
    nav_panel('a', cards[[2]]),
    nav_panel('b', cards[[3]]),
    nav_panel('c', cards[[4]])
  )
)



server <- function(input, output) {
  gg_plot <- reactive({
    ggplot(penguins) +
      geom_density(aes(fill = !!input$color_by), alpha = 0.2) +
      theme_bw(base_size = 16) +
      theme(axis.title = element_blank())
  })
  
  output$bill_length <- renderPlot(gg_plot() + aes(bill_length_mm))
  output$bill_depth <- renderPlot(gg_plot() + aes(bill_depth_mm))
  output$body_mass <- renderPlot(gg_plot() + aes(body_mass_g))
}

shinyApp(ui, server)