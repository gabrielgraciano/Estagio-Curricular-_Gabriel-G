library(shiny)
library(bslib)
library(shinyWidgets)
library(ggplot2)
library(dplyr)
#Definindo cards de plots
cards <- list(
  card(
    full_screen = TRUE,
    card_header("Série Temporal"),
    plotOutput("monthplot")
    
  ),
  card(
    full_screen = TRUE,
    card_header('Tabelas'),
    plotOutput('piram_et')
  )
)

selecionar_sexo <- pickerInput("sexo", "Selecione o sexo:", choices = c('Masculino', 'Feminino'))

selecionar_uf <- pickerInput("uf", "Selecione a UF:", choices = c('São Paulo', 'Santa Catarina', 'Paraná'))

selecionar_idade <- sliderInput('idade', 'Selecione o intervalo de idade desejado', min = 0, max = 100, value= c(0,100))

selecionar_data <- dateRangeInput("data", "Selecione a data de início e fim da análise:",
                                  start = "2010-01-01", end = "2024-05-31",
                                  min = "2010-01-01", max = "2024-05-31")
selecionar_ano <- pickerInput('ano', 'Selecione o ano',
                              choices = c(2010:2024))

botao <- actionButton("update", "Atualizar plot")

ui <- page_sidebar(
  title = 'EC1 - Gabriel',
  sidebar = list(
    selecionar_uf,
    selecionar_sexo,
    selecionar_idade,
    selecionar_data,
    selecionar_ano,
    botao
  ),
  navset_card_underline(
    title = 'Análises',
    nav_panel('Série temporal', cards[[1]]),
    nav_panel('Estatística descritiva', cards[[2]])
  )
)

